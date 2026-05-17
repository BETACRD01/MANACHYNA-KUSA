# MANACHYNA KUSA - Setup and Credentials

This file documents the current known setup. Some values are public identifiers and app config values already present in the repo. Do not add private OAuth client secrets here.

## Supabase

### Current project

- Project name: `Mañachiy kan Kusata`
- Project ref: `ikdcqxgecjzgjntejizu`
- Project URL:
  - `https://ikdcqxgecjzgjntejizu.supabase.co`

### Current app config

Defined in:
- `lib/core/config/supabase_config.dart`

Current values:
- URL:
  - `https://ikdcqxgecjzgjntejizu.supabase.co`
- Publishable key:
  - `sb_publishable_GVQHauYZ8RgPTUqaPmef4Q_aHM_8g_9`

### Current storage buckets used by app config

- `profile-images`
- `service-images`

### OAuth mobile callback

- `io.supabase.manachynakusa://login-callback/`

### Supabase auth provider notes

Current intended providers:
- Google
- Facebook
- Azure / Microsoft

When configuring provider callbacks in external dashboards, the common Supabase callback URL is:

- `https://ikdcqxgecjzgjntejizu.supabase.co/auth/v1/callback`

### Important note about live schema

The schema draft stored in this skill is not permanent. Before creating migrations or changing code that depends on columns/policies, verify the live project state first.

## Firebase

### Current Firebase project

The app was reconfigured against:
- Project ID: `manachyna-kusa-v2-2025`
- Project number: `265582480726`

Firebase is currently used only for messaging support.

### FlutterFire outputs

Relevant files:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

### Current configured platforms

From `lib/firebase_options.dart`:

- Android app id:
  - `1:265582480726:android:0c94bc24b77a486660daf7`
- iOS app id:
  - `1:265582480726:ios:37a30dfd051ab60560daf7`

### Important Firebase rule for this project

Do not rebuild the app around Firebase Auth or Firebase Storage unless the user explicitly asks for that architecture again.

## OAuth provider setup checklist

### Google

- Create OAuth client in Google Cloud
- Add redirect URI:
  - `https://ikdcqxgecjzgjntejizu.supabase.co/auth/v1/callback`
- Paste Google client id and client secret into Supabase provider config

### Facebook

- Add redirect URI:
  - `https://ikdcqxgecjzgjntejizu.supabase.co/auth/v1/callback`
- Ensure `email` and `public_profile` are available for testing
- If provider returns no email, verify:
  - account has a real email
  - app mode/tester access is correct
  - Supabase provider settings tolerate missing email if needed

### Microsoft / Azure

- Configure Azure provider in Supabase
- Use the same Supabase callback URL pattern

## Local verification

Recommended checks after meaningful changes:

```bash
flutter pub get
flutter analyze
```

If working on Android OAuth or mobile return flows:

```bash
flutter run
flutter logs -d <device-id>
```

## Sensitive data policy for this repo

- Public app identifiers may be documented here.
- Private OAuth client secrets should not be committed.
- If a secret is accidentally exposed in screenshots or docs, rotate it at the provider dashboard.
