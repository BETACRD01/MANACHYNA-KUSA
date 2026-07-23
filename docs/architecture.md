# Arquitectura del Proyecto (Flutter)

El proyecto está estructurado utilizando un enfoque basado en **Features (Características)** combinado con un núcleo central (**Core**), lo que garantiza escalabilidad y facilidad de mantenimiento.

## Estructura de Carpetas (`lib/`)

- **`core/`**: Contiene todo el código base que se comparte a lo largo de la aplicación.
  - `config/`: Configuraciones globales (ej. `supabase_config.dart`).
  - `di/`: Inyección de dependencias (`app_providers.dart`).
  - `router/`: Configuración de navegación (GoRouter o Navigator 2.0).
  - `services/`: Servicios externos (Firebase, Supabase, Location, Storage).
  - `theme/`: Estilos globales, paleta de colores y tipografías.
- **`features/`**: Contiene la lógica agrupada por dominio de negocio (cada feature es independiente).
  - `auth/`: Autenticación y registro de usuarios.
  - `bookings/`: Reservas y contrataciones de servicios.
  - `services/`: Listado y búsqueda de servicios domésticos.
  - `users/`: Gestión de perfiles y proveedores.
- **`models/`**: Clases de datos que mapean la información de la base de datos (ej. `user_model.dart`, `booking_model.dart`).
- **`providers/`**: Controladores de estado que implementan la lógica de negocio usando el patrón Provider.
- **`screens/`**: Vistas y pantallas de la interfaz de usuario (UI), conectadas a los Providers.

## Gestión de Estado

Se utiliza **Provider** (`package:provider`) como gestor de estado principal para inyectar dependencias y notificar cambios en la interfaz gráfica (ej. `AuthProvider`, `BookingProvider`, `ServiceProvider`).
