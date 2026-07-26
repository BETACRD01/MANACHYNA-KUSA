## Cambios relevantes (extracto)

- 2026-07-25: **Refactor a Modelos Inmutables (Freezed)** — Todos los modelos en `lib/models/` (`user`, `booking`, `service`, `review`, `notification`, `custom_task`) fueron migrados a `Freezed` + `json_serializable`. Se encapsularon en subcarpetas independientes y se actualizaron más de 80 rutas de importación.
- 2026-07-25: **Refactor arquitectural completo** — La carpeta `lib/screens/` fue reorganizada
  en Arquitectura Basada en Roles (Actor-Feature Architecture):
  - `screens/admin/`: Panel de administración.
  - `screens/auth/`: Flujos de login con subcarpetas `ui/`, `controllers/`, `widgets/`.
  - `screens/customer/`: Módulos `home/`, `bookings/`, `chat/`, `profile/` con separación
    estricta de `ui/`, `widgets/`, `controllers/` y `data/`.
  - `screens/provider/`: Módulos `overview/`, `bookings/`, `services/`, `work_feed/`, `profile/`.
  - `screens/common/`: Pantallas globales compartidas entre roles (Splash, Mapa).
- 2026-07-25: Se creó `LoginController` para extraer la lógica de estado de `login_content.dart`.
- 2026-07-25: Se reorganizó `docs/` en dos grandes áreas separadas:
  - `docs/mobile/`: Arquitectura Flutter, dependencias, flujo de trabajo.
  - `docs/backend/`: Base de datos (PostgreSQL/Supabase), autenticación, seguridad (RLS).
- 2026-07-25: `docs/backend/database.md` actualizado con el esquema real verificado
  mediante `supabase gen types --lang typescript --linked`.
- 2026-07-25: Corregido el README.md: se reemplazó la mención incorrecta de "Firebase Auth"
  por "Supabase Auth (Google, Facebook, Microsoft)".
- 2026-05-20: Se añadió la columna `fcm_token` en la tabla `users` para persistir
  tokens de Firebase Cloud Messaging. Migración incluida en `migrations/`.
- 2026-05-20: Se actualizó este paquete con snapshot seguro de la base real
  Supabase: tablas públicas, enums, RLS, buckets, funciones, triggers, índices
  y catálogo público. No incluye datos privados ni secretos.
- 2026-05-20: El contenido se movió a `.codex/project_ai_instructions/`
  y se renombró para presentarse como instrucciones del proyecto y skill
  para cualquier IA.
- 2026-05-20: Se añadió la referencia explícita a la inyección de credenciales
  Supabase con `flutter run --dart-define=...` y al `SupabaseConfig` vigente.

Detalles completos en el repo: `.codex/project_ai_instructions/CHANGES.md`.

