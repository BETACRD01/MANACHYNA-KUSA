import "jsr:@supabase/functions-js/edge-runtime.d.ts";

type Page = {
  title: string;
  label: string;
  heading: string;
  intro: string;
  sections: Array<{ title: string; body: string }>;
};

const privacy: Page = {
  title: "Politica de privacidad - MANACHYNA KUSA",
  label: "Privacidad y confianza",
  heading: "Tu informacion merece claridad.",
  intro:
    "Conoce que datos usamos en MANACHYNA KUSA, para que los necesitamos y como puedes solicitar su eliminacion.",
  sections: [
    {
      title: "1. Informacion que recopilamos",
      body:
        "Podemos recibir nombre, correo electronico, foto de perfil e identificador de cuenta cuando inicias sesion con Google, Facebook o Microsoft. Tambien podemos recibir los datos que agregues voluntariamente a tu perfil, como telefono, ciudad, direccion y preferencias de servicio.",
    },
    {
      title: "2. Como usamos la informacion",
      body:
        "Usamos estos datos para crear y proteger tu cuenta, mostrar tu perfil, permitir reservas y solicitudes de servicios, enviar notificaciones relacionadas con la aplicacion y mejorar la seguridad y funcionamiento de MANACHYNA KUSA.",
    },
    {
      title: "3. Servicios de terceros",
      body:
        "La autenticacion puede realizarse mediante Google, Facebook o Microsoft. Los datos se procesan de acuerdo con sus respectivas politicas de privacidad. Usamos Supabase para autenticacion, almacenamiento y base de datos.",
    },
    {
      title: "4. Seguridad y conservacion",
      body:
        "Aplicamos controles de acceso y medidas razonables para proteger la informacion. Conservamos los datos mientras mantengas tu cuenta o cuando sea necesario para prestar el servicio y cumplir obligaciones legales.",
    },
    {
      title: "5. Eliminacion de datos",
      body:
        "Puedes solicitar la eliminacion de tu cuenta y datos escribiendo a willian.cerda@est.itstena.edu.ec. Verificaremos la solicitud y eliminaremos los datos que no debamos conservar por razones legales o de seguridad.",
    },
  ],
};

const terms: Page = {
  title: "Terminos y condiciones - MANACHYNA KUSA",
  label: "Acuerdo de uso",
  heading: "Condiciones claras para usar la aplicacion.",
  intro:
    "Estas condiciones explican las reglas para utilizar MANACHYNA KUSA y los servicios disponibles dentro de la aplicacion.",
  sections: [
    {
      title: "1. Aceptacion",
      body:
        "Al crear una cuenta o utilizar MANACHYNA KUSA, aceptas estas condiciones. Si no estas de acuerdo, no debes utilizar la aplicacion.",
    },
    {
      title: "2. Uso de la aplicacion",
      body:
        "Debes proporcionar informacion verdadera, mantener segura tu cuenta y utilizar la aplicacion de forma legal y respetuosa. No puedes intentar acceder sin autorizacion a cuentas, sistemas o datos de otros usuarios.",
    },
    {
      title: "3. Cuentas y autenticacion",
      body:
        "Puedes iniciar sesion mediante proveedores externos como Google, Facebook o Microsoft. Eres responsable de la actividad realizada desde tu cuenta y de mantener actualizados tus datos de contacto.",
    },
    {
      title: "4. Servicios y reservas",
      body:
        "MANACHYNA KUSA facilita la conexion entre usuarios y proveedores de servicios. La disponibilidad, precios, horarios y condiciones particulares pueden depender del proveedor correspondiente.",
    },
    {
      title: "5. Conducta y seguridad",
      body:
        "No publiques contenido falso, ilegal, ofensivo o que infrinja derechos de terceros. Podemos limitar o suspender cuentas que incumplan estas condiciones o comprometan la seguridad de la plataforma.",
    },
    {
      title: "6. Privacidad",
      body:
        "El tratamiento de datos personales se explica en nuestra politica de privacidad. Puedes solicitar la eliminacion de tu cuenta escribiendo a willian.cerda@est.itstena.edu.ec.",
    },
  ],
};

