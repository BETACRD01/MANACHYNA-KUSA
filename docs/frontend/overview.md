# ⚛️ Frontend Web (React + Vite + Tailwind CSS)

Plataforma web oficial de **MANACHYNA KUSA**, diseñada para ofrecer una experiencia rápida, moderna y responsiva a usuarios que acceden desde navegadores de escritorio y móviles.

---

## 🛠️ Stack Tecnológico

| Herramienta | Versión / Tipo | Propósito |
|---|---|---|
| **React** | 19.x | Biblioteca UI declarativa con componentes funcionales |
| **Vite** | 8.x | Empaquetador y entorno de desarrollo ultrarrápido |
| **TypeScript** | 5.x / 6.x | Tipado estático y seguridad de datos en desarrollo |
| **Tailwind CSS** | v4 | Estilos atómicos y paleta inspirada en la Amazonía |
| **`@supabase/supabase-js`** | 2.x | Cliente SDK para consultar la base de datos y autenticación |
| **Lucide React** | Icons | Iconografía vectorial moderna y liviana |

---

## 📁 Estructura del Código (`frontend/`)

```text
frontend/
├── src/
│   ├── assets/              # Imágenes y logos de marca
│   ├── lib/
│   │   └── supabase.ts      # Inicialización del cliente Supabase
│   ├── App.tsx              # Componente principal (Catálogo, Términos, Privacidad)
│   ├── main.tsx             # Punto de entrada de React
│   └── index.css            # Importación y configuración de Tailwind CSS
├── public/                  # Archivos estáticos públicos (favicons, svgs)
├── dist/                    # Archivos compilados listos para producción
├── .env                     # Variables locales con la URL y anonKey de Supabase
├── package.json             # Dependencias y scripts de ejecución
├── tsconfig.json            # Configuración del compilador TypeScript
└── vite.config.ts           # Configuración de Vite con plugins de React y Tailwind
```

---

## 🔄 Conexión con Supabase

El frontend consume la base de datos de Supabase en tiempo real a través de su cliente oficial configurado en `src/lib/supabase.ts`:

```typescript
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://ikdcqxgecjzgjntejizu.supabase.co';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

### Consultas Implementadas en Vivo:
* **Categorías activas:**  
  `supabase.from('service_categories').select('*').eq('is_active', true).order('sort_order', { ascending: true })`
* **Servicios destacados:**  
  `supabase.from('services').select('id, category_id, name, description, base_price, price_unit').eq('is_active', true)`

---

## 📜 Secciones Integradas en la Web

1. **Hero y Bienvenida:** Presentación oficial de los servicios domésticos en Napo, Ecuador, con indicador de estado del backend en tiempo real.
2. **Catálogo de Servicios:** Tarjetas interactivas con los precios base y descripciones cargadas directamente de la base de datos.
3. **Términos y Condiciones:** Texto legal completo y formal aprobado para Meta y tiendas de aplicaciones.
4. **Política de Privacidad:** Cumplimiento de normativas de privacidad y eliminación de datos personales.

---

## 💻 Flujo de Trabajo Local

```bash
# 1. Ingresar a la carpeta frontend
cd frontend

# 2. Instalar dependencias
npm install

# 3. Iniciar servidor de desarrollo local (http://localhost:5173)
npm run dev

# 4. Compilar para producción (genera la carpeta dist/)
npm run build
```

---

## 🚀 Despliegue en Producción

El frontend está configurado para desplegarse automáticamente en la **Máquina Virtual de Google Cloud** bajo el dominio `manachynakusa.duckdns.org` mediante el pipeline de CI/CD de GitHub Actions cada vez que se hace un `push` a la rama `main`.
