# Cambios relacionados con la skill "manachyna-kusa"

## 2026-05-20 — Añadida columna `fcm_token` en `users`

- Motivo: la app persiste tokens de Firebase Cloud Messaging (FCM) en la tabla
  `users` para envío de notificaciones dirigidas.
- Implementación: `lib/core/services/firebase_service.dart` guarda el token
  y escucha renovaciones con `messaging.onTokenRefresh`.
- Acción aplicada en la BD (en vivo): se añadió la columna `fcm_token`.
- SQL idempotente recomendado (ya aplicado en la base de datos en vivo):

```sql
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS fcm_token text;

CREATE INDEX IF NOT EXISTS users_fcm_token_idx ON public.users(fcm_token);
```

- Notas:
  - Evitar ejecutar `ALTER TABLE ... ADD COLUMN` sin `IF NOT EXISTS` en
    entornos donde la columna pueda existir (evita error 42701).
  - Si usas migraciones versionadas (Supabase migrations o similar), añade
    el SQL anterior como un archivo de migración y aplícalo con el flujo
    habitual.
