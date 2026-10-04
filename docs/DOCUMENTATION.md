# 📚 Documentación Técnica Integral: MANACHYNA KUSA

**MANACHYNA KUSA** es una plataforma tecnológica integral compuesta por una **Aplicación Móvil** (iOS y Android), una **Plataforma Web** (React SPA), un **Backend en la Nube** (Supabase con PostgreSQL) y un **Servidor de Producción** con integración continua (**CI/CD en Google Cloud Platform**).

---

## 🗺️ Mapa de la Documentación

```text
docs/
├── DOCUMENTATION.md                     # Portal central de documentación técnica (este archivo)
├── README.md                            # Guía rápida e índice de navegación
├── mobile/                              # 📱 Documentación de la App Móvil (Flutter)
│   ├── architecture.md                  # Arquitectura de roles, modelos Freezed y providers
│   ├── dependencies.md                  # Paquetes clave en pubspec.yaml
│   └── workflow.md                      # Compilación, depuración inalámbrica y releases
├── frontend/                            # ⚛️ Documentación de la Web (React)
│   └── overview.md                      # Stack React 19 + Vite 8 + Tailwind v4 + Supabase
├── backend/                             # ☁️ Base de Datos y Servicios Cloud
│   ├── database.md                      # Esquema PostgreSQL, tablas y relaciones
│   ├── AUTHENTICATION_AND_BACKEND.md    # OAuth nativo (Google, Facebook, Microsoft) y Edge Functions
│   └── security.md                      # Reglas de seguridad RLS y manejo de credenciales
├── devops/                              # 🚀 Infraestructura y CI/CD
│   └── ci_cd_and_deployment.md          # Google Cloud VM, Nginx, DuckDNS y GitHub Actions
└── legal/                               # 📜 Documentos Legales
    ├── terms.html                       # Términos y condiciones de uso
    └── privacy.html                     # Política de privacidad y tratamiento de datos
```

---

## 📱 Área 1: Aplicación Móvil (Flutter / `mobile/`)

Toda la lógica de la aplicación nativa para clientes y profesionales independientes en la provincia de Napo.

* 🏛️ **[Arquitectura y Carpetas](mobile/architecture.md)**: Estructura modular basada en roles (`admin`, `provider`, `customer`, `auth`) y modelos inmutables generados con Freezed.
* 🚀 **[Flujo de Trabajo y Compilación](mobile/workflow.md)**: Comandos para desarrollo local, pruebas unitarias, depuración inalámbrica con ADB Wi-Fi y generación de bundles para Google Play Store.
* 📦 **[Dependencias Clave](mobile/dependencies.md)**: Lista detallada de paquetes (Supabase, Firebase FCM, Provider, Google Maps, Geolocator).

---

## ⚛️ Área 2: Plataforma Web (React / `frontend/`)

Portal web accesible desde `manachynakusa.duckdns.org` para visualización del catálogo público y páginas legales.

* 🌐 **[Arquitectura y Funcionamiento Web](frontend/overview.md)**:
  * Construido con **React 19 + Vite 8 + TypeScript + Tailwind CSS v4**.
  * Conexión directa en vivo mediante `@supabase/supabase-js`.
  * Catálogo interactivo de servicios y tarifas referenciales.
  * Pestañas oficiales de Términos de Servicio y Política de Privacidad.

---

## ☁️ Área 3: Base de Datos y Backend (Supabase / `supabase/`)

Modelo relacional, autenticación y almacenamiento en la nube de Supabase (`ikdcqxgecjzgjntejizu.supabase.co`).

* 🗄️ **[Base de Datos PostgreSQL](backend/database.md)**: Esquema de tablas por dominio (`users`, `services`, `bookings`, `payments`, `reviews`, `chats`, `notifications`).
* 🔐 **[Autenticación y Edge Functions](backend/AUTHENTICATION_AND_BACKEND.md)**: Flujos completos de Google Sign-In, Facebook Native Auth, Microsoft PKCE y funciones Deno de soporte.
* 🛡️ **[Seguridad y Políticas RLS](backend/security.md)**: Row Level Security, claves maestras y separación de privilegios anónimos vs autenticados.

---

## 🚀 Área 4: Infraestructura y CI/CD (`.github/workflows/`)

Despliegue automatizado y servidores en la nube.

* 🖥️ **[Servidor y Pipeline de Despliegue](devops/ci_cd_and_deployment.md)**:
  * Máquina virtual gratuita en Google Cloud Platform (`free-ubuntu-vm`, IP `35.225.109.121`).
  * Servidor web **Nginx** con soporte para Single Page Applications (SPA).
  * Dominio dinámico **`manachynakusa.duckdns.org`** con certificado SSL Let's Encrypt.
  * Pipeline automatizado en **GitHub Actions** (`deploy-frontend.yml`) con 2 fases (validación + despliegue), compresión `.tgz` y recarga de Nginx sin caídas.

---

## ⚖️ Área 5: Cumplimiento y Páginas Legales (`docs/legal/`)

Documentos requeridos para verificación en Meta (Facebook Login) y tiendas de aplicaciones (Play Store y App Store):

* 📜 **[Condiciones del Servicio](legal/terms.html)**
* 🔒 **[Política de Privacidad](legal/privacy.html)**

---

> 💡 **Regla de oro para desarrolladores:** Mantén siempre la estructura monorepo limpia. Código móvil en `mobile/`, código web en `frontend/`, scripts de base de datos en `supabase/` y cualquier cambio documentado en su sección respectiva de `docs/`.
