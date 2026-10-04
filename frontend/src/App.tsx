import { useEffect, useState } from 'react';
import { supabase } from './lib/supabase';
import {
  ShieldCheck,
  FileText,
  Home,
  Wrench,
  Sparkles,
  Mail,
  ChevronRight,
  Server
} from 'lucide-react';

interface Category {
  id: string;
  name: string;
  slug: string;
  description: string;
  color?: string;
  icon?: string;
}

interface Service {
  id: string;
  category_id: string;
  name: string;
  description: string;
  base_price: number;
  price_unit: string;
}

export function App() {
  const [currentTab, setCurrentTab] = useState<'home' | 'terms' | 'privacy'>('home');
  const [categories, setCategories] = useState<Category[]>([]);
  const [services, setServices] = useState<Service[]>([]);
  const [loading, setLoading] = useState(true);
  const [backendStatus, setBackendStatus] = useState<'connected' | 'error' | 'checking'>('checking');

  useEffect(() => {
    async function loadData() {
      try {
        setLoading(true);
        // Verificar conexión a Supabase
        const { data: catData, error: catError } = await supabase
          .from('service_categories')
          .select('*')
          .eq('is_active', true)
          .order('sort_order', { ascending: true });

        if (catError) throw catError;

        const { data: servData, error: servError } = await supabase
          .from('services')
          .select('id, category_id, name, description, base_price, price_unit')
          .eq('is_active', true)
          .limit(10);

        if (servError) throw servError;

        setCategories(catData || []);
        setServices(servData || []);
        setBackendStatus('connected');
      } catch (err) {
        console.error('Error cargando datos de Supabase:', err);
        setBackendStatus('error');
      } finally {
        setLoading(false);
      }
    }

    loadData();
  }, []);

  return (
    <div className="min-h-screen flex flex-col bg-slate-50 text-slate-800">
      {/* Top Navbar */}
      <header className="sticky top-0 z-50 bg-white/90 backdrop-blur-md border-b border-emerald-100 shadow-xs">
        <div className="max-w-6xl mx-auto px-4 h-16 flex items-center justify-between">
          <div
            className="flex items-center gap-3 cursor-pointer"
            onClick={() => setCurrentTab('home')}
          >
            <div className="w-10 h-10 rounded-xl bg-emerald-700 text-white flex items-center justify-center font-black text-xl shadow-xs">
              M
            </div>
            <div>
              <span className="font-bold text-lg text-emerald-900 tracking-tight block leading-tight">
                MANACHYNA KUSA
              </span>
              <span className="text-[11px] text-emerald-600 font-medium">Napo, Ecuador</span>
            </div>
          </div>

          <nav className="flex items-center gap-1 sm:gap-2">
            <button
              onClick={() => setCurrentTab('home')}
              className={`px-3 py-1.5 rounded-lg text-sm font-semibold transition-colors flex items-center gap-1.5 ${
                currentTab === 'home'
                  ? 'bg-emerald-50 text-emerald-800'
                  : 'text-slate-600 hover:text-emerald-700'
              }`}
            >
              <Home className="w-4 h-4" />
              <span>Inicio</span>
            </button>

            <button
              onClick={() => setCurrentTab('terms')}
              className={`px-3 py-1.5 rounded-lg text-sm font-semibold transition-colors flex items-center gap-1.5 ${
                currentTab === 'terms'
                  ? 'bg-emerald-50 text-emerald-800'
                  : 'text-slate-600 hover:text-emerald-700'
              }`}
            >
              <FileText className="w-4 h-4" />
              <span>Términos</span>
            </button>

            <button
              onClick={() => setCurrentTab('privacy')}
              className={`px-3 py-1.5 rounded-lg text-sm font-semibold transition-colors flex items-center gap-1.5 ${
                currentTab === 'privacy'
                  ? 'bg-emerald-50 text-emerald-800'
                  : 'text-slate-600 hover:text-emerald-700'
              }`}
            >
              <ShieldCheck className="w-4 h-4" />
              <span>Privacidad</span>
            </button>
          </nav>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="flex-1">
        {currentTab === 'home' && (
          <div>
            {/* Hero Section */}
            <section className="bg-gradient-to-b from-emerald-900 via-emerald-800 to-emerald-950 text-white py-16 px-4">
              <div className="max-w-4xl mx-auto text-center">
                <div className="inline-flex items-center gap-2 bg-emerald-500/20 border border-emerald-400/30 px-3 py-1 rounded-full text-xs font-semibold uppercase tracking-wider text-emerald-200 mb-6">
                  <Sparkles className="w-3.5 h-3.5" />
                  Plataforma Oficial · Provincia de Napo
                </div>
                <h1 className="text-3xl sm:text-5xl font-black tracking-tight leading-tight mb-4">
                  Conectando hogares con profesionales de confianza
                </h1>
                <p className="text-emerald-100 text-base sm:text-lg max-w-2xl mx-auto mb-8 font-light">
                  Servicios de plomería, electricidad, limpieza, pintura y mantenimiento doméstico con proveedores verificados y calificados por la comunidad.
                </p>

                {/* Backend status indicator */}
                <div className="inline-flex items-center gap-2 bg-black/30 backdrop-blur-xs px-4 py-2 rounded-xl text-xs border border-white/10">
                  <Server className="w-4 h-4 text-emerald-400" />
                  <span>Estado del Backend Supabase:</span>
                  {backendStatus === 'connected' && (
                    <span className="text-emerald-300 font-semibold flex items-center gap-1">
                      <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span> Conectado en Vivo
                    </span>
                  )}
                  {backendStatus === 'checking' && (
                    <span className="text-amber-300">Conectando...</span>
                  )}
                  {backendStatus === 'error' && (
                    <span className="text-rose-300">Error de conexión</span>
                  )}
                </div>
              </div>
            </section>

            {/* Categorías de Servicios */}
            <section className="max-w-6xl mx-auto px-4 py-12">
              <div className="flex items-center justify-between mb-8">
                <div>
                  <h2 className="text-2xl font-bold text-slate-900 tracking-tight">Categorías de Servicios</h2>
                  <p className="text-slate-500 text-sm mt-1">Servicios disponibles en tiempo real desde Supabase</p>
                </div>
                <span className="text-xs bg-emerald-100 text-emerald-800 font-bold px-2.5 py-1 rounded-full">
                  {categories.length} categorías
                </span>
              </div>

              {loading ? (
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
                  {[1, 2, 3, 4].map((i) => (
                    <div key={i} className="h-32 bg-slate-200 animate-pulse rounded-2xl"></div>
                  ))}
                </div>
              ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
                  {categories.map((cat) => (
                    <div
                      key={cat.id}
                      className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs hover:shadow-md transition-shadow flex flex-col justify-between group"
                    >
                      <div className="flex items-start justify-between mb-3">
                        <div
                          className="w-10 h-10 rounded-xl flex items-center justify-center font-bold text-white shadow-xs"
                          style={{ backgroundColor: cat.color || '#176b32' }}
                        >
                          <Wrench className="w-5 h-5" />
                        </div>
                        <ChevronRight className="w-4 h-4 text-slate-400 group-hover:text-emerald-700 transition-colors" />
                      </div>
                      <div>
                        <h3 className="font-bold text-slate-900 text-base mb-1">{cat.name}</h3>
                        <p className="text-xs text-slate-500 line-clamp-2 leading-relaxed">
                          {cat.description}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </section>

            {/* Catálogo en Vivo */}
            <section className="max-w-6xl mx-auto px-4 pb-16">
              <h2 className="text-2xl font-bold text-slate-900 tracking-tight mb-2">Servicios Populares</h2>
              <p className="text-slate-500 text-sm mb-6">Precios base referenciales administrados desde la base de datos</p>

              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-5">
                {services.map((serv) => (
                  <div
                    key={serv.id}
                    className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs hover:border-emerald-300 transition-all flex flex-col justify-between"
                  >
                    <div>
                      <span className="text-[11px] font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-md uppercase tracking-wider">
                        Verificado
                      </span>
                      <h4 className="font-bold text-slate-900 text-base mt-2 mb-1">{serv.name}</h4>
                      <p className="text-xs text-slate-600 leading-relaxed mb-4">{serv.description}</p>
                    </div>
                    <div className="pt-3 border-t border-slate-100 flex items-center justify-between">
                      <span className="text-xs text-slate-500 font-medium">Tarifa base</span>
                      <span className="text-base font-extrabold text-emerald-800">
                        ${serv.base_price.toFixed(2)}{' '}
                        <span className="text-xs font-normal text-slate-500">/ {serv.price_unit}</span>
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            </section>
          </div>
        )}

        {/* Tab Términos y Condiciones */}
        {currentTab === 'terms' && (
          <div className="max-w-4xl mx-auto px-4 py-12">
            <div className="bg-white p-8 sm:p-12 rounded-3xl border border-slate-200/80 shadow-sm">
              <span className="text-xs font-bold uppercase tracking-wider text-emerald-700 bg-emerald-50 px-3 py-1 rounded-full">
                Acuerdo Legal
              </span>
              <h1 className="text-3xl sm:text-4xl font-black text-slate-900 mt-4 mb-2">
                Condiciones del Servicio
              </h1>
              <p className="text-slate-500 text-sm mb-8">
                MANACHYNA KUSA · Última actualización: 2026
              </p>

              <div className="space-y-6 text-sm text-slate-700 leading-relaxed">
                <section className="pb-6 border-b border-slate-100">
                  <h3 className="font-bold text-base text-emerald-900 mb-2">1. Aceptación de los Términos</h3>
                  <p>
                    Al descargar, acceder o utilizar la aplicación móvil o la plataforma web de MANACHYNA KUSA, el usuario acepta de manera expresa e irrevocable cumplir con los presentes Términos y Condiciones de Uso. Si no está de acuerdo con alguno de los términos, no deberá utilizar la aplicación.
                  </p>
                </section>

                <section className="pb-6 border-b border-slate-100">
                  <h3 className="font-bold text-base text-emerald-900 mb-2">2. Naturaleza del Servicio</h3>
                  <p>
                    MANACHYNA KUSA es una plataforma tecnológica que facilita el contacto y la intermediación entre clientes residenciales y proveedores independientes de servicios domésticos y técnicos en la provincia de Napo, República del Ecuador.
                  </p>
                </section>

                <section className="pb-6 border-b border-slate-100">
                  <h3 className="font-bold text-base text-emerald-900 mb-2">3. Cuentas y Autenticación</h3>
                  <p>
                    El usuario puede autenticarse utilizando proveedores autorizados (Google, Facebook o Microsoft). Cada usuario es responsable de salvaguardar sus credenciales de acceso y de toda actividad originada bajo su cuenta.
                  </p>
                </section>

                <section className="pb-6 border-b border-slate-100">
                  <h3 className="font-bold text-base text-emerald-900 mb-2">4. Compromiso de los Proveedores</h3>
                  <p>
                    Los proveedores que ofrecen sus servicios en la plataforma declaran contar con los conocimientos, herramientas y aptitudes necesarias para ejecutar las tareas ofrecidas con altos estándares de calidad, seguridad y respeto.
                  </p>
                </section>

                <section>
                  <h3 className="font-bold text-base text-emerald-900 mb-2">5. Contacto Legal</h3>
                  <p>
                    Para cualquier consulta, reclamo o notificación relativa a estas condiciones, puede comunicarse directamente al correo electrónico oficial:{' '}
                    <a
                      href="mailto:willian.cerda@est.itstena.edu.ec"
                      className="text-emerald-700 font-bold hover:underline"
                    >
                      willian.cerda@est.itstena.edu.ec
                    </a>
                  </p>
                </section>
              </div>
            </div>
          </div>
        )}

        {/* Tab Política de Privacidad */}
        {currentTab === 'privacy' && (
          <div className="max-w-4xl mx-auto px-4 py-12">
            <div className="bg-white p-8 sm:p-12 rounded-3xl border border-slate-200/80 shadow-sm">
              <span className="text-xs font-bold uppercase tracking-wider text-emerald-700 bg-emerald-50 px-3 py-1 rounded-full">
                Protección de Datos
              </span>
              <h1 className="text-3xl sm:text-4xl font-black text-slate-900 mt-4 mb-2">
                Política de Privacidad
              </h1>
              <p className="text-slate-500 text-sm mb-8">
                MANACHYNA KUSA · Conforme a las normativas de protección de datos
              </p>

              <div className="space-y-6 text-sm text-slate-700 leading-relaxed">
                <section className="pb-6 border-b border-slate-100">
                  <h3 className="font-bold text-base text-emerald-900 mb-2">1. Información que recopilamos</h3>
                  <p>
                    Recopilamos únicamente la información necesaria para coordinar y prestar los servicios: nombre, correo electrónico autenticado, datos básicos de perfil proporcionados por el proveedor OAuth (Google, Facebook o Microsoft), y ubicación geográfica cuando el usuario solicita un servicio a domicilio.
                  </p>
                </section>

                <section className="pb-6 border-b border-slate-100">
                  <h3 className="font-bold text-base text-emerald-900 mb-2">2. Uso de la Información</h3>
                  <p>
                    La información se emplea exclusivamente para:
                  </p>
                  <ul className="list-disc pl-5 mt-2 space-y-1 text-slate-600">
                    <li>Conectar al cliente con el proveedor más cercano.</li>
                    <li>Gestionar las solicitudes y reservas de servicios.</li>
                    <li>Notificar el estado de las órdenes en curso mediante Firebase Cloud Messaging (FCM).</li>
                    <li>Mejorar la seguridad y prevenir fraudes o conductas abusivas.</li>
                  </ul>
                </section>

                <section className="pb-6 border-b border-slate-100">
                  <h3 className="font-bold text-base text-emerald-900 mb-2">3. Eliminación y Derechos del Usuario</h3>
                  <p>
                    Usted tiene derecho a solicitar la rectificación o eliminación total de sus datos personales en cualquier momento escribiendo a:{' '}
                    <a
                      href="mailto:willian.cerda@est.itstena.edu.ec"
                      className="text-emerald-700 font-bold hover:underline"
                    >
                      willian.cerda@est.itstena.edu.ec
                    </a>.
                  </p>
                </section>

                <section>
                  <h3 className="font-bold text-base text-emerald-900 mb-2">4. Almacenamiento Seguro</h3>
                  <p>
                    Todos los datos son transmitidos bajo cifrado SSL/TLS y almacenados en bases de datos PostgreSQL con políticas estrictas de seguridad a nivel de fila (Row Level Security - RLS).
                  </p>
                </section>
              </div>
            </div>
          </div>
        )}
      </main>

      {/* Footer */}
      <footer className="bg-slate-900 text-slate-400 py-10 px-4 border-t border-slate-800">
        <div className="max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-6 text-xs">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-lg bg-emerald-600 text-white font-black flex items-center justify-center text-sm">
              M
            </div>
            <div>
              <p className="font-bold text-slate-200">MANACHYNA KUSA</p>
              <p className="text-slate-500">Provincia de Napo, Ecuador · Desarrollado por Willian Cerda</p>
            </div>
          </div>

          <div className="flex items-center gap-6">
            <button
              onClick={() => setCurrentTab('terms')}
              className="hover:text-emerald-400 transition-colors"
            >
              Términos del Servicio
            </button>
            <button
              onClick={() => setCurrentTab('privacy')}
              className="hover:text-emerald-400 transition-colors"
            >
              Política de Privacidad
            </button>
            <a
              href="mailto:willian.cerda@est.itstena.edu.ec"
              className="hover:text-emerald-400 transition-colors flex items-center gap-1"
            >
              <Mail className="w-3.5 h-3.5" />
              Contacto
            </a>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default App;
