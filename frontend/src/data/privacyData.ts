import type { LegalSection } from './termsData';

export const PRIVACY_SECTIONS: LegalSection[] = [
  {
    id: 'responsable',
    number: '01',
    title: 'Responsable del Tratamiento de Datos Personales',
    badge: 'LOPDP Ecuador',
    highlight: 'Comprometidos con el respeto a la privacidad y la protección de datos conforme a la legislación ecuatoriana.',
    content: [
      'MANACHYNA KUSA, con domicilio en la ciudad de Tena, provincia de Napo, República del Ecuador, actúa como responsable del tratamiento de los datos personales recopilados a través de la aplicación móvil y la plataforma web oficial.',
      'Dando estricto cumplimiento a la Ley Orgánica de Protección de Datos Personales (LOPDP) de la República del Ecuador, publicada en el Registro Oficial Suplemento 459 el 26 de mayo de 2021, garantizamos el tratamiento lícito, leal, transparente y seguro de la información de todos nuestros usuarios.',
      'Para cualquier consulta relativa a la protección de datos, nuestro delegado puede ser contactado directamente en willian.cerda@est.itstena.edu.ec.'
    ],
    callout: {
      type: 'important',
      title: 'Consentimiento Informado',
      text: 'Al registrarse y utilizar MANACHYNA KUSA, usted otorga su consentimiento previo, expreso e informado para el tratamiento de sus datos conforme a los propósitos descritos en este documento.'
    }
  },
  {
    id: 'datos-recopilados',
    number: '02',
    title: 'Datos Personales que Recopilamos',
    badge: 'Minimización de Datos',
    content: [
      'Únicamente recolectamos la información estrictamente necesaria y proporcional para garantizar la correcta prestación, coordinación y seguridad de los servicios solicitados:',
      'Datos de Proveedores / Técnicos: Para garantizar la seguridad de los hogares en Napo, a los proveedores se les solicita adicionalmente su número de cédula de ciudadanía ecuatoriana, certificado de antecedentes penales actualizado, certificados laborales y datos de cobro/bancarios.'
    ],
    bullets: [
      'Datos de Identidad y Contacto: Nombre completo, dirección de correo electrónico, número de teléfono celular y fotografía de perfil (suministrada voluntariamente o importada mediante Google/Microsoft OAuth).',
      'Datos de Geolocalización Precisa (GPS): Coordenadas geográficas en tiempo real cuando solicita o atiende un servicio.',
      'Datos del Servicio y Transacciones: Historial de solicitudes de servicio, categoría contratada, fecha y hora, descripción de la labor, dirección física de la intervención, valor acordado y método de pago utilizado.',
      'Datos Técnicos y del Dispositivo: Dirección IP, modelo de dispositivo móvil, versión de sistema operativo (Android / iOS), identificador único de instalación y token de notificaciones Firebase Cloud Messaging (FCM).',
      'Comentarios y Calificaciones: Puntuaciones de 1 a 5 estrellas y opiniones redactadas al culminar un servicio.'
    ]
  },
  {
    id: 'geolocalizacion-permisos',
    number: '03',
    title: 'Geolocalización en Tiempo Real y Permisos Sensibles',
    badge: 'Permisos Móviles',
    highlight: 'La ubicación por GPS solo se utiliza para calcular distancias, rutas de llegada y encontrar técnicos cercanos en Napo.',
    content: [
      'Permiso de Ubicación Precisa (ACCESS_FINE_LOCATION): La aplicación móvil requiere acceso a la ubicación de su dispositivo en primer plano cuando usted crea una solicitud de servicio o cuando un técnico navega hacia el domicilio.',
      'Finalidad de la Ubicación: Este permiso es imprescindible para mostrarle en el mapa interactivo los especialistas disponibles en Tena, Archidona o cantones cercanos, calcular la distancia de viaje estimada y verificar la llegada del técnico al lugar correcto.',
      'Control del Usuario: Usted puede habilitar, deshabilitar o restringir el acceso a la ubicación en cualquier momento desde los ajustes de privacidad de su teléfono móvil. No obstante, desactivar la geolocalización impedirá ubicar automáticamente su domicilio al solicitar un servicio a domicilio.'
    ],
    bullets: [
      'No rastreamos su ubicación cuando la aplicación se encuentra totalmente cerrada y sin órdenes activas en curso.',
      'Las coordenadas solo se comparten con el técnico que ha aceptado formalmente su orden de trabajo.',
      'No comercializamos ni compartimos datos de ubicación con redes publicitarias ni intermediarios de datos.'
    ]
  },
  {
    id: 'finalidad-tratamiento',
    number: '04',
    title: 'Finalidades del Tratamiento de los Datos',
    badge: 'Uso Legítimo',
    content: [
      'Los datos personales recopilados se tratan de conformidad con las siguientes finalidades legítimas:',
      'No utilizaremos sus datos personales para finalidades distintas a las informadas sin solicitar previamente su consentimiento expreso.'
    ],
    bullets: [
      'Conectar eficientemente a Clientes y Proveedores mediante emparejamiento geográfico inteligente en la provincia de Napo.',
      'Coordinar el despacho, ejecución y verificación de los trabajos técnicos y domésticos contratados.',
      'Enviar notificaciones push operativas en tiempo real (ej. "El técnico ha aceptado su orden", "El técnico ha llegado", "Servicio completado").',
      'Verificar la identidad y antecedentes de los especialistas para prevenir fraudes, delitos y resguardar la seguridad de los domicilios.',
      'Gestionar el soporte técnico al usuario, atención de consultas, reclamos y mediación en controversias.',
      'Cumplir con requerimientos fiscales, tributarios (SRI) y judiciales legalmente emitidos por autoridades ecuatorianas.'
    ]
  },
  {
    id: 'seguridad-almacenamiento',
    number: '05',
    title: 'Seguridad de la Información y Arquitectura Cloud',
    badge: 'Alta Seguridad',
    highlight: 'Todos los datos se protegen con cifrado SSL/TLS de grado bancario y políticas de seguridad a nivel de fila (RLS).',
    content: [
      'Infraestructura Supabase: Nuestra base de datos PostgreSQL está alojada en infraestructura de nivel empresarial provista por Supabase Cloud, la cual implementa cifrado en reposo (AES-256) y copias de seguridad continuas.',
      'Row Level Security (RLS): Aplicamos políticas estrictas a nivel de fila en la base de datos que impiden que cualquier usuario o tercero acceda a registros ajenos sin autorización expresa de identidad.',
      'Comunicaciones Cifradas: Todas las transferencias de datos entre la app móvil Flutter, el sitio web React y los servidores en la nube se realizan bajo protocolos criptográficos seguros HTTPS y TLS 1.3 con certificados SSL Let\'s Encrypt.'
    ],
    callout: {
      type: 'info',
      title: 'Manejo de Credenciales',
      text: 'Las contraseñas nunca se guardan en texto plano. Los tokens de sesión JWT se almacenan en el almacenamiento seguro nativo del dispositivo (Android Keystore / iOS Keychain).'
    }
  },
  {
    id: 'comparticion-terceros',
    number: '06',
    title: 'Compartición de Datos con Terceros de Confianza',
    badge: 'Cero Venta de Datos',
    content: [
      'MANACHYNA KUSA no vende, no alquila y no cede sus datos personales a agencias de publicidad o empresas de telemarketing. La información se comparte únicamente en los siguientes supuestos estrictamente controlados:',
      'Todos los proveedores de tecnología contratados por MANACHYNA KUSA están sujetos a cláusulas contractuales de confidencialidad y estándares rigurosos de protección de datos personales.'
    ],
    bullets: [
      'Entre Cliente y Proveedor asignado: Se comparte el nombre, fotografía, teléfono celular de contacto y la dirección del servicio para la correcta ejecución del trabajo.',
      'Supabase Inc.: Proveedor del motor de base de datos PostgreSQL, autenticación y almacenamiento en la nube.',
      'Google Cloud Platform & Firebase: Utilizado para la entrega confiable de notificaciones push móviles mediante Firebase Cloud Messaging (FCM).',
      'Autoridades Públicas Ecuatorianas: Únicamente ante mandamiento judicial fundado y motivado emitido por juez competente o la Fiscalía General del Estado.'
    ]
  },
  {
    id: 'derechos-arco',
    number: '07',
    title: 'Derechos del Titular (Derechos ARCO)',
    badge: 'Tus Derechos',
    highlight: 'Tienes pleno control sobre tu información conforme al Artículo 21 y siguientes de la LOPDP.',
    content: [
      'Como titular de los datos personales, la legislación ecuatoriana le otorga los siguientes derechos fundamentales que puede ejercer en cualquier momento de manera gratuita:',
      'Para ejercer cualquiera de estos derechos, basta con enviar una solicitud formal por escrito al correo willian.cerda@est.itstena.edu.ec adjuntando copia digital de su documento de identidad para verificar su titularidad. Nuestro equipo atenderá su petición en el plazo máximo de quince (15) días hábiles.'
    ],
    bullets: [
      'Derecho de Acceso: Conocer qué datos personales suyos están siendo tratados y las condiciones del tratamiento.',
      'Derecho de Rectificación y Actualización: Solicitar la corrección de datos inexactos, desactualizados o incompletos.',
      'Derecho de Eliminación (Supresión): Exigir la supresión de sus datos cuando hayan dejado de ser necesarios o cuando revoque su consentimiento.',
      'Derecho de Oposición: Oponerse al tratamiento de sus datos por razones legítimas y fundadas.',
      'Derecho de Portabilidad: Obtener una copia de sus datos en un formato digital estructurado, común y legible por máquina.'
    ]
  },
  {
    id: 'eliminacion-cuenta',
    number: '08',
    title: 'Mecanismo de Eliminación de Cuenta y Retención (Google Play)',
    badge: 'Requisito Oficial Google Play',
    highlight: 'Garantizamos un procedimiento sencillo y directo para borrar tu cuenta y toda tu información personal.',
    content: [
      'En estricto cumplimiento de las políticas de datos de Google Play Store y Apple App Store, MANACHYNA KUSA ofrece a todos sus usuarios la posibilidad de eliminar de forma completa y definitiva su cuenta de usuario y los datos asociados.',
      '¿Cómo solicitar la eliminación desde la App Móvil?:',
      'Procedimiento Alternativo Web:',
      'Si no tiene acceso a su dispositivo móvil o desinstaló la aplicación, puede solicitar la baja definitiva de su cuenta enviando un correo a willian.cerda@est.itstena.edu.ec desde la misma dirección asociada a su cuenta, con el asunto "Solicitud de Eliminación de Cuenta y Datos".',
      'Plazos y Efectos del Borrado: Una vez recibida y confirmada la solicitud, la cuenta se desactivará de inmediato y todos los datos personales (perfil, teléfono, coordenadas GPS, historial de sesiones) serán purgados definitivamente de nuestras bases de datos en un plazo no mayor a setenta y dos (72) horas, conservando únicamente aquellos registros transaccionales requeridos por la legislación tributaria ecuatoriana (SRI) durante los plazos legalmente exigibles.'
    ],
    bullets: [
      'Paso 1: Abra la aplicación móvil MANACHYNA KUSA en su teléfono.',
      'Paso 2: Ingrese a la pestaña "Perfil" en la barra de navegación inferior.',
      'Paso 3: Seleccione la opción "Configuración de Cuenta y Privacidad".',
      'Paso 4: Presione el botón "Eliminar mi cuenta y datos personales".',
      'Paso 5: Confirme la acción tras leer la advertencia de consecuencias irreversibles.'
    ],
    callout: {
      type: 'warning',
      title: 'Consecuencias de la Eliminación',
      text: 'La eliminación de cuenta es irreversible. Se perderán las calificaciones acumuladas, el historial de servicios realizados y el acceso a la plataforma con esa cuenta.'
    }
  },
  {
    id: 'cookies-tecnologias',
    number: '09',
    title: 'Cookies y Tecnologías de Almacenamiento Local',
    badge: 'Navegación Web',
    content: [
      'En la plataforma web utilizamos almacenamiento local (LocalStorage / SessionStorage) y cookies técnicas estrictamente necesarias para mantener la sesión de usuario activa y recordar las preferencias de navegación.',
      'No utilizamos cookies de seguimiento publicitario invasivo ni cookies de terceros para rastrear su actividad fuera de nuestro dominio oficial manachynakusa.duckdns.org.'
    ]
  },
  {
    id: 'menores',
    number: '10',
    title: 'Privacidad de Menores de Edad',
    badge: 'Protección Infantil',
    content: [
      'Nuestra plataforma y aplicación móvil no están dirigidas ni diseñadas para ser utilizadas por personas menores de dieciocho (18) años. No recopilamos conscientemente datos de menores de edad.',
      'Si un padre, madre o tutor legal toma conocimiento de que un menor bajo su tutela ha suministrado datos personales a MANACHYNA KUSA sin su debido consentimiento, le solicitamos contactarnos de inmediato para proceder a la eliminación inmediata de dicha información de nuestros servidores.'
    ]
  },
  {
    id: 'cambios-politica',
    number: '11',
    title: 'Modificaciones y Actualizaciones a esta Política',
    badge: 'Vigencia',
    content: [
      'Nos reservamos el derecho de actualizar o modificar la presente Política de Privacidad periódicamente para reflejar cambios en nuestras prácticas operativas, mejoras tecnológicas o actualizaciones en el marco legal ecuatoriano.',
      'Cuando se efectúen cambios sustanciales, se notificará oportunamente a los usuarios mediante un aviso destacado en la aplicación móvil o a través de la dirección de correo electrónico registrada.',
      'Le recomendamos revisar esta página periódicamente. El uso continuo de la plataforma tras la publicación de los cambios constituirá su aceptación de las condiciones actualizadas.'
    ]
  },
  {
    id: 'contacto-privacidad',
    number: '12',
    title: 'Canales de Atención para Privacidad y Reclamos',
    badge: 'Atención Directa',
    content: [
      'Para ejercer sus derechos ARCO, realizar consultas, presentar reclamos o denunciar cualquier vulneración a su privacidad, puede dirigirse a:'
    ],
    bullets: [
      'Responsable de Privacidad: Willian Cerda · MANACHYNA KUSA',
      'Correo Oficial: willian.cerda@est.itstena.edu.ec',
      'Portal Web Oficial: https://manachynakusa.duckdns.org/privacy',
      'Ubicación: Tena, Provincia de Napo, República del Ecuador'
    ]
  }
];
