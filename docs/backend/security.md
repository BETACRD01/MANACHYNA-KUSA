# Manejo de Credenciales y Seguridad

La aplicación requiere llaves y tokens de seguridad para conectarse con los servidores en la nube. **IMPORTANTE:** Nunca debes subir estas claves directamente al repositorio público.

## Archivos de Configuración Ignorados (`.gitignore`)

Los siguientes archivos deben estar presentes en tu máquina local pero **NO** en GitHub:

1. **Firebase Credentials**:
   - `android/app/google-services.json` (Para compilar en Android)
   - `ios/Runner/GoogleService-Info.plist` (Para compilar en iOS)
   - *Nota*: Estos archivos se descargan desde la consola de Firebase del proyecto.

2. **Supabase Credentials**:
   - Las credenciales de Supabase se encuentran en `lib/core/config/supabase_config.dart` o en variables de entorno (`.env`).
   - Se requiere: `SUPABASE_URL` y `SUPABASE_ANON_KEY`.

## Reglas de Seguridad (RLS - Row Level Security)

En Supabase, las tablas están protegidas mediante políticas RLS de PostgreSQL:

- **Users**: Solo el propio usuario puede editar su perfil.
- **Services**: Lectura pública, escritura solo para proveedores verificados.
- **Bookings**: Solo pueden ser leídas y escritas por los usuarios involucrados (Cliente y Proveedor).
