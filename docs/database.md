# Base de Datos y Backend (BaaS)

El proyecto utiliza un enfoque híbrido, combinando las fortalezas de **Firebase** y **Supabase**.

## Firebase (Google)

Se utiliza principalmente para servicios auxiliares de la plataforma móvil:

1. **Firebase Cloud Messaging (FCM)**: Gestión y envío de notificaciones push en tiempo real a los usuarios y proveedores.
2. **Firebase Core**: Inicialización de la aplicación móvil en el ecosistema de Google.

## Supabase (PostgreSQL)

Actúa como la base de datos principal (Relacional) y proveedor de almacenamiento:

1. **Database (PostgreSQL)**: Almacena toda la información estructural:
   - `users`: Perfiles de usuarios clientes y proveedores.
   - `services`: Catálogo de servicios ofrecidos, categorías y descripciones.
   - `bookings`: Historial de reservas, estados de solicitudes y fechas.
   - `reviews`: Calificaciones y comentarios del sistema de confianza.
2. **Supabase Storage**: Almacenamiento de archivos multimedia, fotos de perfil de los proveedores e imágenes de los servicios.
3. **Authentication**: (Dependiendo de la configuración, Supabase o Firebase manejan los tokens de sesión de los usuarios).
