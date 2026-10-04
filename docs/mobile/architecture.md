# 📱 Arquitectura de la Aplicación Móvil (Flutter)

La aplicación móvil de **MANACHYNA KUSA** está construida en **Flutter** utilizando una arquitectura escalable orientada a características (**Feature-Driven**) y basada en actores/roles (**Actor-Feature Architecture**).

---

## 📂 Estructura de Directorios (`mobile/lib/`)

```text
mobile/
├── android/             # Configuración nativa de Android (build.gradle, google-services.json)
├── ios/                 # Configuración nativa de iOS (Podfile, Info.plist)
├── assets/              # Recursos gráficos locales (logos, iconos sociales)
├── test/                # Tests unitarios y de widgets
└── lib/
    ├── app.dart         # Configuración raíz de MaterialApp y temas
    ├── main.dart        # Punto de entrada de la aplicación
    ├── core/            # Módulos transversales y utilidades globales
    │   ├── config/      # Constantes de configuración (SupabaseConfig)
    │   ├── constants/   # Paleta de colores, rutas de navegación, estilos
    │   ├── di/          # Inyección de dependencias (AppProviders con MultiProvider)
    │   ├── router/      # Generador de rutas y control de navegación
    │   ├── services/    # Clientes de servicios externos (Auth, Storage, Location, FCM)
    │   ├── theme/       # Configuración de tema claro y oscuro (AppTheme)
    │   ├── utils/       # Helpers de formato, validadores, alertas
    │   └── widgets/     # Componentes visuales genéricos reutilizables
    ├── features/        # Repositorios y fuentes de datos por dominio
    │   ├── admin/       # Repositorio de analíticas y administración
    │   ├── auth/        # Lógica de autenticación OAuth
    │   ├── bookings/    # Repositorio de órdenes y reservas
    │   ├── services/    # Catálogo de servicios y categorías
    │   └── users/       # Repositorio de perfiles y usuarios
    ├── models/          # Modelos inmutables de dominio (Freezed + JSON)
    │   ├── booking/     # Modelo de reservas
    │   ├── custom_task/ # Solicitudes de tareas personalizadas
    │   ├── notification/# Notificaciones push y del sistema
    │   ├── review/      # Calificaciones y opiniones
    │   ├── service/     # Servicios y categorías
    │   └── user/        # Perfil de usuario y roles
    ├── providers/       # Controladores de estado reactivos (ChangeNotifier)
    │   ├── auth_provider.dart
    │   ├── booking_provider.dart
    │   ├── service_provider.dart
    │   └── user_provider.dart
    └── screens/         # Vistas divididas estrictamente por actor/rol
        ├── admin/       # Panel de control del administrador
        ├── auth/        # Pantallas de login y bienvenida
        ├── customer/    # Pantallas del cliente (Home, Reservas, Chat, Perfil)
        ├── provider/    # Pantallas del profesional (Feed de trabajos, Servicios)
        ├── common/      # Pantallas compartidas (Splash, selección)
        └── notifications/# Historial de notificaciones
```

---

## 🏛️ Principios Clave de Diseño

### 1. Inmutabilidad y Modelado Seguro
Todos los modelos de datos en `models/` implementan **Freezed** y **json_serializable**:
* Generan copias inmutables con `copyWith()`.
* Aseguran igualdad por valor (`==`).
* Serialización bidireccional segura con Supabase PostgreSQL.
* Para regenerar modelos tras cambios de esquema:
  ```bash
  cd mobile
  dart run build_runner build --delete-conflicting-outputs
  ```

### 2. Aislamiento por Módulos (Vistas, Controladores y Widgets)
Dentro de cada pantalla compleja (por ejemplo en `auth/` o `customer/chat/`) se respeta una separación estricta:
* `ui/`: Vistas visuales (`Screen`, `Tab`).
* `widgets/`: Componentes de interfaz específicos de la pantalla.
* `controllers/`: Lógica de presentación y eventos.

### 3. Gestión de Estado con Provider
Se utiliza **Provider** (`package:provider`) inyectado en la cúspide del árbol a través de [`mobile/lib/core/di/app_providers.dart`](../mobile/lib/core/di/app_providers.dart). Esto permite reactividad fluida sin dependencias acopladas ni boilerplate excesivo.
