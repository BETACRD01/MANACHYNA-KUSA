const html = `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Politica de privacidad - MANACHYNA KUSA</title>
  <style>
    :root { --green: #176b32; --dark: #173022; --muted: #607066; --line: #dfe9e1; --soft: #f3f8f3; }
    * { box-sizing: border-box; }
    body { margin: 0; background: #eef5ef; color: var(--dark); font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; line-height: 1.7; }
    .shell { max-width: 980px; margin: 0 auto; padding: 28px 18px 56px; }
    .topbar { display: flex; align-items: center; justify-content: space-between; gap: 20px; margin-bottom: 24px; }
    .brand { display: flex; align-items: center; gap: 12px; font-weight: 800; letter-spacing: .04em; color: var(--green); }
    .mark { display: grid; place-items: center; width: 42px; height: 42px; border-radius: 13px; background: var(--green); color: white; font-size: 20px; }
    .language { color: var(--muted); font-size: 13px; }
    .hero { padding: 42px 42px 36px; border-radius: 24px; background: white; border: 1px solid var(--line); box-shadow: 0 16px 40px rgba(23, 48, 34, .08); }
    .eyebrow { margin: 0 0 10px; color: var(--green); font-size: 13px; font-weight: 800; letter-spacing: .1em; text-transform: uppercase; }
    h1 { margin: 0; max-width: 700px; color: var(--dark); font-size: clamp(32px, 6vw, 58px); line-height: 1.08; letter-spacing: -.03em; }
    .intro { max-width: 680px; margin: 18px 0 0; color: var(--muted); font-size: 17px; }
    .updated { display: inline-flex; margin-top: 22px; padding: 7px 12px; border-radius: 999px; background: var(--soft); color: var(--green); font-size: 13px; font-weight: 700; }
    .content { display: grid; grid-template-columns: 220px minmax(0, 1fr); gap: 28px; margin-top: 24px; }
    .toc { align-self: start; position: sticky; top: 18px; padding: 20px; border: 1px solid var(--line); border-radius: 16px; background: white; }
    .toc strong { display: block; margin-bottom: 10px; font-size: 13px; text-transform: uppercase; letter-spacing: .08em; color: var(--muted); }
    .toc a { display: block; padding: 7px 0; color: var(--green); font-size: 14px; text-decoration: none; }
    .document { padding: 14px 34px 28px; border: 1px solid var(--line); border-radius: 20px; background: white; }
    section { padding: 24px 0; border-bottom: 1px solid var(--line); }
    section:last-child { border-bottom: 0; }
    h2 { margin: 0 0 8px; color: var(--green); font-size: 21px; letter-spacing: -.01em; }
    p { margin: 8px 0 0; color: #43534a; }
    a { color: var(--green); font-weight: 700; }
    .contact { margin-top: 24px; padding: 22px; border-radius: 16px; background: var(--soft); }
    footer { padding: 24px 0 0; color: var(--muted); text-align: center; font-size: 13px; }
    @media (max-width: 700px) {
      .shell { padding: 16px 12px 36px; }
      .hero { padding: 30px 22px 26px; border-radius: 18px; }
      .topbar { margin-bottom: 16px; }
      .content { display: block; margin-top: 16px; }
      .toc { position: static; margin-bottom: 16px; }
      .document { padding: 4px 22px 18px; border-radius: 18px; }
      .language { display: none; }
    }
  </style>
</head>
<body>
  <main class="shell">
    <div class="topbar"><div class="brand"><span class="mark">M</span><span>MANACHYNA KUSA</span></div><span class="language">Privacidad y confianza</span></div>
    <header class="hero"><p class="eyebrow">Centro de privacidad</p><h1>Tu información merece claridad.</h1><p class="intro">Conoce qué datos usamos en MANACHYNA KUSA, para qué los necesitamos y cómo puedes solicitar su eliminación.</p><span class="updated">Última actualización · 24 de julio de 2026</span></header>
    <div class="content">
      <nav class="toc"><strong>En esta página</strong><a href="#datos">Datos que recopilamos</a><a href="#uso">Uso de la información</a><a href="#terceros">Servicios de terceros</a><a href="#eliminacion">Eliminar mis datos</a><a href="#contacto">Contacto</a></nav>
      <article class="document">
        <section id="datos"><h2>1. Información que recopilamos</h2><p>Podemos recibir nombre, correo electrónico, foto de perfil e identificador de cuenta cuando inicias sesión con Google, Facebook o Microsoft. También podemos recibir los datos que agregues voluntariamente a tu perfil, como teléfono, ciudad, dirección y preferencias de servicio.</p></section>
        <section id="uso"><h2>2. Cómo usamos la información</h2><p>Usamos estos datos para crear y proteger tu cuenta, mostrar tu perfil, permitir reservas y solicitudes de servicios, enviar notificaciones relacionadas con la aplicación y mejorar la seguridad y funcionamiento de MANACHYNA KUSA.</p></section>
        <section id="terceros"><h2>3. Servicios de terceros</h2><p>La autenticación puede realizarse mediante Google, Facebook o Microsoft. Los datos se procesan de acuerdo con sus respectivas políticas de privacidad. Usamos Supabase para autenticación, almacenamiento y base de datos.</p></section>
        <section><h2>4. Compartición de datos</h2><p>No vendemos tus datos personales. Solo compartimos información cuando es necesaria para operar funciones solicitadas dentro de la aplicación, cumplir obligaciones legales o proteger la seguridad de los usuarios.</p></section>
        <section><h2>5. Seguridad y conservación</h2><p>Aplicamos controles de acceso y medidas razonables para proteger la información. Conservamos los datos mientras mantengas tu cuenta o cuando sea necesario para prestar el servicio y cumplir obligaciones legales.</p></section>
        <section id="eliminacion"><h2>6. Eliminación de datos</h2><p>Puedes solicitar la eliminación de tu cuenta y datos escribiendo a <a href="mailto:willian.cerda@est.itstena.edu.ec">willian.cerda@est.itstena.edu.ec</a>. Verificaremos la solicitud y eliminaremos los datos que no debamos conservar por razones legales o de seguridad.</p></section>
        <section id="contacto" class="contact"><h2>7. Contacto</h2><p>Para preguntas sobre privacidad, escribe a <a href="mailto:willian.cerda@est.itstena.edu.ec">willian.cerda@est.itstena.edu.ec</a>.</p></section>
      </article>
    </div>
    <footer>MANACHYNA KUSA · Información clara para una experiencia segura</footer>
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
