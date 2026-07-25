import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const json = (body: Record<string, unknown>, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

async function requireAdmin(req: Request, admin: ReturnType<typeof createClient>) {
  const authorization = req.headers.get("Authorization") ?? "";
  const token = authorization.replace(/^Bearer\s+/i, "");
  if (!token) throw new Response("No autorizado.", { status: 401 });

  const authUser = await admin.auth.getUser(token);
  if (authUser.error || !authUser.data.user) {
    throw new Response("Sesion invalida.", { status: 401 });
  }

  const profile = await admin
    .from("users")
    .select("uid, role, is_active")
    .eq("uid", authUser.data.user.id)
    .limit(1)
    .maybeSingle();

  if (profile.error || profile.data?.role !== "admin" || profile.data?.is_active !== true) {
    throw new Response("Acceso denegado. Solo administradores.", { status: 403 });
  }

  return authUser.data.user;
}

async function countRows(admin: ReturnType<typeof createClient>, table: string, filter?: (q: any) => any) {
  let q = admin.from(table).select("id", { count: "exact", head: true });
  if (filter) q = filter(q);
  const r = await q;
  if (r.error) throw r.error;
  return r.count ?? 0;
}

async function overview(admin: ReturnType<typeof createClient>) {
  const [
    totalUsers, totalProviders, pendingProviders,
    activeProviders, totalBookings, pendingBookings,
    activeServices, completedBookings, cancelledBookings,
  ] = await Promise.all([
    countRows(admin, "users"),
    countRows(admin, "providers"),
    countRows(admin, "providers", (q) => q.eq("status", "pending")),
    countRows(admin, "providers", (q) => q.eq("is_active", true)),
    countRows(admin, "bookings"),
    countRows(admin, "bookings", (q) => q.eq("status", "pending")),
    countRows(admin, "provider_services", (q) => q.eq("is_active", true)),
    countRows(admin, "bookings", (q) => q.eq("status", "completed")),
    countRows(admin, "bookings", (q) => q.eq("status", "cancelled")),
  ]);

  const end = new Date();
  const start = new Date(end.getFullYear(), end.getMonth(), 1);
  const [newUsersThisMonth, newProvidersThisMonth] = await Promise.all([
    countRows(admin, "users", (q) => q.gte("created_at", start.toISOString())),
    countRows(admin, "providers", (q) => q.gte("created_at", start.toISOString())),
  ]);

  const [payments, ratings] = await Promise.all([
    admin
      .from("payments")
      .select("amount, status")
      .in("status", ["paid", "completed", "succeeded"]),
    admin
      .from("reviews")
      .select("rating")
      .eq("is_visible", true),
  ]);
  if (payments.error) throw payments.error;
  if (ratings.error) throw ratings.error;

  const revenueTotal = (payments.data ?? []).reduce(
    (sum: number, p: any) => sum + (Number(p.amount) || 0),
    0,
  );
  const validRatings = (ratings.data ?? [])
    .map((r: any) => Number(r.rating))
    .filter((rating: number) => Number.isFinite(rating) && rating > 0);
  const avgRating = validRatings.length > 0
    ? validRatings.reduce((sum: number, rating: number) => sum + rating, 0) / validRatings.length
    : 0;

  const providers = await admin
    .from("providers")
    .select("id, uid, name, full_name, email, phone, city, address, status, is_active, rating, reviews_count, created_at, updated_at")
    .order("created_at", { ascending: false })
    .limit(50);
  if (providers.error) throw providers.error;

  const bookings = await admin
    .from("bookings")
    .select("id, status, service_name, client_name, provider_name, total_amount, scheduled_date, created_at")
    .order("created_at", { ascending: false })
    .limit(8);
  if (bookings.error) throw bookings.error;

  return {
    stats: {
      total_users: totalUsers,
      total_providers: totalProviders,
      pending_providers: pendingProviders,
      active_providers: activeProviders,
      total_bookings: totalBookings,
      pending_bookings: pendingBookings,
      active_services: activeServices,
      completed_bookings: completedBookings,
      cancelled_bookings: cancelledBookings,
      revenue_total: revenueTotal,
      avg_rating: avgRating,
      new_users_this_month: newUsersThisMonth,
      new_providers_this_month: newProvidersThisMonth,
    },
    providers: providers.data ?? [],
    recent_bookings: bookings.data ?? [],
  };
}

async function reports(admin: ReturnType<typeof createClient>) {
  const privateSchema = admin.schema("private");
  const [overviewReport, dailyActivity, bookingStatus] = await Promise.all([
    privateSchema
      .from("report_overview")
      .select("sort_order, metric, value")
      .order("sort_order", { ascending: true }),
    privateSchema
      .from("report_daily_activity")
      .select("day, new_users, new_providers, bookings_created, bookings_completed, booking_amount, payments_amount, messages_sent")
      .order("day", { ascending: false })
      .limit(30),
    privateSchema
      .from("report_booking_status")
      .select("status, bookings, total_amount")
      .order("bookings", { ascending: false }),
  ]);

  if (overviewReport.error) throw overviewReport.error;
  if (dailyActivity.error) throw dailyActivity.error;
  if (bookingStatus.error) throw bookingStatus.error;

  return {
    overview: overviewReport.data ?? [],
    daily_activity: (dailyActivity.data ?? []).reverse(),
    booking_status: bookingStatus.data ?? [],
  };
}

async function listProviders(admin: ReturnType<typeof createClient>, body: Record<string, unknown>) {
  const page = Math.max(1, Number(body?.page) || 1);
  const pageSize = Math.min(100, Math.max(1, Number(body?.page_size) || 20));
  const search = typeof body?.search === "string" ? body.search.trim() : "";
  const status = typeof body?.status === "string" ? body.status.trim() : "";
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  let countQuery = admin.from("providers").select("id", { count: "exact", head: true });
  let dataQuery = admin
    .from("providers")
    .select("id, uid, name, full_name, email, phone, city, address, status, is_active, rating, reviews_count, created_at")
    .order("created_at", { ascending: false })
    .range(from, to);

  if (status && status !== "all") {
    const filter = status === "active" ? { is_active: true } : { status };
    countQuery = countQuery.match(filter);
    dataQuery = dataQuery.match(filter);
  }

  if (search) {
    const pattern = `%${search}%`;
    countQuery = countQuery.or(`name.ilike.${pattern},full_name.ilike.${pattern},email.ilike.${pattern},phone.ilike.${pattern}`);
    dataQuery = dataQuery.or(`name.ilike.${pattern},full_name.ilike.${pattern},email.ilike.${pattern},phone.ilike.${pattern}`);
  }

  const [countResult, dataResult] = await Promise.all([countQuery, dataQuery]);
  if (countResult.error) throw countResult.error;
  if (dataResult.error) throw dataResult.error;

  const items = (dataResult.data ?? []).map((p: any) => ({
    ...p,
    city: p.city ?? "",
    rating: p.rating ?? 0,
    reviews_count: p.reviews_count ?? 0,
  }));

  return json({
    items,
    total: countResult.count ?? 0,
    page,
    page_size: pageSize,
    has_more: (from + pageSize) < (countResult.count ?? 0),
  });
}

async function listBookings(admin: ReturnType<typeof createClient>, body: Record<string, unknown>) {
  const page = Math.max(1, Number(body?.page) || 1);
  const pageSize = Math.min(100, Math.max(1, Number(body?.page_size) || 20));
  const status = typeof body?.status === "string" ? body.status.trim() : "";
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  let countQuery = admin.from("bookings").select("id", { count: "exact", head: true });
  let dataQuery = admin
    .from("bookings")
    .select("id, status, service_name, client_name, provider_name, total_amount, scheduled_date, created_at")
    .order("created_at", { ascending: false })
    .range(from, to);

  if (status && status !== "all") {
    countQuery = countQuery.eq("status", status);
    dataQuery = dataQuery.eq("status", status);
  }

  const [countResult, dataResult] = await Promise.all([countQuery, dataQuery]);
  if (countResult.error) throw countResult.error;
  if (dataResult.error) throw dataResult.error;

  return json({
    items: dataResult.data ?? [],
    total: countResult.count ?? 0,
    page,
    page_size: pageSize,
    has_more: (from + pageSize) < (countResult.count ?? 0),
  });
}

async function listServices(admin: ReturnType<typeof createClient>) {
  const { data: services, error } = await admin
    .from("services")
    .select("id, name, is_active, base_price, created_at, category:service_categories(name)")
    .order("name", { ascending: true });

  if (error) throw error;

  const items = await Promise.all((services ?? []).map(async (s: any) => {
    const [provCount, bookCount] = await Promise.all([
      countRows(admin, "provider_services", (q) => q.eq("service_id", s.id).eq("is_active", true)),
      countRows(admin, "bookings", (q) => q.eq("service_name", s.name)),
    ]);
    return {
      id: s.id,
      name: s.name,
      category_name: s.category?.name ?? "",
      is_active: s.is_active,
      base_price: s.base_price ?? 0,
      provider_count: provCount,
      booking_count: bookCount,
      created_at: s.created_at,
    };
  }));

  return { services: items };
}

async function toggleService(admin: ReturnType<typeof createClient>, serviceId: unknown, isActive: unknown) {
  if (typeof serviceId !== "string") return json({ error: "service_id invalido." }, 400);
  const { error } = await admin
    .from("services")
    .update({ is_active: isActive === true, updated_at: new Date().toISOString() })
    .eq("id", serviceId);
  if (error) throw error;
  return json({ ok: true });
}

async function deleteService(admin: ReturnType<typeof createClient>, serviceId: unknown) {
  if (typeof serviceId !== "string") return json({ error: "service_id invalido." }, 400);
  const { error } = await admin.from("services").delete().eq("id", serviceId);
  if (error) throw error;
  return json({ ok: true });
}

async function setProviderStatus(admin: ReturnType<typeof createClient>, providerId: unknown, action: unknown) {
  if (typeof providerId !== "string" || providerId.length === 0) {
    return json({ error: "provider_id invalido." }, 400);
  }
  if (typeof action !== "string") {
    return json({ error: "Accion invalida." }, 400);
  }

  const provider = await admin.from("providers").select("id, uid").eq("id", providerId).limit(1).maybeSingle();
  if (provider.error) throw provider.error;
  if (!provider.data) return json({ error: "Proveedor no encontrado." }, 404);

  const now = new Date().toISOString();
  let status = "pending";
  let isActive = false;
  if (action === "approve" || action === "reactivate") {
    status = "approved";
    isActive = true;
  } else if (action === "suspend") {
    status = "suspended";
    isActive = false;
  } else {
    return json({ error: "Accion no soportada." }, 400);
  }

  const pUpdate = await admin.from("providers").update({ status, is_active: isActive, updated_at: now }).eq("id", providerId);
  if (pUpdate.error) throw pUpdate.error;

  const uUpdate = await admin.from("users").update({ is_provider: isActive, is_active: true, updated_at: now }).eq("uid", provider.data.uid);
  if (uUpdate.error) throw uUpdate.error;

  return json({ ok: true, provider_id: providerId, status, is_active: isActive });
}

async function overviewByRange(admin: ReturnType<typeof createClient>, body: Record<string, unknown>) {
  const from = typeof body?.from === "string" ? body.from : new Date(Date.now() - 30 * 86400000).toISOString();
  const to = typeof body?.to === "string" ? body.to : new Date().toISOString();

  const [totalUsers, totalProviders, pendingProviders, totalBookings, completedBookings] = await Promise.all([
    countRows(admin, "users", (q) => q.lte("created_at", to)),
    countRows(admin, "providers", (q) => q.lte("created_at", to)),
    countRows(admin, "providers", (q) => q.eq("status", "pending")),
    countRows(admin, "bookings", (q) => q.gte("created_at", from).lte("created_at", to)),
    countRows(admin, "bookings", (q) => q.eq("status", "completed").gte("created_at", from).lte("created_at", to)),
  ]);

  return json({
    stats: {
      total_users: totalUsers,
      total_providers: totalProviders,
      pending_providers: pendingProviders,
      active_providers: totalProviders,
      total_bookings: totalBookings,
      pending_bookings: 0,
      active_services: 0,
      completed_bookings: completedBookings,
      cancelled_bookings: 0,
      revenue_total: 0,
      avg_rating: 0,
      new_users_this_month: 0,
      new_providers_this_month: 0,
    },
    providers: [],
    recent_bookings: [],
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("ADMIN_SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceRoleKey) {
      return json({ error: "Faltan secretos de administrador." }, 500);
    }

    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    });
    await requireAdmin(req, admin);

    const body = await req.json().catch(() => ({}));
    const action = body?.action ?? "overview";

    switch (action) {
      case "overview":
        return json(await overview(admin));
      case "overview_by_range":
        return json(await overviewByRange(admin, body));
      case "reports":
        return json(await reports(admin));
      case "list_providers":
        return await listProviders(admin, body);
      case "list_bookings":
        return await listBookings(admin, body);
      case "list_services":
        return json(await listServices(admin));
      case "toggle_service":
        return await toggleService(admin, body?.service_id, body?.is_active);
      case "delete_service":
        return await deleteService(admin, body?.service_id);
      case "approve":
      case "suspend":
      case "reactivate":
        return await setProviderStatus(admin, body?.provider_id, action);
      default:
        return json({ error: "Accion no soportada." }, 400);
    }
  } catch (error) {
    if (error instanceof Response) return error;
    console.error("admin-dashboard:", error);
    const message = error instanceof Error ? error.message : String(error);
    return json({ error: "Error interno del panel admin.", details: message }, 500);
  }
});
