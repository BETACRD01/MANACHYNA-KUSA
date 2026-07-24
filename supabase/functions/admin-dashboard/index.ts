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

  if (
    profile.error ||
    profile.data?.role !== "admin" ||
    profile.data?.is_active !== true
  ) {
    throw new Response("Acceso denegado. Solo administradores.", { status: 403 });
  }

  return authUser.data.user;
}

async function countRows(
  admin: ReturnType<typeof createClient>,
  table: string,
  filter?: (query: any) => any,
) {
  let query = admin.from(table).select("id", { count: "exact", head: true });
  if (filter) query = filter(query);
  const result = await query;
  if (result.error) throw result.error;
  return result.count ?? 0;
}

async function overview(admin: ReturnType<typeof createClient>) {
  const [
    totalUsers,
    totalProviders,
    pendingProviders,
    activeProviders,
    totalBookings,
    pendingBookings,
    activeServices,
  ] = await Promise.all([
    countRows(admin, "users"),
    countRows(admin, "providers"),
    countRows(admin, "providers", (query) => query.eq("status", "pending")),
    countRows(admin, "providers", (query) => query.eq("is_active", true)),
    countRows(admin, "bookings"),
    countRows(admin, "bookings", (query) => query.eq("status", "pending")),
    countRows(admin, "provider_services", (query) => query.eq("is_active", true)),
  ]);

  const providers = await admin
    .from("providers")
    .select(`
      id,
      uid,
      name,
      full_name,
      email,
      phone,
      city,
      address,
      status,
      is_active,
      rating,
      reviews_count,
      created_at,
      updated_at
    `)
    .order("created_at", { ascending: false })
    .limit(50);
  if (providers.error) throw providers.error;

  const bookings = await admin
    .from("bookings")
    .select("id,status,service_name,client_name,provider_name,total_amount,scheduled_date,created_at")
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
    },
    providers: providers.data ?? [],
    recent_bookings: bookings.data ?? [],
  };
}

async function setProviderStatus(
  admin: ReturnType<typeof createClient>,
  providerId: unknown,
  action: unknown,
) {
  if (typeof providerId !== "string" || providerId.length === 0) {
    return json({ error: "provider_id invalido." }, 400);
  }
  if (typeof action !== "string") {
    return json({ error: "Accion invalida." }, 400);
  }

  const provider = await admin
    .from("providers")
    .select("id, uid")
    .eq("id", providerId)
    .limit(1)
    .maybeSingle();
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

  const providerUpdate = await admin
    .from("providers")
    .update({ status, is_active: isActive, updated_at: now })
    .eq("id", providerId);
  if (providerUpdate.error) throw providerUpdate.error;

  const userUpdate = await admin
    .from("users")
    .update({ is_provider: true, is_active: true, updated_at: now })
    .eq("uid", provider.data.uid);
  if (userUpdate.error) throw userUpdate.error;

  return json({ ok: true, provider_id: providerId, status, is_active: isActive });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("ADMIN_SERVICE_ROLE_KEY") ??
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceRoleKey) {
      return json({ error: "Faltan secretos de administrador." }, 500);
    }

    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    });
    await requireAdmin(req, admin);

    const body = await req.json().catch(() => ({}));
    const action = body?.action ?? "overview";
    if (action === "overview") return json(await overview(admin));
    if (action === "approve" || action === "suspend" || action === "reactivate") {
      return await setProviderStatus(admin, body?.provider_id, action);
    }

    return json({ error: "Accion no soportada." }, 400);
  } catch (error) {
    if (error instanceof Response) return error;
    console.error("admin-dashboard:", error);
    const message = error instanceof Error ? error.message : String(error);
    return json({ error: "Error interno del panel admin.", details: message }, 500);
  }
});
