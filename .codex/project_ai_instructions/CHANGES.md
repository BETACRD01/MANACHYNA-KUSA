## Cambios relevantes (extracto)

- 2026-05-20: Se añadió la columna `fcm_token` en la tabla `users` para persistir
  tokens de Firebase Cloud Messaging. Migración incluida en `migrations/`.
- 2026-05-20: Se actualizó este paquete con snapshot seguro de la base real
  Supabase: tablas públicas, enums, RLS, buckets, funciones, triggers, índices
  y catálogo público. No incluye datos privados ni secretos.
- 2026-05-20: Se simplificó el paquete para cualquier IA eliminando
  placeholders no usados y el script local de `.env.local`.
- 2026-05-20: El contenido se movió a `.codex/project_ai_instructions/`
  y se renombró para presentarse como instrucciones del proyecto y skill
  para cualquier IA.

Detalles completos en el repo: `.codex/skills/manachyna-kusa/CHANGES.md`.
