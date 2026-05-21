# Credenciales y valores seguros

Este archivo sirve para orientar a cualquier IA sin exponer secretos.

## Supabase

- Project name: `Mañachiy kan Kusata`
- Project ref: `ikdcqxgecjzgjntejizu`
- Public URL: `https://ikdcqxgecjzgjntejizu.supabase.co`
- Region: `us-east-2`
- Postgres: `17.6.1.121`
- Public anon key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrZGNxeGdlY2p6Z2pudGVqaXp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NjUyOTcsImV4cCI6MjA5NDQ0MTI5N30.9AOmDYBhvO0rPJ5Uq5AFXjRvvv4xfQP0xdyQCn3rKHs`

La anon key es public/publishable y el proyecto la usa tanto en
`lib/core/config/supabase_config.dart` como por inyección en runtime con
`--dart-define`.

## Runtime injection

Use este comando cuando la app deba arrancar con las credenciales inyectadas:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://ikdcqxgecjzgjntejizu.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrZGNxeGdlY2p6Z2pudGVqaXp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NjUyOTcsImV4cCI6MjA5NDQ0MTI5N30.9AOmDYBhvO0rPJ5Uq5AFXjRvvv4xfQP0xdyQCn3rKHs
```

## Current code fallback

```dart
class SupabaseConfig {
  static const String url = 'https://ikdcqxgecjzgjntejizu.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrZGNxeGdlY2p6Z2pudGVqaXp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NjUyOTcsImV4cCI6MjA5NDQ0MTI5N30.9AOmDYBhvO0rPJ5Uq5AFXjRvvv4xfQP0xdyQCn3rKHs';
  static const String profileImagesBucket = 'profile-images';
  static const String serviceImagesBucket = 'service-images';
}
```

## Firebase

- Project ID: `manachyna-kusa-v2-2025`
- Android app ID: `1:265582480726:android:0c94bc24b77a486660daf7`
- Android package: `com.example.flutter_application_manachyna_kusa_2_0`
- iOS app ID: `1:265582480726:ios:37a30dfd051ab60560daf7`
- iOS bundle ID: `com.example.flutterApplicationManachynaKusa20`

Firebase se usa solo para `firebase_core` y `firebase_messaging`.
No subir `google-services.json`, `GoogleService-Info.plist`, server keys,
APNs keys ni archivos privados de servicio.

## OAuth

- Login esperado: Supabase Auth social OAuth.
- Providers de producto: Google, Facebook y Microsoft/Azure.
- Mobile callback: `io.supabase.manachynakusa://login-callback/`

Los client secrets viven en los paneles de cada proveedor y no deben subirse
al chat ni incluirse en este paquete.
