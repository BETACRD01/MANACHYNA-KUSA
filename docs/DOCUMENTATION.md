# 📚 Documentación Técnica: MANACHYNA KUSA

El proyecto está estrictamente separado en dos grandes áreas: **Frontend (Móvil)** y **Backend (Nube)**. Selecciona el área que deseas explorar:

---

## 📱 Parte 1: Aplicación Móvil (Frontend / Flutter)

Toda la documentación relacionada con el desarrollo de la aplicación en Flutter, diseño de interfaces, gestión de estado y empaquetado.

*   🏛️ **[Arquitectura y Carpetas](mobile/architecture.md)**: Explicación de la Arquitectura Basada en Roles (Admin, Provider, Customer, Auth) y la estricta separación de `ui/`, `widgets/` y `controllers/`.
*   🚀 **[Flujo de Trabajo y Compilación](mobile/workflow.md)**: Cómo compilar la app, ejecutarla y generar los bundles para producción.
*   📦 **[Dependencias Clave](mobile/dependencies.md)**: Librerías principales utilizadas en el entorno de Flutter (Provider, GoRouter, etc).

---

## ☁️ Parte 2: Infraestructura y Base de Datos (Backend)

Toda la documentación sobre el modelo de datos, la autenticación de usuarios, notificaciones y reglas de seguridad de los servidores.

*   🗄️ **[Base de Datos (Supabase)](backend/database.md)**: Diseño de las tablas (Usuarios, Servicios, Reservas, Reseñas) en PostgreSQL y Storage.
*   🔐 **[Autenticación y Configuración](backend/AUTHENTICATION_AND_BACKEND.md)**: Flujos completos de OAuth (Google, Facebook, Microsoft) a través de Supabase Auth y Edge Functions. (Nota: Firebase se utiliza **exclusivamente** para Cloud Messaging / FCM).
*   🛡️ **[Seguridad y Credenciales (RLS)](backend/security.md)**: Políticas de seguridad a nivel de fila (Row Level Security) y manejo seguro de llaves maestras y tokens.

---

> 💡 **Nota para desarrolladores:** Mantén siempre esta separación. Si agregas una nueva pantalla en Flutter, documenta en `mobile/`. Si agregas una nueva tabla o función RPC en PostgreSQL, documenta en `backend/`.
