import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

type JwtHeader = {
  alg?: string;
  kid?: string;
};

type MicrosoftClaims = {
  aud?: string;
  exp?: number;
  nbf?: number;
  iss?: string;
  oid?: string;
  sub?: string;
  name?: string;
  email?: string;
  preferred_username?: string;
};

const json = (body: Record<string, unknown>, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

const base64UrlToBytes = (value: string) => {
  const padded = value.replace(/-/g, "+").replace(/_/g, "/").padEnd(
    Math.ceil(value.length / 4) * 4,
    "=",
  );
  return Uint8Array.from(atob(padded), (char) => char.charCodeAt(0));
};

const parseJwtPart = <T>(value: string): T =>
  JSON.parse(new TextDecoder().decode(base64UrlToBytes(value))) as T;

async function verifyMicrosoftIdToken(
  idToken: string,
  clientId: string,
): Promise<MicrosoftClaims> {
  const parts = idToken.split(".");
  if (parts.length !== 3) throw new Error("JWT incompleto.");

  const header = parseJwtPart<JwtHeader>(parts[0]);
  const claims = parseJwtPart<MicrosoftClaims>(parts[1]);
  if (header.alg !== "RS256" || !header.kid) {
    throw new Error("Algoritmo de token no soportado.");
  }

  const discoveryResponse = await fetch(
    "https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration",
  );
  const discovery = await discoveryResponse.json();
  const jwksResponse = await fetch(discovery.jwks_uri);
  const jwks = await jwksResponse.json();
  const jwk = jwks.keys?.find((key: JsonWebKey & { kid?: string }) =>
    key.kid === header.kid
  );
  if (!jwk) throw new Error("No se encontro la llave publica de Microsoft.");

  const key = await crypto.subtle.importKey(
    "jwk",
    jwk,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["verify"],
  );
  const signatureIsValid = await crypto.subtle.verify(
    "RSASSA-PKCS1-v1_5",
    key,
    base64UrlToBytes(parts[2]),
    new TextEncoder().encode(`${parts[0]}.${parts[1]}`),
  );
  if (!signatureIsValid) throw new Error("Firma del token invalida.");

  const now = Math.floor(Date.now() / 1000);
  if (claims.aud !== clientId) throw new Error("Token emitido para otra app.");
  if (typeof claims.exp !== "number" || claims.exp <= now) {
    throw new Error("Token expirado.");
  }
  if (typeof claims.nbf === "number" && claims.nbf > now + 60) {
    throw new Error("Token aun no es valido.");
  }
  if (
    typeof claims.iss !== "string" ||
    !claims.iss.startsWith("https://login.microsoftonline.com/") ||
    !claims.iss.endsWith("/v2.0")
  ) {
    throw new Error("Emisor de Microsoft invalido.");
  }

  return claims;
}

async function fetchGraphProfile(accessToken?: string) {
  if (!accessToken) return null;

  try {
    const response = await fetch(
      "https://graph.microsoft.com/v1.0/me?$select=id,displayName,mail,userPrincipalName",
      { headers: { Authorization: `Bearer ${accessToken}` } },
    );
    if (!response.ok) return null;
    return await response.json();
  } catch (error) {
    console.warn("No se pudo leer perfil de Microsoft Graph:", error);
    return null;
  }
}

async function uploadMicrosoftAvatar(
  admin: ReturnType<typeof createClient>,
  microsoftId: string,
  accessToken?: string,
) {
  if (!accessToken) return null;

  try {
    const response = await fetch("https://graph.microsoft.com/v1.0/me/photo/$value", {
      headers: { Authorization: `Bearer ${accessToken}` },
    });
    if (!response.ok) return null;

    const contentType = response.headers.get("content-type") ?? "image/jpeg";
    const extension = contentType.includes("png") ? "png" : "jpg";
    const avatarPath = `microsoft/${microsoftId}.${extension}`;
    const avatarBytes = new Uint8Array(await response.arrayBuffer());
    const upload = await admin.storage.from("profile-images").upload(
      avatarPath,
      avatarBytes,
      { contentType, upsert: true },
    );
    if (upload.error) return null;
    return admin.storage.from("profile-images").getPublicUrl(avatarPath).data.publicUrl;
  } catch (error) {
    console.warn("No se pudo guardar la foto de Microsoft:", error);
    return null;
  }
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  try {
    const { id_token: idToken, access_token: accessToken } = await req.json();
    if (typeof idToken !== "string" || idToken.length < 20) {
      return json({ error: "Token de Microsoft invalido." }, 400);
    }

    const microsoftClientId = Deno.env.get("MICROSOFT_CLIENT_ID");
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("ADMIN_SERVICE_ROLE_KEY") ??
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!microsoftClientId || !supabaseUrl || !serviceRoleKey) {
      return json({ error: "Faltan secretos de autenticacion del servidor." }, 500);
    }

    const claims = await verifyMicrosoftIdToken(idToken, microsoftClientId);
    const graphProfile = await fetchGraphProfile(
      typeof accessToken === "string" ? accessToken : undefined,
    );
    const microsoftId = String(graphProfile?.id ?? claims.oid ?? claims.sub);
    if (!microsoftId || microsoftId === "undefined") {
      return json({ error: "Microsoft no devolvio identificador de usuario." }, 401);
    }

    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    });

    const displayName = String(
      graphProfile?.displayName ?? claims.name ?? "Usuario de Microsoft",
    );
    const rawEmail = graphProfile?.mail ?? graphProfile?.userPrincipalName ??
      claims.email ?? claims.preferred_username;
    const email = typeof rawEmail === "string" && rawEmail.includes("@")
      ? rawEmail.toLowerCase()
      : `microsoft_${microsoftId}@manachyna.invalid`;
    const avatarUrl = await uploadMicrosoftAvatar(
      admin,
      microsoftId,
      typeof accessToken === "string" ? accessToken : undefined,
    );

    const microsoftMetadata = {
      full_name: displayName,
      name: displayName,
      provider: "microsoft",
      microsoft_id: microsoftId,
      ...(avatarUrl ? { avatar_url: avatarUrl } : {}),
    };
    const created = await admin.auth.admin.createUser({
      email,
      email_confirm: true,
      user_metadata: microsoftMetadata,
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
        candidate.user_metadata?.microsoft_id === microsoftId
      );
      authUserId = existing?.id;
    }

    if (authUserId) {
      await admin.auth.admin.updateUserById(authUserId, {
        user_metadata: microsoftMetadata,
      });
      await admin
        .from("users")
        .update({
          name: displayName,
          full_name: displayName,
          ...(avatarUrl ? { avatar_url: avatarUrl } : {}),
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
    console.error("microsoft-native-auth:", error);
    return json({
      error: error instanceof Error
        ? error.message
        : "Error interno validando Microsoft.",
    }, 401);
  }
});
