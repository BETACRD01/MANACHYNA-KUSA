# MANACHYNA KUSA - Project Context

## Repository

- Repo: `Proyecto_final_2025`
- Product name: `MANACHYNA KUSA`
- Flutter app name in `pubspec.yaml`: `flutter_application_manachyna_kusa_2_0`

## Language and coding preferences

- Explanations in Spanish
- Code in English
- Clean code
- No unnecessary inline comments
- Pragmatic implementation
- Production-minded structure

## Current architecture

### App composition

- `lib/main.dart`
  - Initializes Firebase Core
  - Initializes Supabase
  - Initializes Firebase Messaging
- `lib/app.dart`
  - App shell only
- `lib/core/di/app_providers.dart`
  - Dependency assembly
- `lib/core/router/app_router.dart`
  - Centralized route handling

### Data flow

- `features/*/data/*_repository.dart`
  - Repository layer
- `providers/*`
  - UI state and orchestration
- `core/services/*`
  - External integrations

## Auth model

- Supabase Auth only
- Social sign-in only
  - Google
  - Facebook
  - Microsoft / Azure
- No email/password flow
- No classic register view

### Important auth behavior

- Mobile redirect URL:
  - `io.supabase.manachynakusa://login-callback/`
- App router explicitly handles OAuth callback-like routes.
- On successful OAuth, user profile rows are created/upserted in Supabase.

## Backend split

### Supabase

Use Supabase for:
- authentication
- relational data
- storage

### Firebase

Use Firebase only for:
- app initialization support
- push notifications through `firebase_messaging`

Do not reintroduce Firebase Auth, Firestore, or Firebase Storage unless the user explicitly changes the architecture.

## Branding

- Primary app name: `MANACHYNA KUSA`
- Social login screen uses that name
- README banner now uses a generated PNG banner:
  - `docs/images/app_banner.png`
- Branding assets currently include:
  - `assets/branding/manachyna_kusa_logo.png`
  - `assets/branding/manachyna_kusa_logo_transparent.png`

## UI notes

- Login screen already has social buttons only.
- OAuth loading behavior was refined so only the active provider button shows loading.
- Logout from profile should return directly to login without showing an intermediate retry/error panel.

## Search/helpful files

- `lib/core/config/supabase_config.dart`
- `lib/core/services/auth_service.dart`
- `lib/core/services/firebase_service.dart`
- `lib/core/router/app_router.dart`
- `lib/screens/auth/login_screen.dart`
- `lib/screens/auth/profile_screen.dart`
- `lib/firebase_options.dart`

## Testing/verification preference

- `flutter analyze` has been the reliable sanity check after refactors and auth changes in this repo.
