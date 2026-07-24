import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const json = (body: Record<string, unknown>, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  try {
    const { access_token: facebookToken } = await req.json();
    if (typeof facebookToken !== "string" || facebookToken.length < 20) {
      return json({ error: "Token de Facebook invalido." }, 400);
    }

    const appId = Deno.env.get("FACEBOOK_APP_ID");
    const appSecret = Deno.env.get("FACEBOOK_APP_SECRET");
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("ADMIN_SERVICE_ROLE_KEY") ??
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!appId || !appSecret || !supabaseUrl || !serviceRoleKey) {
      return json({ error: "Faltan secretos de autenticacion del servidor." }, 500);
    }

    const appAccessToken = `${appId}|${appSecret}`;
    const debugUrl = new URL("https://graph.facebook.com/debug_token");
    debugUrl.searchParams.set("input_token", facebookToken);
    debugUrl.searchParams.set("access_token", appAccessToken);
    const debugResponse = await fetch(debugUrl);
    const debugPayload = await debugResponse.json();
    const tokenInfo = debugPayload?.data;

    if (
      !debugResponse.ok ||
      !tokenInfo?.is_valid ||
      String(tokenInfo.app_id) !== appId
    ) {
      return json({
        error: "El token de Facebook no es valido para esta app.",
        expected_app_id: appId,
        token_app_id: tokenInfo?.app_id ?? null,
        token_is_valid: tokenInfo?.is_valid ?? false,
        facebook_error: debugPayload?.error?.message ?? null,
      }, 401);
    }

    const profileUrl = new URL("https://graph.facebook.com/me");
    profileUrl.searchParams.set("fields", "id,name,email,picture.type(large)");
    profileUrl.searchParams.set("access_token", facebookToken);
    const profileResponse = await fetch(profileUrl);
    const profile = await profileResponse.json();
    if (!profileResponse.ok || !profile?.id) {
      return json({ error: "No se pudo obtener el perfil de Facebook." }, 401);
    }

    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    });

    const temporaryAvatarUrl = profile?.picture?.data?.url ??
      `https://graph.facebook.com/${profile.id}/picture?type=large`;
    let avatarUrl = temporaryAvatarUrl;
    try {
      const avatarResponse = await fetch(temporaryAvatarUrl);
      if (avatarResponse.ok) {
        const avatarBytes = new Uint8Array(await avatarResponse.arrayBuffer());
        const avatarPath = `facebook/${profile.id}.jpg`;
        const upload = await admin.storage.from("profile-images").upload(
          avatarPath,
          avatarBytes,
          { contentType: "image/jpeg", upsert: true },
        );
        if (!upload.error) {
          avatarUrl = admin.storage.from("profile-images").getPublicUrl(avatarPath).data.publicUrl;
        }
      }
    } catch (avatarError) {
      console.warn("No se pudo guardar la foto de Facebook:", avatarError);
    }

    const email = typeof profile.email === "string" && profile.email.length > 0
      ? profile.email.toLowerCase()
      : `facebook_${profile.id}@manachyna.invalid`;

    const facebookMetadata = {
      full_name: profile.name ?? "Usuario de Facebook",
      avatar_url: avatarUrl,
      provider: "facebook",
      facebook_id: String(profile.id),
    };
    const created = await admin.auth.admin.createUser({
      email,
      email_confirm: true,
      user_metadata: facebookMetadata,
    });
    const alreadyRegistered = created.error?.message
      ?.toLowerCase()
      .includes("already been registered");
    if (created.error && !alreadyRegistered) {
      return json({ error: created.error.message }, 500);
    }

    let authUserId = created.data.user?.id;
    if (!authUserId) {
      const users = await admin.auth.admin.listUsers({ page: 1, perPage: 1000 });
      const existing = users.data.users.find((candidate) =>
        candidate.email?.toLowerCase() === email ||
        candidate.user_metadata?.facebook_id === String(profile.id)
      );
      authUserId = existing?.id;
    }

    if (authUserId) {
      await admin.auth.admin.updateUserById(authUserId, {
        user_metadata: facebookMetadata,
      });
      await admin
        .from("users")
        .update({
          name: profile.name ?? "Usuario de Facebook",
          full_name: profile.name ?? "Usuario de Facebook",
          avatar_url: facebookMetadata.avatar_url,
        })
        .eq("uid", authUserId);
    }

    const link = await admin.auth.admin.generateLink({ type: "magiclink", email });
    const tokenHash = link.data.properties?.hashed_token;
    if (link.error || !tokenHash) {
      return json({ error: link.error?.message ?? "No se pudo crear la sesion." }, 500);
    }

    return json({ email, token_hash: tokenHash });
  } catch (error) {
    console.error("facebook-native-auth:", error);
    return json({ error: "Error interno validando Facebook." }, 500);
  }
});
