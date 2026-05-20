Stack técnico y rutas relevantes

Snapshot real verificado:
- Fecha: 2026-05-20
- Supabase project: `Mañachiy kan Kusata`
- Supabase ref: `ikdcqxgecjzgjntejizu`
- Supabase URL pública: `https://ikdcqxgecjzgjntejizu.supabase.co`
- Región: `us-east-2`
- Postgres: `17.6.1.121` (`ga`)
- Estado: `ACTIVE_HEALTHY`
- Firebase project ID: `manachyna-kusa-v2-2025`

Tecnologías principales:
- Flutter (mobile)
- Supabase (Auth, Postgres, Storage)
- Firebase (firebase_messaging)
- Dart packages: supabase_flutter, firebase_messaging, geolocator, etc.

Rutas útiles en el repo:
- Skill y documentación: `.codex/skills/manachyna-kusa/SKILL.md`
- Registro de cambios: `.codex/skills/manachyna-kusa/CHANGES.md`
- Borrador SQL incluido: `migrations/supabase-schema-working-draft.sql`
- Supabase client wrapper: `lib/core/services/supabase_service.dart`
- Firebase messaging: `lib/core/services/firebase_service.dart`
- Supabase config: `lib/core/config/supabase_config.dart`
- Firebase options: `lib/firebase_options.dart` (contiene IDs, evita subir claves)

Dónde están las credenciales (NO incluirlas en el paquete):
- Supabase URL y keys: se obtienen desde el panel de Supabase → Settings → API.
- Supabase anon key: existe en `lib/core/config/supabase_config.dart`; trátala
  como public/publishable, pero no la dupliques innecesariamente en paquetes.
- OAuth client secrets: panel de proveedor (Google/Facebook) — no subir.
- Firebase service files (GoogleService-Info.plist / google-services.json) —
  se encuentran en `android/app/` y `ios/Runner/` y no deben subirse a chats públicos.

Recomendación: comparte credenciales solo mediante un canal seguro y nunca
pegues claves privadas en el chat del asistente.
