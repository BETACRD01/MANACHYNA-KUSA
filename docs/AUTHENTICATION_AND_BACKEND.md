# Autenticacion y backend

## Proyecto

- Flutter project: `Proyecto_final_2025`
- Firebase project: `manachyna-kusa-v2-2025`
- Firebase account used for CLI: `wd1501074@gmail.com`
- Supabase project ref: `ikdcqxgecjzgjntejizu`
- Supabase URL: `https://ikdcqxgecjzgjntejizu.supabase.co`

## Android

- Application ID: `com.manachynakusa.app`
- Main activity: `com.manachynakusa.app.MainActivity`
- Facebook App ID: `810854808514091`
- Facebook Android key hash: `LpP4x6zS7iCuLlexZywWUyBxD7I=`
- Firebase Android app ID: `1:265582480726:android:6a6de5f571a8874960daf7`

The old package `com.example.flutter_application_manachyna_kusa_2_0` is no longer the Android package. The Dart package name in `pubspec.yaml` may remain different; it is not the Android application ID.

## Google Sign-In

Google uses native mobile authentication through `google_sign_in` and then sends the ID token to Supabase with `signInWithIdToken`.

Important client IDs:

- Web/server client ID is used by Supabase Google provider.
- Android client ID belongs to `com.manachynakusa.app` and the Firebase SHA certificates.

Relevant files:

- `lib/core/services/auth_service.dart`
- `lib/features/auth/data/auth_repository.dart`
- `lib/providers/auth_provider.dart`
- `android/app/google-services.json`
- `lib/firebase_options.dart`

## Facebook Sign-In

The app uses `flutter_facebook_auth` with `LoginBehavior.nativeOnly`. Android returns a Facebook `ClassicToken`, not a Supabase-compatible OIDC ID token.

The current flow is:

```text
Facebook native app
  -> ClassicToken
  -> Supabase Edge Function facebook-native-auth
  -> Graph API validates the token
  -> Edge Function creates or reuses the Auth user
  -> Edge Function generates a magic-link token hash
  -> Flutter calls verifyOTP with token_hash and type
  -> Supabase session is created
```

Relevant files:

- `lib/core/services/auth_service.dart`
- `supabase/functions/facebook-native-auth/index.ts`
- `android/app/src/main/res/values/strings.xml`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

The Facebook function keeps existing users idempotent and updates their name and profile image. If Facebook does not return an email, the backend uses a technical fallback address ending in `@manachyna.invalid`; this is not the user's real Facebook email.

## Microsoft Sign-In

Microsoft is wired for mobile OAuth through `flutter_appauth` using Authorization Code + PKCE, then a Supabase Edge Function validates the Microsoft ID token and creates or reuses the Supabase user.

Current flow:

```text
Microsoft secure mobile login
  -> ID token + access token
  -> Supabase Edge Function microsoft-native-auth
  -> Microsoft JWKS validates the ID token
  -> Optional Microsoft Graph profile/photo lookup
  -> Edge Function creates or reuses the Auth user
  -> Edge Function generates a magic-link token hash
  -> Flutter calls verifyOTP with token_hash and type
  -> Supabase session is created
```

Relevant files:

- `lib/core/services/auth_service.dart`
- `supabase/functions/microsoft-native-auth/index.ts`
- `android/app/build.gradle.kts`

Configuration needed before testing:

- Create an Azure/Entra App Registration.
- Application (client) ID: `38b33db3-9f5c-455d-ae6c-baf67dd9b9ab`
- Supported account types: choose personal Microsoft accounts too if Outlook/Hotmail users must sign in.
- Add mobile redirect URI: `com.manachynakusa.app://oauthredirect`.
- Put the Application (client) ID in Supabase Secrets:

```bash
supabase secrets set MICROSOFT_CLIENT_ID='<application-client-id>' --project-ref ikdcqxgecjzgjntejizu
```

- The public Client ID is already configured as the Flutter default. If it changes, compile/run Flutter with the new Client ID:

