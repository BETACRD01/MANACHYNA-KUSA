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
- Skill y documentación: `.codex/project_ai_instructions/PROJECT_SKILL.md`
- Registro de cambios: `.codex/project_ai_instructions/CHANGES.md`
- Borrador SQL incluido: `.codex/project_ai_instructions/migrations/supabase-schema-working-draft.sql`
- Supabase client wrapper: `lib/core/services/supabase_service.dart`
- Firebase messaging: `lib/core/services/firebase_service.dart`
- Supabase config: `lib/core/config/supabase_config.dart`
- Firebase options: `lib/firebase_options.dart` (contiene IDs, evita subir claves)
- Arquitectura de pantallas: `docs/mobile/architecture.md`
- Base de datos documentada: `docs/backend/database.md`
- Autenticación documentada: `docs/backend/AUTHENTICATION_AND_BACKEND.md`

Inyección de credenciales en runtime:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://ikdcqxgecjzgjntejizu.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrZGNxeGdlY2p6Z2pudGVqaXp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NjUyOTcsImV4cCI6MjA5NDQ0MTI5N30.9AOmDYBhvO0rPJ5Uq5AFXjRvvv4xfQP0xdyQCn3rKHs
```

Fallback actual en código:

```dart
class SupabaseConfig {
  static const String url = 'https://ikdcqxgecjzgjntejizu.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrZGNxeGdlY2p6Z2pudGVqaXp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NjUyOTcsImV4cCI6MjA5NDQ0MTI5N30.9AOmDYBhvO0rPJ5Uq5AFXjRvvv4xfQP0xdyQCn3rKHs';
  static const String profileImagesBucket = 'profile-images';
  static const String serviceImagesBucket = 'service-images';
}
```

Dónde están las credenciales (NO incluirlas en el paquete):
- Supabase URL y keys: se obtienen desde el panel de Supabase → Settings → API.
- Supabase anon key: existe en `lib/core/config/supabase_config.dart`; trátala
  como public/publishable, pero no la dupliques innecesariamente en paquetes.
- OAuth client secrets: panel de proveedor (Google/Facebook) — no subir.
- Firebase service files (GoogleService-Info.plist / google-services.json) —
  se encuentran en `android/app/` y `ios/Runner/` y no deben subirse a chats públicos.

Recomendación: comparte credenciales solo mediante un canal seguro y nunca
pegues claves privadas en el chat del asistente.
