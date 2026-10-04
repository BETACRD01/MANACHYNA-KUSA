export interface LegalSection {
  id: string;
  number: string;
  title: string;
  badge?: string;
  highlight?: string;
  content: string[];
  bullets?: string[];
  callout?: {
    type: 'warning' | 'info' | 'important';
    title: string;
    text: string;
  };
}

export const TERMS_SECTIONS: LegalSection[] = [
  {
    id: 'aceptacion',
    number: '01',
    title: 'Aceptación de los Términos y Ámbito de Aplicación',
    badge: 'Fundamental',
    highlight: 'El uso de la aplicación móvil y sitio web implica la aceptación plena de este contrato legal.',
    content: [
      'Bienvenido a MANACHYNA KUSA. Los presentes Términos y Condiciones de Uso constituyen un acuerdo legal vinculante celebrado entre cualquier persona natural o jurídica que descargue, instale, acceda o utilice la aplicación móvil o la plataforma web (en adelante, el "Usuario") y MANACHYNA KUSA, proyecto tecnológico con operaciones orientadas a la provincia de Napo (Tena, Archidona y sectores aledaños), República del Ecuador.',
      'Al pulsar en "Aceptar", crear una cuenta de usuario, iniciar sesión mediante proveedores de identidad (Google, Microsoft o correo) o simplemente interactuar con nuestros servicios, usted declara de forma expresa, libre e informada que ha leído, comprendido y aceptado en su totalidad las cláusulas aquí estipuladas.',
      'Si usted no está de acuerdo con alguno de los términos o no cuenta con la capacidad legal requerida, deberá abstenerse de instalar la aplicación, desinstalarla de su dispositivo móvil y cesar cualquier interacción con la plataforma.'
    ],
    callout: {
      type: 'important',
      title: 'Capacidad Legal Requerida',
      text: 'Nuestros servicios están destinados únicamente a personas con capacidad jurídica para contratar (mayores de 18 años según la legislación ecuatoriana). Queda prohibido el registro a menores de edad sin la supervisión directa de sus padres o tutores legales.'
    }
  },
  {
    id: 'naturaleza',
    number: '02',
    title: 'Naturaleza de la Plataforma e Intermediación Digital',
    badge: 'Modelo Operativo',
    highlight: 'Manachyna Kusa es una plataforma de enlace tecnológico y no una empresa contratista ni empleadora directa de los técnicos.',
    content: [
      'MANACHYNA KUSA opera estrictamente como una plataforma digital de intermediación tecnológica y comunicación que conecta a personas o empresas que solicitan servicios técnicos o domésticos ("Clientes") con técnicos, artesanos o trabajadores independientes calificados ("Proveedores" o "Especialistas").',
      'MANACHYNA KUSA NO es una empresa de servicios de fontanería, electricidad, limpieza, construcción o agronomía, ni actúa como empleador, contratista directo, mandatario o agente de los Proveedores registrados. Cada Proveedor actúa de manera autónoma, independiente y por cuenta propia.',
      'En consecuencia, la relación laboral o de dependencia contemplada en los Artículos 8 y 11 del Código del Trabajo de la República del Ecuador no existe entre MANACHYNA KUSA y los Proveedores. El contrato final de prestación de servicios se perfecciona directa y exclusivamente entre el Cliente y el Proveedor adjudicado.'
    ]
  },
  {
    id: 'cuentas',
    number: '03',
    title: 'Registro de Cuenta, Autenticación y Veracidad',
    badge: 'Seguridad',
    content: [
      'Para solicitar u ofertar servicios en MANACHYNA KUSA, el Usuario debe registrarse y mantener una cuenta personal activa. La autenticación se realiza mediante credenciales seguras de proveedores OAuth 2.0 (Google, Microsoft, Facebook) o correo electrónico validado.',
      'El Usuario se compromete a suministrar información exacta, verídica, vigente y comprobable. Queda terminantemente prohibido utilizar identidades falsas, fotografías de terceros sin autorización o crear múltiples cuentas con fines fraudulentos o para eludir sanciones.',
      'El Usuario es el único responsable de mantener la confidencialidad de sus credenciales y de toda actividad realizada desde su cuenta o dispositivo móvil. En caso de pérdida, sustracción o sospecha de acceso no autorizado, debe notificarlo de inmediato al soporte oficial.'
    ],
    bullets: [
      'Prohibido ceder, transferir o prestar la cuenta a terceras personas.',
      'Obligación de mantener actualizados el número de teléfono móvil y el correo de contacto.',
      'Verificación periódica de la identidad de usuarios y proveedores mediante mecanismos de seguridad.'
    ]
  },
  {
    id: 'proveedores',
    number: '04',
    title: 'Requisitos y Compromiso de los Proveedores / Especialistas',
    badge: 'Calidad y Confianza',
    highlight: 'Los especialistas pasan por un filtro de verificación de antecedentes y competencias antes de prestar servicios.',
    content: [
      'Los Usuarios que se registren en calidad de Proveedores o Técnicos deberán superar el proceso de validación documental establecido por la plataforma, que puede incluir:',
      'Los Proveedores garantizan que disponen de las herramientas, equipos de protección individual (EPI), destrezas técnicas y conocimientos profesionales indispensables para ejecutar las labores encomendadas sin poner en riesgo la integridad física de las personas ni la seguridad de los bienes inmuebles.',
      'Cualquier falsedad en los documentos presentados constituirá causal de expulsión inmediata y definitiva de la plataforma, reservándose MANACHYNA KUSA el derecho de poner en conocimiento de las autoridades judiciales correspondientes las conductas presumiblemente ilícitas.'
    ],
    bullets: [
      'Cédula de ciudadanía o documento de identidad oficial emitido en el Ecuador.',
      'Certificado de antecedentes penales actualizado emitido por el Ministerio del Interior.',
      'Títulos de bachiller técnico, artesano calificado o certificados laborales avalados.',
      'Comprobante de domicilio o residencia en la provincia de Napo (Tena / Archidona).'
    ]
  },
  {
    id: 'solicitudes-gps',
    number: '05',
    title: 'Solicitud de Servicios y Uso de Geolocalización (GPS)',
    badge: 'Geolocalización',
    content: [
      'La solicitud de servicios se realiza seleccionando la categoría correspondiente (ej. Plomería, Electricidad, Limpieza, Mantenimiento, Agronomía, Soporte Técnico), describiendo detalladamente la necesidad y precisando la ubicación exacta del domicilio mediante las funciones de mapa y GPS integradas en la app.',
      'Para que la plataforma pueda conectar al Cliente con el técnico disponible más cercano y calcular los tiempos estimados de arribo, es indispensable que el Usuario otorgue los permisos de geolocalización en su dispositivo móvil mientras utiliza la aplicación.',
      'Una vez que un Proveedor acepta la solicitud, el Cliente recibirá una confirmación con el nombre, fotografía, calificación promedio y datos de contacto del técnico asignado para coordinar la llegada.'
    ],
    callout: {
      type: 'info',
      title: 'Precisión de la Ubicación',
      text: 'Es responsabilidad del Cliente confirmar que el punto de ubicación en el mapa de Tena o Napo corresponda exactamente al lugar de intervención, proporcionando referencias claras (barrio, calle secundaria, color de casa) para evitar retrasos.'
    }
  },
  {
    id: 'precios-pagos',
    number: '06',
    title: 'Tarifas, Pagos, Comisiones y Facturación',
    badge: 'Transparencia',
    content: [
      'Los precios mostrados en el catálogo de la plataforma corresponden a tarifas base referenciales (por hora o por labor inicial). En casos donde el servicio requiera materiales, repuestos o trabajos de mayor complejidad, el Proveedor acordará de forma previa y transparente con el Cliente el presupuesto final antes de iniciar la obra.',
      'Métodos de Pago: El pago de los servicios se efectúa preferentemente en efectivo una vez concluida y revisada la labor a entera satisfacción del Cliente, o mediante transferencia bancaria directa (Banco Pichincha, Guayaquil, Cooperativas locales de Napo) según convengan las partes.',
      'Comisión de Plataforma: MANACHYNA KUSA puede aplicar tarifas de intermediación o cobros por gestión técnica a los Proveedores por el uso de la infraestructura tecnológica, las cuales se comunicarán con debida antelación.',
      'Facturación e Impuestos: Cada Proveedor es responsable de cumplir con las obligaciones tributarias que le correspondan ante el Servicio de Rentas Internas (SRI) del Ecuador, incluyendo la emisión de notas de venta o facturas electrónicas de acuerdo a su régimen (ej. RIMPE Negocio Popular o RIMPE Emprendedor).'
    ]
  },
  {
    id: 'cancelaciones',
    number: '07',
    title: 'Cancelaciones, Puntualidad y Política de "No Presentación"',
    badge: 'Compromiso',
    content: [
      'Cancelación por el Cliente: El Cliente puede cancelar una solicitud de servicio sin costo alguno siempre que lo haga antes de que el técnico inicie su desplazamiento hacia el domicilio.',
      'Si el Cliente cancela cuando el técnico ya se encuentra en camino o ha llegado al domicilio convenido, el Cliente deberá abonar una tarifa mínima de movilización ($2.50 a $5.00 USD según la distancia en la zona de Napo) en compensación por el tiempo y gasto de traslado del profesional.',
      'Cancelación o Retraso del Proveedor: Si el Proveedor no puede acudir a la cita por causas de fuerza mayor debidamente justificadas, debe avisar al Cliente a través de la app con al menos 1 hora de anticipación. Las inasistencias injustificadas ("No-Show") afectarán gravemente la calificación del técnico y podrán derivar en la suspensión temporal o definitiva de su cuenta.'
    ]
  },
  {
    id: 'conducta-seguridad',
    number: '08',
    title: 'Reglas de Conducta, Convivencia y Seguridad en el Domicilio',
    badge: 'Seguridad Mutua',
    content: [
      'MANACHYNA KUSA promueve un ambiente de respeto, integridad, equidad y dignidad humana. Se aplican las siguientes reglas de estricto cumplimiento para Clientes y Proveedores:',
      'Cualquier incumplimiento dará lugar a la terminación inmediata del servicio, el bloqueo irreversible de la cuenta y el reporte a las autoridades competentes si se configurare una infracción a la ley ecuatoriana.'
    ],
    bullets: [
      'Tolerancia cero ante cualquier acto de discriminación por motivos de etnia, género, religión, nacionalidad o condición social.',
      'Prohibición total de insultos, agresiones verbales, amenazas, acoso sexual o violencia física.',
      'Prohibición de presentarse bajo la influencia de alcohol o sustancias estupefacientes.',
      'Obligación del Cliente de proveer un entorno seguro para la ejecución de la tarea, alejando mascotas que puedan representar peligro y resguardando objetos de alto valor.',
      'Prohibición absoluta de solicitar a los técnicos labores ilícitas, peligrosas o contrarias a la moral pública.'
    ]
  },
  {
    id: 'garantias-disputas',
    number: '09',
    title: 'Garantía del Trabajo, Reclamos y Deslinde de Responsabilidad',
    badge: 'Garantía',
    highlight: 'Brindamos un canal de mediación activa para proteger la satisfacción del cliente y la reputación del técnico.',
    content: [
      'Período de Revisión: Los servicios técnicos como plomería o electricidad cuentan con un período de revisión de hasta 48 horas tras su culminación para que el Cliente verifique el correcto funcionamiento del trabajo realizado.',
      'Si se presentare una falla directamente atribuible a una incorrecta instalación o mano de obra defectuosa, el Cliente podrá solicitar la revisión a través de la app para que el mismo técnico subsane el inconveniente sin costo adicional de mano de obra.',
      'Límite de Responsabilidad: En la máxima medida permitida por el ordenamiento jurídico de la República del Ecuador, MANACHYNA KUSA no se hace responsable por daños indirectos, lucro cesante o pérdidas derivadas de la negligencia o impericia de los técnicos independientes o de información inexacta provista por los Clientes. No obstante, actuamos activamente como canal de mediación para alcanzar resoluciones justas entre ambas partes.'
    ]
  },
  {
    id: 'calificaciones',
    number: '10',
    title: 'Sistema de Calificaciones, Reseñas y Comentarios',
    badge: 'Comunidad',
    content: [
      'Al finalizar cada servicio, tanto el Cliente como el Proveedor tienen la oportunidad de calificarse mutuamente mediante un sistema de 1 a 5 estrellas y dejar comentarios honestos sobre la experiencia vivida.',
      'Las calificaciones fomentan la excelencia y permiten a otros vecinos de Napo tomar decisiones informadas. Queda prohibido publicar comentarios difamatorios, lenguaje soez o concertar reseñas ficticias con el propósito de alterar artificialmente las métricas de la plataforma.',
      'MANACHYNA KUSA se reserva el derecho de auditar, moderar y eliminar comentarios que vulneren estas normas, así como desactivar proveedores que mantengan promedios inferiores a 3.8 estrellas de forma sostenida.'
    ]
  },
  {
    id: 'propiedad-intelectual',
    number: '11',
    title: 'Propiedad Intelectual y Licencia de Software',
    badge: 'Legal',
    content: [
      'Todo el contenido de la plataforma, incluyendo de manera enunciativa pero no limitativa: el nombre comercial MANACHYNA KUSA, logotipos, marcas, código fuente, código objeto, arquitectura de software, bases de datos, diseños gráficos, interfaces de usuario y textos, son de propiedad exclusiva de MANACHYNA KUSA o de sus desarrolladores legítimos, estando protegidos por la Ley de Propiedad Intelectual del Ecuador y convenios internacionales.',
      'Se concede al Usuario una licencia personal, revocable, no exclusiva, limitada e intransferible para descargar y utilizar la aplicación móvil en su dispositivo personal con el único propósito de acceder a los servicios.',
      'Queda estrictamente prohibida la reproducción, modificación, descompilación, ingeniería inversa, extracción masiva de datos (web scraping) o explotación comercial no autorizada del software.'
    ]
  },
  {
    id: 'terminacion',
    number: '12',
    title: 'Suspensión, Terminación y Cierre de Cuenta',
    badge: 'Baja del Servicio',
    content: [
      'El Usuario puede dar de baja su cuenta en cualquier momento solicitándolo directamente desde el menú de la aplicación móvil o escribiendo a los canales oficiales de contacto.',
      'MANACHYNA KUSA se reserva la facultad de suspender temporalmente o cancelar de manera definitiva el acceso a cualquier cuenta sin previo aviso si se constata el incumplimiento de estos Términos, conductas fraudulentas, reclamos reiterados de usuarios o actos que pongan en riesgo la seguridad de la comunidad.'
    ]
  },
  {
    id: 'legislacion',
    number: '13',
    title: 'Legislación Aplicable y Jurisdicción',
    badge: 'Ecuador',
    content: [
      'Estos Términos y Condiciones se rigen e interpretan en su totalidad bajo las leyes vigentes de la República del Ecuador.',
      'Para la resolución de cualquier controversia o desacuerdo derivado de la interpretación, cumplimiento o validez de este acuerdo que no pueda ser resuelto de mutuo acuerdo entre las partes, estas renuncian expresamente a cualquier otro fuero que pudiera corresponderles y se someten a los jueces y tribunales competentes de la ciudad de Tena, provincia de Napo.'
    ]
  },
  {
    id: 'contacto-legal',
    number: '14',
    title: 'Canales Oficiales de Soporte y Notificaciones',
    badge: 'Atención al Cliente',
    content: [
      'Para presentar solicitudes, sugerencias, reclamos formales o notificaciones legales, puede comunicarse con nosotros a través de los siguientes canales oficiales:'
    ],
    bullets: [
      'Correo electrónico institucional: willian.cerda@est.itstena.edu.ec',
      'Plataforma oficial: https://manachynakusa.duckdns.org',
      'Ubicación física: Tena, Provincia de Napo, República del Ecuador'
    ]
  }
];
