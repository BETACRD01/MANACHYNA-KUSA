const html = `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Condiciones del servicio - MANACHYNA KUSA</title>
  <style>
    :root { --green: #176b32; --dark: #173022; --muted: #607066; --line: #dfe9e1; --soft: #f3f8f3; }
    * { box-sizing: border-box; }
    body { margin: 0; background: #eef5ef; color: var(--dark); font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; line-height: 1.7; }
    .shell { max-width: 980px; margin: 0 auto; padding: 28px 18px 56px; }
    .topbar { display: flex; align-items: center; justify-content: space-between; gap: 20px; margin-bottom: 24px; }
    .brand { display: flex; align-items: center; gap: 12px; font-weight: 800; letter-spacing: .04em; color: var(--green); }
    .mark { display: grid; place-items: center; width: 42px; height: 42px; border-radius: 13px; background: var(--green); color: white; font-size: 20px; }
    .language { color: var(--muted); font-size: 13px; }
    .hero, .document { background: white; border: 1px solid var(--line); box-shadow: 0 16px 40px rgba(23, 48, 34, .08); }
    .hero { padding: 42px; border-radius: 24px; }
    .eyebrow { margin: 0 0 10px; color: var(--green); font-size: 13px; font-weight: 800; letter-spacing: .1em; text-transform: uppercase; }
    h1 { margin: 0; max-width: 700px; font-size: clamp(32px, 6vw, 58px); line-height: 1.08; letter-spacing: -.03em; }
    .intro { max-width: 680px; margin: 18px 0 0; color: var(--muted); font-size: 17px; }
    .updated { display: inline-flex; margin-top: 22px; padding: 7px 12px; border-radius: 999px; background: var(--soft); color: var(--green); font-size: 13px; font-weight: 700; }
    .content { max-width: 760px; margin: 24px auto 0; }
    .document { padding: 14px 38px 30px; border-radius: 20px; }
    section { padding: 24px 0; border-bottom: 1px solid var(--line); }
    section:last-child { border-bottom: 0; }
    h2 { margin: 0 0 8px; color: var(--green); font-size: 21px; }
    p, li { color: #43534a; }
    a { color: var(--green); font-weight: 700; }
    footer { padding: 24px 0 0; color: var(--muted); text-align: center; font-size: 13px; }
    @media (max-width: 700px) { .shell { padding: 16px 12px 36px; } .hero { padding: 30px 22px 26px; border-radius: 18px; } .document { padding: 4px 22px 18px; border-radius: 18px; } .language { display: none; } }
  </style>
</head>
<body>
  <main class="shell">
    <div class="topbar"><div class="brand"><span class="mark">M</span><span>MANACHYNA KUSA</span></div><span class="language">Condiciones del servicio</span></div>
    <header class="hero"><p class="eyebrow">Acuerdo de uso</p><h1>Condiciones claras para usar la aplicación.</h1><p class="intro">Estas condiciones explican las reglas para utilizar MANACHYNA KUSA y los servicios disponibles dentro de la aplicación.</p><span class="updated">Última actualización · 24 de julio de 2026</span></header>
    <div class="content"><article class="document">
      <section><h2>1. Aceptación</h2><p>Al crear una cuenta o utilizar MANACHYNA KUSA, aceptas estas condiciones. Si no estás de acuerdo, no debes utilizar la aplicación.</p></section>
      <section><h2>2. Uso de la aplicación</h2><p>Debes proporcionar información verdadera, mantener segura tu cuenta y utilizar la aplicación de forma legal y respetuosa. No puedes intentar acceder sin autorización a cuentas, sistemas o datos de otros usuarios.</p></section>
      <section><h2>3. Cuentas y autenticación</h2><p>Puedes iniciar sesión mediante proveedores externos como Google, Facebook o Microsoft. Eres responsable de la actividad realizada desde tu cuenta y de mantener actualizados tus datos de contacto.</p></section>
      <section><h2>4. Servicios y reservas</h2><p>MANACHYNA KUSA facilita la conexión entre usuarios y proveedores de servicios. La disponibilidad, precios, horarios y condiciones particulares pueden depender del proveedor correspondiente.</p></section>
      <section><h2>5. Contenido y conducta</h2><p>No publiques contenido falso, ilegal, ofensivo o que infrinja derechos de terceros. Podemos limitar o suspender cuentas que incumplan estas condiciones o comprometan la seguridad de la plataforma.</p></section>
      <section><h2>6. Disponibilidad</h2><p>Trabajamos para mantener la aplicación disponible y segura, pero pueden ocurrir interrupciones por mantenimiento, actualizaciones o causas fuera de nuestro control.</p></section>
      <section><h2>7. Privacidad y eliminación de datos</h2><p>El tratamiento de datos personales se explica en nuestra <a href="https://ikdcqxgecjzgjntejizu.supabase.co/functions/v1/privacy-policy">política de privacidad</a>. Puedes solicitar la eliminación de tu cuenta escribiendo a <a href="mailto:willian.cerda@est.itstena.edu.ec">willian.cerda@est.itstena.edu.ec</a>.</p></section>
      <section><h2>8. Contacto</h2><p>Para preguntas sobre estas condiciones, escribe a <a href="mailto:willian.cerda@est.itstena.edu.ec">willian.cerda@est.itstena.edu.ec</a>.</p></section>
    </article></div>
    <footer>MANACHYNA KUSA · Gracias por utilizar la plataforma de forma responsable</footer>
  </main>
</body>
</html>`;

Deno.serve(() => new Response(html, {
  headers: {
    "Content-Type": "text/html; charset=utf-8",
    "X-Content-Type-Options": "nosniff",
    "Cache-Control": "no-store, max-age=0",
  },
}));