const escapeHtml = (value: string) =>
  value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");

function render(page: Page) {
  const sections = page.sections
    .map((section) =>
      `<section><h2>${escapeHtml(section.title)}</h2><p>${escapeHtml(section.body)}</p></section>`
    )
    .join("");

  return `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${escapeHtml(page.title)}</title>
<style>
:root{--green:#176b32;--green2:#2f8f46;--ink:#173022;--muted:#617369;--line:#dfe9e1;--soft:#f3f8f3}
*{box-sizing:border-box}
body{margin:0;background:#eef5ef;color:var(--ink);font-family:Inter,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;line-height:1.7}
.shell{max-width:960px;margin:0 auto;padding:28px 16px 54px}
.nav{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:22px}
.brand{display:flex;align-items:center;gap:12px;color:var(--green);font-weight:900;letter-spacing:.04em}
.mark{display:grid;place-items:center;width:42px;height:42px;border-radius:12px;background:var(--green);color:#fff;font-weight:900}
.badge{color:var(--muted);font-size:13px;font-weight:700}
.hero{padding:40px;border-radius:22px;background:linear-gradient(135deg,var(--green),var(--green2));color:#fff;box-shadow:0 18px 48px rgba(23,48,34,.20)}
.eyebrow{margin:0 0 10px;color:rgba(255,255,255,.76);font-size:12px;font-weight:900;letter-spacing:.12em;text-transform:uppercase}
h1{margin:0;max-width:720px;font-size:clamp(34px,7vw,62px);line-height:1.05;letter-spacing:-.03em}
.intro{max-width:700px;margin:16px 0 0;color:rgba(255,255,255,.9);font-size:17px}
.updated{display:inline-flex;margin-top:20px;padding:7px 12px;border-radius:999px;background:rgba(255,255,255,.14);font-size:13px;font-weight:800}
.document{margin-top:20px;padding:8px 36px 30px;border:1px solid var(--line);border-radius:18px;background:#fff;box-shadow:0 16px 40px rgba(23,48,34,.08)}
section{padding:24px 0;border-bottom:1px solid var(--line)}
section:last-child{border-bottom:0}
h2{margin:0 0 8px;color:var(--green);font-size:21px;line-height:1.25}
p{margin:0;color:#43534a}
.contact{margin-top:18px;padding:18px;border-radius:14px;background:var(--soft);color:var(--muted)}
footer{padding:24px 0 0;text-align:center;color:var(--muted);font-size:13px}
@media(max-width:700px){.shell{padding:14px 10px 34px}.nav{margin-bottom:14px}.hero{padding:28px 20px;border-radius:18px}.document{padding:2px 18px 20px;border-radius:16px}.badge{display:none}}
</style>
</head>
<body>
<main class="shell">
<nav class="nav"><div class="brand"><span class="mark">M</span><span>MANACHYNA KUSA</span></div><span class="badge">${escapeHtml(page.label)}</span></nav>
<header class="hero"><p class="eyebrow">${escapeHtml(page.label)}</p><h1>${escapeHtml(page.heading)}</h1><p class="intro">${escapeHtml(page.intro)}</p><span class="updated">Ultima actualizacion: 24 de julio de 2026</span></header>
<article class="document">${sections}<div class="contact"><strong>Contacto:</strong> willian.cerda@est.itstena.edu.ec</div></article>
<footer>MANACHYNA KUSA - Documento legal publico</footer>
</main>
</body>
</html>`;
}

Deno.serve((req) => {
  const path = new URL(req.url).pathname;
  const page = path.includes("/terms") ? terms : privacy;
  return new Response(render(page), {
    status: 200,
    headers: {
      "content-type": "text/html; charset=utf-8",
      "cache-control": "no-store, max-age=0",
      "x-content-type-options": "nosniff",
    },
  });
});
