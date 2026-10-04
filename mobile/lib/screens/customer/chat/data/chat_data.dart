class MensajeConversation {
  const MensajeConversation({
    required this.id,
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.time,
    required this.avatarSeed,
    this.unreadCount = 0,
    this.isOnline = true,
  });

  final String id;
  final String name;
  final String role;
  final String lastMessage;
  final String time;
  final String avatarSeed;
  final int unreadCount;
  final bool isOnline;
}

class MensajeChatMessage {
  const MensajeChatMessage({
    required this.text,
    required this.time,
    required this.isMe,
    this.imageEmoji,
  });

  final String text;
  final String time;
  final bool isMe;
  final String? imageEmoji;
}

const mensajeMockConversations = [
  MensajeConversation(
    id: 'carlos',
    name: 'Carlos Mena',
    role: 'Plomero',
    lastMessage: 'Hola, claro que sí. Puedo estar mañana a las 9:00 a. m.',
    time: '10:30 AM',
    avatarSeed: 'C',
    unreadCount: 2,
  ),
  MensajeConversation(
    id: 'maria',
    name: 'María López',
    role: 'Electricista',
    lastMessage: 'Perfecto, entonces quedamos para el jueves.',
    time: 'Ayer',
    avatarSeed: 'M',
    unreadCount: 1,
  ),
  MensajeConversation(
    id: 'luis',
    name: 'Luis Paredes',
    role: 'Pintor',
    lastMessage: 'Te envío el presupuesto como lo hablamos.',
    time: 'Martes',
    avatarSeed: 'L',
  ),
  MensajeConversation(
    id: 'ana',
    name: 'Ana Torres',
    role: 'Limpieza',
    lastMessage: 'El servicio ha sido completado exitosamente.',
    time: '20 may',
    avatarSeed: 'A',
  ),
];

const mensajeMockMessages = [
  MensajeChatMessage(
    text: 'Hola Carlos, necesito arreglar una fuga de agua en el baño.',
    time: '10:15 AM',
    isMe: true,
  ),
  MensajeChatMessage(
    text:
        'Hola, claro que sí. ¿Puedes enviarme una foto para ver mejor el problema?',
    time: '10:16 AM',
    isMe: false,
  ),
  MensajeChatMessage(
    text: '',
    time: '10:18 AM',
    isMe: true,
    imageEmoji: '🚰',
  ),
  MensajeChatMessage(
    text:
        'Gracias, ya veo el problema. Puedo estar mañana a las 9:00 a. m. ¿Te parece bien?',
    time: '10:20 AM',
    isMe: false,
  ),
  MensajeChatMessage(
    text: 'Perfecto, mañana a las 9:00 a. m. Entonces. ¡Gracias!',
    time: '10:21 AM',
    isMe: true,
  ),
];
