# 🗄️ Base de Datos (Supabase)

El sistema de base de datos de MANACHYNA KUSA está construido íntegramente sobre **PostgreSQL**, gestionado y alojado a través de Supabase. A continuación se presenta el esquema oficial verificado mediante el CLI de Supabase (`supabase gen types` conectado al entorno remoto).

## 📊 Arquitectura de Tablas Principales

La base de datos cuenta con una estructura relacional dividida en los siguientes dominios:

### 1. Gestión de Usuarios y Roles
- **`users`**: Perfiles maestros. Administra correos, ubicación geográfica (lat/lon), dispositivos y tokens FCM. Depende del rol asignado (enum `user_role`: `client`, `provider`, `admin`).
- **`admins`**: Entidad dedicada a cuentas administrativas (roles superiores y accesos de sistema).
- **`providers`**: Entidad dedicada a la información profesional de los proveedores (estados: `pending`, `approved`, etc.), calificaciones promediadas, documentos y métricas.
- **`user_blocks`**: Tabla de control para gestionar los bloqueos entre usuarios, protegiendo a la comunidad.

### 2. Catálogo de Servicios
- **`service_categories`**: Clasificación principal (ej. Plomería, Electricidad, Limpieza).
- **`services`**: Catálogo general de los servicios específicos ofrecidos en la plataforma.
- **`provider_services`**: Relación (N:M) que vincula qué servicios exactos brinda un proveedor y sus tarifas particulares.

### 3. Operaciones Comerciales
- **`bookings`**: Registra cada solicitud de servicio. Maneja un estricto control de estado (enum `booking_status`: `pending`, `confirmed`, `in_progress`, `completed`, `cancelled`, `rejected`).
- **`payments`**: Seguimiento financiero de las transacciones (enum `payment_status`, enum `payment_method`).
- **`reviews`**: Sistema de reputación donde los clientes califican el trabajo finalizado por el proveedor.

### 4. Comunicación y Notificaciones
- **`chats`**: Mantiene las sesiones de conversaciones activas entre cliente y proveedor.
- **`messages`**: Historial de mensajes, soportando multimedia (enum `message_type`: `text`, `image`, `audio`, `location`, `file`).
- **`notifications`**: Registro histórico de alertas enviadas a los usuarios (enum `notification_type`).

---

## 🔒 Reglas de Seguridad y Funciones (RLS)

Toda la base de datos está fuertemente protegida por **Row Level Security (RLS)** directamente en PostgreSQL. Para facilitar las reglas, existen funciones auxiliares nativas (RPC):

- `is_admin()`: Verifica si el JWT activo pertenece a la tabla `admins`.
- `is_provider()`: Valida si la cuenta en sesión tiene el rol y estado para operar como proveedor.

### Almacenamiento (Supabase Storage)
La base de datos se complementa con **Storage Buckets** configurados en Supabase para almacenar de manera segura:
1. `avatars`: Fotos de perfil de clientes y proveedores.
2. `service_images`: Evidencias de los trabajos realizados y portafolios.
3. `chat_attachments`: Archivos multimedia compartidos en las conversaciones.
