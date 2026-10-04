import { useState, useMemo } from 'react';
import type { LegalSection } from '../data/termsData';
import {
  Search,
  Printer,
  Share2,
  CheckCircle2,
  AlertTriangle,
  Info,
  ShieldCheck,
  FileText,
  Copy,
  Check,
  MapPin,
  Clock,
  ArrowUp,
  X
} from 'lucide-react';

interface LegalViewerProps {
  type: 'terms' | 'privacy';
  sections: LegalSection[];
  onSwitchType: (type: 'terms' | 'privacy') => void;
}

export function LegalViewer({ type, sections, onSwitchType }: LegalViewerProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [copiedLink, setCopiedLink] = useState(false);
  const [copiedSectionId, setCopiedSectionId] = useState<string | null>(null);

  const isTerms = type === 'terms';
  const docTitle = isTerms ? 'Términos y Condiciones de Uso' : 'Política de Privacidad y Protección de Datos';
  const docSubtitle = isTerms
    ? 'Acuerdo legal de servicio, intermediación tecnológica y normas de convivencia de MANACHYNA KUSA en la provincia de Napo, Ecuador.'
    : 'Tratamiento lícito, seguridad de la información y cumplimiento de la Ley Orgánica de Protección de Datos Personales (LOPDP) de Ecuador.';

  // Filtrado de secciones según la búsqueda
  const filteredSections = useMemo(() => {
    if (!searchQuery.trim()) return sections;
    const query = searchQuery.toLowerCase();
    return sections.filter((sec) => {
      const matchTitle = sec.title.toLowerCase().includes(query);
      const matchHighlight = sec.highlight?.toLowerCase().includes(query);
      const matchContent = sec.content.some((c) => c.toLowerCase().includes(query));
      const matchBullets = sec.bullets?.some((b) => b.toLowerCase().includes(query));
      return matchTitle || matchHighlight || matchContent || matchBullets;
    });
  }, [sections, searchQuery]);

  const handleCopyDocLink = () => {
    navigator.clipboard.writeText(window.location.href);
    setCopiedLink(true);
    setTimeout(() => setCopiedLink(false), 2000);
  };

  const handleCopySectionLink = (id: string) => {
    const url = `${window.location.origin}${window.location.pathname}#${id}`;
    navigator.clipboard.writeText(url);
    setCopiedSectionId(id);
    setTimeout(() => setCopiedSectionId(null), 2000);
  };

  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 py-8 sm:py-12">
      {/* Header Banner */}
      <div className="bg-gradient-to-br from-emerald-950 via-emerald-900 to-slate-900 rounded-3xl p-6 sm:p-12 text-white shadow-xl relative overflow-hidden mb-8">
        {/* Subtle background decoration */}
        <div className="absolute top-0 right-0 w-96 h-96 bg-emerald-500/10 rounded-full blur-3xl pointer-events-none -mr-20 -mt-20"></div>

        <div className="relative z-10">
          <div className="flex flex-wrap items-center gap-2 mb-4">
            <span className="inline-flex items-center gap-1.5 bg-emerald-500/20 border border-emerald-400/30 text-emerald-200 text-xs font-semibold px-3 py-1 rounded-full">
              <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
              Documento Oficial Vigente 2026
            </span>
            <span className="inline-flex items-center gap-1.5 bg-white/10 text-slate-200 text-xs font-medium px-3 py-1 rounded-full">
              <MapPin className="w-3.5 h-3.5 text-emerald-300" />
              Tena · Napo · Ecuador
            </span>
            <span className="inline-flex items-center gap-1.5 bg-white/10 text-slate-200 text-xs font-medium px-3 py-1 rounded-full">
              <Clock className="w-3.5 h-3.5 text-emerald-300" />
              Revisión: Octubre 2026
            </span>
          </div>

          <h1 className="text-2xl sm:text-4xl lg:text-5xl font-black tracking-tight text-white mb-4 leading-tight">
            {docTitle}
          </h1>
          <p className="text-emerald-100/90 text-sm sm:text-base max-w-3xl leading-relaxed mb-6 font-light">
            {docSubtitle}
          </p>

          {/* Quick tab switcher inside banner */}
          <div className="flex flex-wrap items-center justify-between gap-4 pt-4 border-t border-emerald-800/60">
            <div className="inline-flex p-1 bg-black/40 rounded-xl border border-white/10">
              <button
                onClick={() => onSwitchType('terms')}
                className={`px-4 py-2 rounded-lg text-xs font-bold transition-all flex items-center gap-2 ${
                  isTerms
                    ? 'bg-emerald-600 text-white shadow-sm'
                    : 'text-slate-300 hover:text-white'
                }`}
              >
                <FileText className="w-4 h-4" />
                Términos y Condiciones
              </button>
              <button
                onClick={() => onSwitchType('privacy')}
                className={`px-4 py-2 rounded-lg text-xs font-bold transition-all flex items-center gap-2 ${
                  !isTerms
                    ? 'bg-emerald-600 text-white shadow-sm'
                    : 'text-slate-300 hover:text-white'
                }`}
              >
                <ShieldCheck className="w-4 h-4" />
                Política de Privacidad
              </button>
            </div>

            <div className="flex items-center gap-2">
              <button
                onClick={handleCopyDocLink}
                className="inline-flex items-center gap-1.5 px-3 py-2 bg-white/10 hover:bg-white/20 text-white text-xs font-semibold rounded-xl border border-white/10 transition-colors"
                title="Copiar enlace"
              >
                {copiedLink ? <Check className="w-3.5 h-3.5 text-emerald-300" /> : <Share2 className="w-3.5 h-3.5" />}
                {copiedLink ? '¡Enlace copiado!' : 'Compartir'}
              </button>
              <button
                onClick={() => window.print()}
                className="inline-flex items-center gap-1.5 px-3 py-2 bg-white/10 hover:bg-white/20 text-white text-xs font-semibold rounded-xl border border-white/10 transition-colors"
                title="Imprimir o guardar PDF"
              >
                <Printer className="w-3.5 h-3.5" />
                Imprimir / PDF
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Main Grid: Sidebar TOC + Content Area */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        {/* Left Sticky Sidebar: Table of Contents & Search */}
        <aside className="lg:col-span-4 lg:sticky lg:top-24 space-y-5">
          {/* Search Card */}
          <div className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs">
            <label htmlFor="search-clauses" className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-2">
              Buscar en el documento
            </label>
            <div className="relative">
              <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
              <input
                id="search-clauses"
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Ej. cancelación, GPS, pagos, eliminar cuenta..."
                className="w-full pl-9 pr-8 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs sm:text-sm text-slate-800 placeholder-slate-400 focus:outline-hidden focus:border-emerald-600 focus:bg-white transition-all"
              />
              {searchQuery && (
                <button
                  onClick={() => setSearchQuery('')}
                  className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 p-1"
                >
                  <X className="w-3.5 h-3.5" />
                </button>
              )}
            </div>
            {searchQuery && (
              <p className="text-[11px] text-emerald-700 font-semibold mt-2">
                Mostrando {filteredSections.length} de {sections.length} secciones coincidentes
              </p>
            )}
          </div>

          {/* Table of Contents List */}
          <div className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs max-h-[calc(100vh-280px)] overflow-y-auto">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100 mb-3">
              <span className="text-xs font-bold uppercase tracking-wider text-slate-500">
                Índice de Cláusulas
              </span>
              <span className="text-[11px] bg-slate-100 text-slate-600 font-bold px-2 py-0.5 rounded-full">
                {filteredSections.length} ítems
              </span>
            </div>
            <nav className="space-y-1">
              {filteredSections.map((sec) => (
                <a
                  key={sec.id}
                  href={`#${sec.id}`}
                  className="group flex items-start gap-2.5 p-2 rounded-xl text-xs hover:bg-emerald-50/80 text-slate-600 hover:text-emerald-900 transition-colors"
                >
                  <span className="font-mono text-[10px] font-bold text-emerald-700 bg-emerald-100/60 px-1.5 py-0.5 rounded-md group-hover:bg-emerald-200 transition-colors">
                    {sec.number}
                  </span>
                  <span className="font-medium leading-snug line-clamp-2">
                    {sec.title}
                  </span>
                </a>
              ))}
            </nav>
          </div>

          {/* Help box */}
          <div className="bg-emerald-50/70 border border-emerald-200/80 rounded-2xl p-4 text-xs">
            <h4 className="font-bold text-emerald-950 mb-1 flex items-center gap-1.5">
              <Info className="w-4 h-4 text-emerald-700" />
              ¿Preguntas sobre este acuerdo?
            </h4>
            <p className="text-emerald-800 leading-relaxed mb-3">
              Estamos a tu disposición para aclarar cualquier duda sobre nuestras políticas o el uso de la aplicación.
            </p>
            <a
              href="mailto:willian.cerda@est.itstena.edu.ec"
              className="inline-flex items-center gap-1 font-bold text-emerald-900 hover:underline"
            >
              willian.cerda@est.itstena.edu.ec
            </a>
          </div>
        </aside>

        {/* Right Content Area: Rich Clauses */}
        <section className="lg:col-span-8 space-y-6">
          {/* Requisito Google Play: Banner Especial de Eliminación de Cuenta cuando es privacidad */}
          {!isTerms && (
            <div className="bg-gradient-to-r from-amber-50 to-orange-50 border-2 border-amber-300 rounded-2xl p-5 sm:p-6 shadow-xs">
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 rounded-xl bg-amber-500 text-white flex items-center justify-center shrink-0 shadow-xs">
                  <AlertTriangle className="w-5 h-5" />
                </div>
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-[10px] font-extrabold uppercase tracking-wider bg-amber-200 text-amber-900 px-2 py-0.5 rounded-md">
                      Cumplimiento Google Play
                    </span>
                    <span className="text-[10px] font-extrabold uppercase tracking-wider bg-emerald-200 text-emerald-900 px-2 py-0.5 rounded-md">
                      Ley LOPDP Ecuador
                    </span>
                  </div>
                  <h3 className="font-bold text-slate-900 text-base mb-1">
                    ¿Deseas eliminar tu cuenta y todos tus datos personales?
                  </h3>
                  <p className="text-xs sm:text-sm text-slate-700 leading-relaxed mb-3">
                    En MANACHYNA KUSA puedes ejercer tu derecho a la supresión de datos en cualquier momento. Puedes hacerlo directamente desde la app móvil en <strong>Perfil &gt; Configuración &gt; Eliminar mi cuenta</strong> o enviando una solicitud formal a{' '}
                    <a href="mailto:willian.cerda@est.itstena.edu.ec" className="text-amber-900 font-bold underline">
                      willian.cerda@est.itstena.edu.ec
                    </a>. La purga se completa en máximo 72 horas.
                  </p>
                  <a
                    href="#eliminacion-cuenta"
                    className="inline-flex items-center gap-1.5 text-xs font-bold text-amber-900 hover:text-amber-950 underline"
                  >
                    Ver detalles completos del procedimiento de eliminación &rarr;
                  </a>
                </div>
              </div>
            </div>
          )}

          {filteredSections.length === 0 ? (
            <div className="bg-white p-12 rounded-3xl border border-slate-200 text-center">
              <Search className="w-10 h-10 text-slate-300 mx-auto mb-3" />
              <h3 className="font-bold text-slate-800 text-lg mb-1">No se encontraron cláusulas</h3>
              <p className="text-slate-500 text-xs sm:text-sm mb-4">
                No hay resultados para la búsqueda "{searchQuery}". Prueba con términos como "cancelar", "pago", "ubicación", o limpia el filtro.
              </p>
              <button
                onClick={() => setSearchQuery('')}
                className="px-4 py-2 bg-emerald-700 text-white rounded-xl text-xs font-bold hover:bg-emerald-800 transition-colors"
              >
                Limpiar búsqueda
              </button>
            </div>
          ) : (
            filteredSections.map((sec) => (
              <article
                key={sec.id}
                id={sec.id}
                className="bg-white rounded-3xl border border-slate-200/80 p-6 sm:p-8 shadow-xs hover:border-emerald-300/80 transition-all scroll-mt-24 group"
              >
                {/* Section Header */}
                <div className="flex items-start justify-between gap-4 pb-4 border-b border-slate-100 mb-5">
                  <div className="flex items-center gap-3">
                    <span className="w-9 h-9 rounded-xl bg-emerald-700 text-white font-mono font-bold text-sm flex items-center justify-center shrink-0 shadow-xs">
                      {sec.number}
                    </span>
                    <div>
                      {sec.badge && (
                        <span className="text-[10px] font-extrabold uppercase tracking-wider text-emerald-800 bg-emerald-50 border border-emerald-200/60 px-2 py-0.5 rounded-md inline-block mb-1">
                          {sec.badge}
                        </span>
                      )}
                      <h2 className="text-lg sm:text-xl font-black text-slate-900 leading-tight">
                        {sec.title}
                      </h2>
                    </div>
                  </div>

                  <button
                    onClick={() => handleCopySectionLink(sec.id)}
                    className="p-2 text-slate-400 hover:text-emerald-700 hover:bg-emerald-50 rounded-lg transition-colors shrink-0"
                    title="Copiar enlace a esta sección"
                  >
                    {copiedSectionId === sec.id ? (
                      <Check className="w-4 h-4 text-emerald-600" />
                    ) : (
                      <Copy className="w-4 h-4" />
                    )}
                  </button>
                </div>

                {/* Highlight callout if present */}
                {sec.highlight && (
                  <div className="mb-4 p-3.5 bg-emerald-50/70 border-l-4 border-emerald-600 rounded-r-xl text-xs sm:text-sm font-medium text-emerald-950 leading-relaxed">
                    {sec.highlight}
                  </div>
                )}

                {/* Paragraphs */}
                <div className="space-y-3.5 text-xs sm:text-sm text-slate-700 leading-relaxed">
                  {sec.content.map((p, idx) => (
                    <p key={idx}>{p}</p>
                  ))}
                </div>

                {/* Bullet list if present */}
                {sec.bullets && sec.bullets.length > 0 && (
                  <div className="mt-4 p-4 bg-slate-50/80 rounded-2xl border border-slate-200/60">
                    <h4 className="text-xs font-bold text-slate-800 uppercase tracking-wider mb-2">
                      Puntos clave a considerar:
                    </h4>
                    <ul className="space-y-2">
                      {sec.bullets.map((b, idx) => (
                        <li key={idx} className="flex items-start gap-2 text-xs sm:text-sm text-slate-700 leading-relaxed">
                          <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                          <span>{b}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {/* Callout box (warning, info, important) if present */}
                {sec.callout && (
                  <div
                    className={`mt-5 p-4 rounded-2xl border text-xs sm:text-sm flex items-start gap-3 ${
                      sec.callout.type === 'warning'
                        ? 'bg-amber-50/80 border-amber-300 text-amber-950'
                        : sec.callout.type === 'important'
                        ? 'bg-rose-50/80 border-rose-200 text-rose-950'
                        : 'bg-sky-50/80 border-sky-200 text-sky-950'
                    }`}
                  >
                    {sec.callout.type === 'warning' && <AlertTriangle className="w-5 h-5 text-amber-600 shrink-0 mt-0.5" />}
                    {sec.callout.type === 'important' && <ShieldCheck className="w-5 h-5 text-rose-600 shrink-0 mt-0.5" />}
                    {sec.callout.type === 'info' && <Info className="w-5 h-5 text-sky-600 shrink-0 mt-0.5" />}
                    <div>
                      <h5 className="font-bold text-xs uppercase tracking-wider mb-1">
                        {sec.callout.title}
                      </h5>
                      <p className="leading-relaxed">{sec.callout.text}</p>
                    </div>
                  </div>
                )}
              </article>
            ))
          )}

          {/* Bottom Back-to-Top Button */}
          <div className="pt-6 flex items-center justify-between">
            <span className="text-xs text-slate-500">
              MANACHYNA KUSA · Documento registrado para la República del Ecuador
            </span>
            <button
              onClick={scrollToTop}
              className="inline-flex items-center gap-1.5 px-4 py-2 bg-white border border-slate-200 rounded-xl text-xs font-bold text-slate-700 hover:text-emerald-700 hover:border-emerald-300 shadow-xs transition-colors"
            >
              <ArrowUp className="w-3.5 h-3.5" />
              Volver arriba
            </button>
          </div>
        </section>
      </div>
    </div>
  );
}
