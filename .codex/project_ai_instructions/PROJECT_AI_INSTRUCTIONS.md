MANACHYNA KUSA — Instrucciones y contexto del proyecto para cualquier IA

Contenido preparado para que cualquier IA entienda rapido el proyecto,
su stack, decisiones tecnicas y contexto de base de datos.
Actualizado con la base real de Supabase el 2026-05-20 usando el proyecto
`ikdcqxgecjzgjntejizu` (`Mañachiy kan Kusata`).

Importante: este paquete NO incluye credenciales privadas ni secretos. La base
real se documenta como esquema, políticas, buckets y datos públicos de catálogo.
No se exportan filas privadas de usuarios, tokens FCM ni OAuth client secrets.

Archivos incluidos:
- `PROJECT_SKILL.md` — skill resumida del proyecto (contexto y decisiones de producto).
- `CHANGES.md` — registro de cambios relevantes recientes.
- `migrations/supabase-schema-working-draft.sql` — borrador amplio del esquema
  SQL del proyecto.
- `ENVIRONMENT.md` — breve descripción del stack técnico y rutas a ficheros
  de configuración en el repo.
- `references/live-supabase-schema.md` — snapshot seguro del esquema real
  de Supabase, RLS, buckets, funciones e índices.
- `references/public-catalog-seed.json` — datos públicos de catálogo
  (`service_categories` y `services`) exportados sin PII.
- `PROJECT_CREDENTIALS_SAFE.md` — inventario de credenciales y valores
  públicos/redactados.
- `.env.example` — plantilla mínima con las variables realmente requeridas
  por la app (`SUPABASE_URL` y `SUPABASE_ANON_KEY`).
- `manifest.json` — listado de archivos incluidos y propósito.

Instrucciones rápidas:
1. Revisa `.env.example` solo si una IA necesita ubicar las variables mínimas
   que usa la app.
2. Usa `PROJECT_AI_INSTRUCTIONS.md` como punto de entrada.
3. Si una IA solicita credenciales o accesos, usa `PROJECT_CREDENTIALS_SAFE.md`
   como guía y comparte secretos solo por un canal seguro.

Propósito: dar a cualquier IA contexto completo del proyecto
(arquitectura, dependencias, skill, decisiones y estado de Supabase)
sin exponer secretos.
