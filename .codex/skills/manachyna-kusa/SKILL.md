---
name: manachyna-kusa
description: Use when working on the Proyecto_final_2025 Flutter app for MANACHYNA KUSA. Covers the current app architecture, Supabase-first backend decisions, Firebase Messaging-only usage, social OAuth setup, branding, and the evolving database draft. Use this skill for feature work, bug fixes, auth issues, setup, documentation, and schema-aware changes in this project.
---

# MANACHYNA KUSA

Use this skill when the task is about the Flutter app in this repository.

## Quick rules

- Explanations in Spanish. Code in English.
- Prefer pragmatic solutions over heavy abstractions.
- Keep Firebase limited to messaging-only unless the user explicitly changes direction.
- Treat Supabase as the source of truth for auth, database, and storage.
- Do not assume the database schema is final. The current schema is a working draft and will continue changing.

## Current product decisions

- App name: `MANACHYNA KUSA`
- Mobile auth: Supabase Auth only
- Login UX: social OAuth only
  - Google
  - Facebook
  - Microsoft / Azure
- No email/password login
- No manual register screen
- **Theming**: App fully supports dynamic Light/Dark mode (`ThemeProvider`). Theme preference is persisted via `SharedPreferences`.
- Firebase usage:
  - `firebase_core`
  - `firebase_messaging`
- Supabase usage:
  - Auth
  - Postgres
  - Storage

## Project workflow

1. Read [references/project-context.md](references/project-context.md) first for app architecture, branding, routing, and auth behavior.
2. Read [references/setup-and-credentials.md](references/setup-and-credentials.md) when the task touches Supabase, Firebase, OAuth providers, mobile callback URLs, or local setup.
3. Read [references/supabase-schema-working-draft.sql](references/supabase-schema-working-draft.sql) when the task depends on tables, enums, policies, buckets, chats, bookings, or provider/user relationships.
4. If the task proposes schema changes, treat the SQL draft as provisional and verify the live Supabase project before applying migrations.

## Architecture guidance

- App shell: `lib/app.dart`
- Dependency composition: `lib/core/di/app_providers.dart`
- Routing: `lib/core/router/app_router.dart`
- Auth orchestration: `lib/core/services/auth_service.dart`
- Firebase messaging: `lib/core/services/firebase_service.dart`
- Supabase config: `lib/core/config/supabase_config.dart`
- Feature data access lives behind repositories in `lib/features/**/data`
- UI state and theming live in `lib/providers` (e.g. `ThemeProvider`, `AuthProvider`)

## Auth-specific guidance

- OAuth mobile callback currently uses:
  - `io.supabase.manachynakusa://login-callback/`
- OAuth callback routes are handled by `AppRouter`.
- On first Supabase OAuth login, the app upserts a `users` row automatically.
- If the provider fails to return a user email, expect provider-specific issues, especially with Facebook.
- If Facebook login fails, check provider config first before changing app logic.

## Database guidance

- The SQL draft in references is a strong working model, not a frozen contract.
- Expect multiple future changes in:
  - roles
  - providers
  - bookings
  - payments
  - chats/messages
  - storage buckets
  - RLS policies
- Prefer additive, migration-friendly thinking.
  Avoid hard-coding assumptions that the current column set is permanent.

## Output expectations

- Keep changes production-minded and repo-consistent.
- If touching auth, routing, or schema assumptions, explain the impact clearly.
- When documenting setup, keep secrets out of git and document only public identifiers or file locations unless the user explicitly asks otherwise.
