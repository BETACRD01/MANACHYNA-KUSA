import { useEffect, useState } from 'react';
import { supabase } from './lib/supabase';
import { TERMS_SECTIONS } from './data/termsData';
import { PRIVACY_SECTIONS } from './data/privacyData';
import { LegalViewer } from './components/LegalViewer';
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

function getInitialTab(): 'home' | 'terms' | 'privacy' {
  if (typeof window === 'undefined') return 'home';
  const path = window.location.pathname.toLowerCase();
  const hash = window.location.hash.toLowerCase();
  if (path.includes('term') || path.includes('condicion') || hash.includes('terms')) return 'terms';
  if (path.includes('privac') || hash.includes('privacy')) return 'privacy';
  return 'home';
}

export function App() {
  const [currentTab, setCurrentTab] = useState<'home' | 'terms' | 'privacy'>(getInitialTab);
  const [categories, setCategories] = useState<Category[]>([]);
  const [services, setServices] = useState<Service[]>([]);
  const [loading, setLoading] = useState(true);
  const [backendStatus, setBackendStatus] = useState<'connected' | 'error' | 'checking'>('checking');

  const navigateTo = (tab: 'home' | 'terms' | 'privacy') => {
    setCurrentTab(tab);
    const targetPath = tab === 'home' ? '/' : `/${tab}`;
    if (window.location.pathname !== targetPath) {
      window.history.pushState(null, '', targetPath);
    }
  };

  useEffect(() => {
    const handlePopState = () => {
      setCurrentTab(getInitialTab());
    };
    window.addEventListener('popstate', handlePopState);
    return () => window.removeEventListener('popstate', handlePopState);
  }, []);

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
            onClick={() => navigateTo('home')}
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
              onClick={() => navigateTo('home')}
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
              onClick={() => navigateTo('terms')}
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
              onClick={() => navigateTo('privacy')}
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

            {/* Confianza, Seguridad y Transparencia Legal */}
            <section className="bg-emerald-950 text-white py-14 px-4 border-t border-emerald-900">
              <div className="max-w-6xl mx-auto">
                <div className="text-center max-w-2xl mx-auto mb-10">
                  <span className="text-[11px] font-bold uppercase tracking-wider text-emerald-300 bg-emerald-900/60 px-3 py-1 rounded-full border border-emerald-800">
                    Compromiso y Seguridad
                  </span>
                  <h2 className="text-2xl sm:text-3xl font-black mt-3 mb-2">
                    Garantía y Confianza en Cada Servicio
                  </h2>
                  <p className="text-emerald-200/80 text-xs sm:text-sm">
                    Construido bajo altos estándares éticos, técnicos y normativos en la provincia de Napo
                  </p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                  <div className="bg-white/5 border border-white/10 rounded-3xl p-6 hover:bg-white/10 transition-colors">
                    <div className="w-11 h-11 rounded-2xl bg-emerald-500/20 text-emerald-300 flex items-center justify-center mb-4">
                      <ShieldCheck className="w-6 h-6" />
                    </div>
                    <h3 className="font-bold text-base mb-2 text-white">Protección de Datos (LOPDP)</h3>
                    <p className="text-emerald-100/70 text-xs sm:text-sm leading-relaxed mb-4">
                      Tratamiento lícito, seguro y transparente de tu información personal conforme a la Ley Orgánica de Protección de Datos Personales del Ecuador.
                    </p>
                    <button
                      onClick={() => navigateTo('privacy')}
                      className="text-xs font-bold text-emerald-300 hover:text-emerald-200 flex items-center gap-1 cursor-pointer"
                    >
                      Leer Política de Privacidad &rarr;
                    </button>
                  </div>

                  <div className="bg-white/5 border border-white/10 rounded-3xl p-6 hover:bg-white/10 transition-colors">
                    <div className="w-11 h-11 rounded-2xl bg-emerald-500/20 text-emerald-300 flex items-center justify-center mb-4">
                      <FileText className="w-6 h-6" />
                    </div>
                    <h3 className="font-bold text-base mb-2 text-white">Términos Claros y Transparentes</h3>
                    <p className="text-emerald-100/70 text-xs sm:text-sm leading-relaxed mb-4">
                      Tarifas justas, políticas de cancelación sin sorpresas y reglas claras de convivencia y seguridad entre clientes y técnicos de Napo.
                    </p>
                    <button
                      onClick={() => navigateTo('terms')}
                      className="text-xs font-bold text-emerald-300 hover:text-emerald-200 flex items-center gap-1 cursor-pointer"
                    >
                      Ver Términos y Condiciones &rarr;
                    </button>
                  </div>

                  <div className="bg-white/5 border border-white/10 rounded-3xl p-6 hover:bg-white/10 transition-colors">
                    <div className="w-11 h-11 rounded-2xl bg-emerald-500/20 text-emerald-300 flex items-center justify-center mb-4">
                      <Sparkles className="w-6 h-6" />
                    </div>
                    <h3 className="font-bold text-base mb-2 text-white">Proveedores Verificados</h3>
                    <p className="text-emerald-100/70 text-xs sm:text-sm leading-relaxed mb-4">
                      Revisión de antecedentes penales, cédula y experiencia técnica para brindarte la máxima confianza y tranquilidad en tu domicilio.
                    </p>
                    <span className="text-xs font-bold text-emerald-400">
                      Tena · Archidona · Napo
                    </span>
                  </div>
                </div>
              </div>
            </section>
          </div>
        )}

        {/* Tab Términos y Condiciones */}
        {currentTab === 'terms' && (
          <LegalViewer
            type="terms"
            sections={TERMS_SECTIONS}
            onSwitchType={navigateTo}
          />
        )}

        {/* Tab Política de Privacidad */}
        {currentTab === 'privacy' && (
          <LegalViewer
            type="privacy"
            sections={PRIVACY_SECTIONS}
            onSwitchType={navigateTo}
          />
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
              onClick={() => navigateTo('terms')}
              className="hover:text-emerald-400 transition-colors"
            >
              Términos del Servicio
            </button>
            <button
              onClick={() => navigateTo('privacy')}
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
