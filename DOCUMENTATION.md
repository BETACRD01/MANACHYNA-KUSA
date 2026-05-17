# 📚 Documentación Técnica: DESARROLLO DE APLICACION MOVIL MULTISERVICIO "MANACHYNA KUSA"

Esta documentación proporciona una visión técnica completa del proyecto "DESARROLLO DE APLICACION MOVIL MULTISERVICIO \"MANACHYNA KUSA\"", detallando la arquitectura de la aplicación en Flutter, la integración de bases de datos, el manejo de credenciales y el flujo de servicios.

---

## 🏛️ 1. Arquitectura del Proyecto (Flutter)

El proyecto está estructurado utilizando un enfoque basado en **Features (Características)** combinado con un núcleo central (**Core**), lo que garantiza escalabilidad y facilidad de mantenimiento.

### Estructura de Carpetas (`lib/`)

*   **`core/`**: Contiene todo el código base que se comparte a lo largo de la aplicación.
    *   `config/`: Configuraciones globales (ej. `supabase_config.dart`).
    *   `di/`: Inyección de dependencias (`app_providers.dart`).
    *   `router/`: Configuración de navegación (GoRouter o Navigator 2.0).
    *   `services/`: Servicios externos (Firebase, Supabase, Location, Storage).
    *   `theme/`: Estilos globales, paleta de colores y tipografías.
*   **`features/`**: Contiene la lógica agrupada por dominio de negocio (cada feature es independiente).
    *   `auth/`: Autenticación y registro de usuarios.
    *   `bookings/`: Reservas y contrataciones de servicios.
    *   `services/`: Listado y búsqueda de servicios domésticos.
    *   `users/`: Gestión de perfiles y proveedores.
*   **`models/`**: Clases de datos que mapean la información de la base de datos (ej. `user_model.dart`, `booking_model.dart`).
*   **`providers/`**: Controladores de estado que implementan la lógica de negocio usando el patrón Provider.
*   **`screens/`**: Vistas y pantallas de la interfaz de usuario (UI), conectadas a los Providers.

### Gestión de Estado
Se utiliza **Provider** (`package:provider`) como gestor de estado principal para inyectar dependencias y notificar cambios en la interfaz gráfica (ej. `AuthProvider`, `BookingProvider`, `ServiceProvider`).

---

## 🗄️ 2. Base de Datos y Backend (BaaS)

El proyecto utiliza un enfoque híbrido, combinando las fortalezas de **Firebase** y **Supabase**.

### Firebase (Google)
Se utiliza principalmente para servicios auxiliares de la plataforma móvil:
1.  **Firebase Cloud Messaging (FCM)**: Gestión y envío de notificaciones push en tiempo real a los usuarios y proveedores.
2.  **Firebase Core**: Inicialización de la aplicación móvil en el ecosistema de Google.

### Supabase (PostgreSQL)
Actúa como la base de datos principal (Relacional) y proveedor de almacenamiento:
1.  **Database (PostgreSQL)**: Almacena toda la información estructural:
    *   `users`: Perfiles de usuarios clientes y proveedores.
    *   `services`: Catálogo de servicios ofrecidos, categorías y descripciones.
    *   `bookings`: Historial de reservas, estados de solicitudes y fechas.
    *   `reviews`: Calificaciones y comentarios del sistema de confianza.
2.  **Supabase Storage**: Almacenamiento de archivos multimedia, fotos de perfil de los proveedores e imágenes de los servicios.
3.  **Authentication**: (Dependiendo de la configuración, Supabase o Firebase manejan los tokens de sesión de los usuarios).

---

## 🔐 3. Manejo de Credenciales y Seguridad

La aplicación requiere llaves y tokens de seguridad para conectarse con los servidores en la nube. **IMPORTANTE:** Nunca debes subir estas claves directamente al repositorio público.

### Archivos de Configuración Ignorados (`.gitignore`)
Los siguientes archivos deben estar presentes en tu máquina local pero **NO** en GitHub:

1.  **Firebase Credentials**:
    *   `android/app/google-services.json` (Para compilar en Android)
    *   `ios/Runner/GoogleService-Info.plist` (Para compilar en iOS)
    *   *Nota*: Estos archivos se descargan desde la consola de Firebase del proyecto.

2.  **Supabase Credentials**:
    *   Las credenciales de Supabase se encuentran en `lib/core/config/supabase_config.dart` o en variables de entorno (`.env`).
    *   Se requiere: `SUPABASE_URL` y `SUPABASE_ANON_KEY`.

### Reglas de Seguridad (RLS - Row Level Security)
En Supabase, las tablas están protegidas mediante políticas RLS de PostgreSQL:
*   **Users**: Solo el propio usuario puede editar su perfil.
*   **Services**: Lectura pública, escritura solo para proveedores verificados.
*   **Bookings**: Solo pueden ser leídas y escritas por los usuarios involucrados (Cliente y Proveedor).

---

## 🚀 4. Flujo de Trabajo y Compilación

### Instalación de Dependencias
```bash
flutter pub get
```

### Ejecución en Modo Desarrollo
El comando principal levantará la app utilizando las variables de entorno por defecto:
```bash
flutter run
```

### Generación de Producción (Android)
Para compilar la aplicación para la Google Play Store (creación del Android App Bundle - AAB), asegúrate de tener los certificados de firma (Keystore) configurados en `android/key.properties`, y luego ejecuta:
```bash
flutter build appbundle --release
```

---

## 📦 5. Dependencias Clave (`pubspec.yaml`)

El ecosistema del proyecto se apoya en los siguientes paquetes principales:
*   `supabase_flutter`: Integración directa con el SDK de Supabase.
*   `firebase_core` & `firebase_messaging`: Infraestructura y notificaciones push.
*   `provider`: Gestión del estado de forma reactiva.
*   `google_maps_flutter` & `geolocator`: Mapas y rastreo de ubicación de servicios domésticos.
*   `image_picker` & `file_picker`: Captura y subida de evidencias o fotos de perfil.
*   `shared_preferences`: Almacenamiento local para sesiones y configuraciones de usuario.

---
*Documentación generada y actualizada para el equipo de desarrollo local.*
