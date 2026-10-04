
<div align="center">

![App Banner](docs/images/app_banner.png)

<h3>Conectando hogares y servicios de confianza en la provincia de Napo, Ecuador.</h3>

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)

</div>

---

> **MANACHYNA KUSA** es más que una app — es un puente tecnológico desarrollado con el corazón de la Amazonía ecuatoriana.
> Diseñada para fomentar la economía local, facilita el contacto directo entre hogares y proveedores calificados de servicios domésticos en la provincia de Napo.

<div align="center">
  <img src="docs/images/app_mockup.png" alt="App Mockup" width="350" style="border-radius: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.2); margin: 20px 0;" />
</div>

---

## ✨ Lo que nos hace únicos

| | Característica | Descripción |
|---|---|---|
| 🔐 | **Seguridad Garantizada** | Ingreso rápido y seguro con Supabase Auth (Google, Facebook, Microsoft). |
| 🗺️ | **Magia Geográfica** | Integración con Google Maps para ubicar al experto más cercano en tiempo real. |
| ⭐ | **Comunidad de Confianza** | Reseñas 100% reales. Tú eliges a los mejores calificados. |
| 🎨 | **Identidad Amazónica** | UI moderna, limpia y profundamente inspirada en los colores de nuestra región. |
| 📱 | **Catálogo Vivo** | Lista dinámica y en crecimiento de servicios para tu hogar. |

---

## 🛠️ Servicios al Alcance de tu Mano

| Categoría | ¿Qué incluye? |
| :--- | :--- |
| 🧹 **Limpieza doméstica** | Mantenimiento y aseo integral de hogares, oficinas y espacios privados. |
| 🚰 **Plomería** | Soluciones rápidas para tuberías, filtraciones y sistemas de agua. |
| 🪚 **Carpintería** | Creación, reparación y restauración de muebles y estructuras de madera. |
| ⚡ **Electricidad** | Mantenimiento y soluciones seguras para sistemas eléctricos residenciales. |
| 🌿 **Mantenimiento verde** | Adecentamiento de maleza, jardinería y cuidado de áreas verdes. |
| 📦 **Menaje de casa** | Asistencia profesional en mudanzas, embalaje y organización. |
| ♻️ **Gestión de residuos** | Eliminación y recolección de desechos respetando el medio ambiente. |

---

## 📚 Documentación Técnica

¿Eres desarrollador o quieres entender cómo funciona la plataforma por dentro?

👉 **[Documentación Técnica Completa → docs/DOCUMENTATION.md](docs/DOCUMENTATION.md)**

Incluye la arquitectura de la app móvil, el frontend web en React, el diseño de la base de datos PostgreSQL en Supabase y el pipeline de CI/CD en Google Cloud.

---

## 🏗️ Estructura del Monorepo

```text
MANACHYNA-KUSA/
├── mobile/       # 📱 Aplicación móvil completa (Flutter: Android e iOS)
├── frontend/     # ⚛️ Plataforma web oficial (React + Vite + TypeScript + Tailwind)
├── supabase/     # ☁️ Esquemas de base de datos PostgreSQL, migraciones y Edge Functions
├── docs/         # 📖 Documentación técnica detallada
└── .github/      # 🚀 Pipeline de CI/CD para despliegue automatizado en Google Cloud VM
```

---

## 🚀 Empezando (Para Desarrolladores)

### Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>= 3.7.0`
- [Node.js](https://nodejs.org/) `>= 20.0.0` y npm
- Cuenta activa en Firebase y Supabase

### 1️⃣ Clonar el proyecto

```bash
git clone https://github.com/BETACRD01/MANACHYNA-KUSA.git
cd MANACHYNA-KUSA
```

### 2️⃣ Ejecutar la Aplicación Móvil (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```

### 3️⃣ Ejecutar el Frontend Web (React)

```bash
cd frontend
npm install
npm run dev
```

### 4️⃣ Despliegue en Producción
* **Web:** Al hacer `push` a la rama `main`, **GitHub Actions** compila automáticamente el frontend y lo despliega vía SSH seguro a la Máquina Virtual de Google Cloud bajo el dominio `manachynakusa.duckdns.org`.
* **Móvil:** Genera el bundle de producción para Google Play con `cd mobile && flutter build appbundle --release`.

---

## ✒️ Autor

<div align="center">

**Willian Cerda**
*Desarrollador Principal · Ingeniero de Software*

[![Email](https://img.shields.io/badge/Email-williancerda0%40gmail.com-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:williancerda0@gmail.com)

</div>

---

## 📄 Licencia y Derechos de Autor

**Copyright © 2026 Willian Cerda. Todos los derechos reservados.**

Este proyecto es de **código cerrado y propietario**. No es Open Source ni de distribución libre.

El código fuente puede ser consultado con fines educativos o de referencia, pero **queda estrictamente prohibido** su uso comercial, copia, distribución, modificación o integración en otros productos sin el consentimiento previo, expreso y por escrito del autor.

> En resumen: puedes aprender de él, pero no puedes lucrar con él.

Para consultas sobre licencias, colaboraciones o permisos de uso, contactar directamente al autor.

---

<div align="center">
  <i>Desarrollado con ❤️ y mucho café para la comunidad de Napo, Ecuador 🌿</i>
</div>
