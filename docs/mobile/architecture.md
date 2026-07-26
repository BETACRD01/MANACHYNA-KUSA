# Arquitectura del Proyecto (Flutter)

El proyecto está estructurado utilizando un enfoque basado en **Features (Características)** combinado con un núcleo central (**Core**), lo que garantiza escalabilidad y facilidad de mantenimiento.

## Estructura de Carpetas (`lib/`)

- **`core/`**: Contiene todo el código base que se comparte a lo largo de la aplicación.
  - `config/`: Configuraciones globales (ej. `supabase_config.dart`).
  - `di/`: Inyección de dependencias (`app_providers.dart`).
  - `router/`: Configuración de navegación (GoRouter o Navigator 2.0).
  - `services/`: Servicios externos (Firebase, Supabase, Location, Storage).
  - `theme/`: Estilos globales, paleta de colores y tipografías.
- **`models/`**: Clases de datos inmutables y de dominio que mapean la información de la base de datos.
  - Todo modelo debe implementarse usando `Freezed` y `json_serializable` para garantizar inmutabilidad, comparaciones eficientes (`==`) y seguridad de serialización.
  - Se estructura bajo una regla estricta de aislamiento: un modelo = una subcarpeta (ej. `user/user_model.dart`, `booking/booking_model.dart`).
  - Los archivos generados (`.freezed.dart` y `.g.dart`) conviven en la misma subcarpeta y jamás deben ser editados a mano. Todo cambio requiere ejecutar `dart run build_runner build --delete-conflicting-outputs`.
- **`providers/`**: Controladores de estado globales que implementan la lógica de negocio usando el patrón genérico Provider.
- **`screens/`**: Organizado mediante Arquitectura Basada en Roles y Features (Actor-Feature Architecture):
  - `admin/`: Panel de administración (Módulos: usuarios, servicios, dashboard).
  - `auth/`: Flujos de inicio de sesión y registro. (Módulos: `ui/`, `controllers/`, `widgets/`).
  - `customer/`: Interfaz para clientes (Módulos: `home/`, `bookings/`, `chat/`, `profile/`).
  - `provider/`: Interfaz para proveedores (Módulos: `overview/`, `bookings/`, `services/`, `work_feed/`, `profile/`).
  - `common/`: Pantallas compartidas entre distintos roles (ej. Splash screen, mapas).
  *Nota:* Dentro de cada módulo específico (ej. `customer/chat/`) se respeta la separación estricta: `ui/` (Vistas visuales), `widgets/` (Componentes reutilizables), `controllers/` (Lógica de vista), y `data/` (Modelos locales/Mocks).

## Gestión de Estado

Se utiliza **Provider** (`package:provider`) como gestor de estado principal para inyectar dependencias y notificar cambios en la interfaz gráfica (ej. `AuthProvider`, `BookingProvider`, `ServiceProvider`).
