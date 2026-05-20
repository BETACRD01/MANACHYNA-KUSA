<!-- Skill resumida del proyecto manachyna-kusa para cualquier IA -->

---
name: manachyna-kusa
description: Instrucciones del proyecto MANACHYNA KUSA: contexto, arquitectura y decisiones.
---

# MANACHYNA KUSA

Use this project skill when the task is about the Flutter app in this repository.

Quick rules (Spanish):
- Explanations in Spanish. Code in English.
- Prefer pragmatic solutions.
- Keep Firebase limited to messaging-only.
- Treat Supabase as source of truth.

Current decisions:
- Mobile auth: Supabase Auth (social OAuth)
- Firebase: messaging only
- Supabase: auth, Postgres, storage

References:
- repo references and SQL draft located in `.codex/skills/manachyna-kusa/`.
