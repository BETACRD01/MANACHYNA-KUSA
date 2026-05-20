# Credenciales y valores seguros

Este archivo sirve para orientar a cualquier IA sin exponer secretos.

## Supabase

- Project name: `Mañachiy kan Kusata`
- Project ref: `ikdcqxgecjzgjntejizu`
- Public URL: `https://ikdcqxgecjzgjntejizu.supabase.co`
- Region: `us-east-2`
- Postgres: `17.6.1.121`
- Public anon key: `<redacted-public-anon-key>`

La anon key existe en el código Flutter porque el cliente móvil la necesita.
Para este paquete quedó redactada para evitar duplicar llaves en archivos
preparados para subir a un tercero.

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