```bash
flutter run --dart-define=MICROSOFT_CLIENT_ID='<application-client-id>'
```

If Microsoft does not return a real email, the backend uses a technical fallback address ending in `@manachyna.invalid`, and the UI displays `ID de Microsoft: ...`.

## Supabase secrets

Secrets exist only in Supabase Edge Function secrets. Never put these values in Flutter, Git, documentation, or logs:

- `FACEBOOK_APP_ID`
- `FACEBOOK_APP_SECRET`
- `MICROSOFT_CLIENT_ID`
- `ADMIN_SERVICE_ROLE_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `SUPABASE_URL`

The safe local template is `.env.example`. Real `.env` and `.env.*` files are ignored by Git. The Flutter app currently receives its public Supabase configuration through its existing Firebase/Supabase configuration files; creating `.env` alone does not automatically inject variables into a Flutter build.

To update a secret:

```bash
supabase secrets set FACEBOOK_APP_SECRET='<new-secret>' --project-ref ikdcqxgecjzgjntejizu
```

Regenerate any secret that has been shared in chat or committed accidentally.

## Public legal pages

Privacy policy:

`https://ikdcqxgecjzgjntejizu.supabase.co/functions/v1/privacy-policy`

Terms of service:

`https://ikdcqxgecjzgjntejizu.supabase.co/functions/v1/terms-of-service`

Functions:

- `supabase/functions/privacy-policy/index.ts`
- `supabase/functions/terms-of-service/index.ts`

Both functions are deployed with JWT verification disabled so Meta can open them publicly. Review the legal text and contact details before submitting the app for review.

## Meta configuration

For Android:

- Package: `com.manachynakusa.app`
- Class: `com.manachynakusa.app.MainActivity`
- Key hash: `LpP4x6zS7iCuLlexZywWUyBxD7I=`

For App Domains, first register a Website platform using the public Supabase URL, then use only the host as the domain:

`ikdcqxgecjzgjntejizu.supabase.co`

Use the privacy and terms URLs above in the corresponding Meta fields. Do not use `facebook.com` as the app's terms or data-deletion URL.

## Supabase database

Anonymous catalog read policies were added in:

`supabase/migrations/20260724032327_allow_anon_catalog_read.sql`

Catalog tables readable by `anon`:

- `services`
- `service_categories`
- `providers`
- `provider_services`
- `reviews`

Private tables such as users, bookings, and payments were not opened to anonymous users.

## Admin panel

Flutter route:

`/admin-dashboard`

Files:

- `lib/screens/admin/admin_dashboard.dart`
- `lib/features/admin/data/admin_repository.dart`
- `supabase/functions/admin-dashboard/index.ts`

The panel is visible from Perfil only when the logged-in user has `UserType.admin`. The Edge Function also checks the authenticated user in `public.users` and requires:

```sql
role = 'admin'
and is_active = true
```

To promote a known local account, update only the intended user:

```sql
update public.users
set role = 'admin',
    is_provider = false,
    updated_at = now()
where email = '<admin-email>';
```

## Verification

Run after authentication or backend changes:

```bash
flutter analyze --no-pub
flutter test
supabase functions deploy facebook-native-auth --project-ref ikdcqxgecjzgjntejizu
supabase functions deploy microsoft-native-auth --project-ref ikdcqxgecjzgjntejizu --use-api --no-verify-jwt
supabase functions deploy admin-dashboard --project-ref ikdcqxgecjzgjntejizu --use-api --no-verify-jwt
supabase functions deploy privacy-policy --project-ref ikdcqxgecjzgjntejizu --no-verify-jwt
supabase functions deploy terms-of-service --project-ref ikdcqxgecjzgjntejizu --no-verify-jwt
```

Useful Facebook logs:

```text
[Facebook] status=...
[Facebook backend] ...
Error autenticando con OAuthProvider(facebook): ...
[Microsoft backend] ...
Error autenticando con OAuthProvider(azure): ...
```
