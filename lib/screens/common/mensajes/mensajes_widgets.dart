import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme_colors.dart';
import 'mensajes_data.dart';

class MensajesHeader extends StatelessWidget {
  const MensajesHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mensajes',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: context.appTextPrimary,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Conversa con tus proveedores',
          style: TextStyle(
            fontSize: 14,
            color: context.appTextSecondary,
          ),
        ),
      ],
    );
  }
}

class MensajesConversationCard extends StatelessWidget {
  const MensajesConversationCard({
    required this.conversation,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final MensajeConversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.appSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.appBorder),
            boxShadow: context.appCardShadow,
          ),
          child: Row(
            children: [
              MensajesAvatar(
                seed: conversation.avatarSeed,
                isOnline: conversation.isOnline,
                size: 58,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: context.appTextPrimary,
                            ),
                          ),
                        ),
                        Text(
                          conversation.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.appTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.role,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.appTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.35,
                              color: context.appTextSecondary,
                            ),
                          ),
                        ),
                        if (conversation.unreadCount > 0) ...[
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              conversation.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MensajesEmptyState extends StatelessWidget {
  const MensajesEmptyState({
    required this.onStart,
    this.compact = false,
    Key? key,
  }) : super(key: key);

  final VoidCallback onStart;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 34),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            compact
                ? const _LargeChatIllustration()
                : const _SmallChatIllustration(),
            SizedBox(height: compact ? 28 : 34),
            Text(
              compact
                  ? 'No tienes conversaciones todavía'
                  : 'No hay conversaciones',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: context.appTextPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              compact
                  ? 'Tus conversaciones activas aparecerán aquí.'
                  : 'Inicia una conversación\ndesde una reserva.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: context.appTextSecondary,
              ),
            ),
            if (compact) ...[
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: const Text('Iniciar una conversación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MensajesFloatingComposeButton extends StatelessWidget {
  const MensajesFloatingComposeButton({required this.onTap, Key? key})
      : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 8,
      child: const Icon(Icons.edit_square, size: 26),
    );
  }
}

class MensajesChatHeader extends StatelessWidget {
  const MensajesChatHeader({
    required this.conversation,
    required this.onBack,
    Key? key,
  }) : super(key: key);

  final MensajeConversation conversation;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 18, 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        border: Border(
          bottom: BorderSide(color: context.appBorder),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          MensajesAvatar(
            seed: conversation.avatarSeed,
            isOnline: conversation.isOnline,
            size: 46,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  conversation.role,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
    );
  }
}

class MensajesOnlineLabel extends StatelessWidget {
  const MensajesOnlineLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 6),
      child: Row(
        children: [
          const CircleAvatar(radius: 5, backgroundColor: Color(0xFFD5F0D5)),
          const SizedBox(width: 8),
          Text(
            'En línea',
            style: TextStyle(
              fontSize: 12,
              color: context.appTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class MensajesBubble extends StatelessWidget {
  const MensajesBubble({required this.message, Key? key}) : super(key: key);

  final MensajeChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = message.isMe ? context.appSoftGreen : context.appSurface;
    final radius = message.isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(4),
          );

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.only(bottom: 14),
        padding: message.imageEmoji == null
            ? const EdgeInsets.fromLTRB(14, 12, 12, 8)
            : const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: radius,
          boxShadow: context.appCardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.imageEmoji != null)
              Container(
                width: 210,
                height: 112,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.appMutedSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message.imageEmoji!,
                  style: const TextStyle(fontSize: 62),
                ),
              )
            else
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: context.appTextPrimary,
                ),
              ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: context.appTextSecondary,
                  ),
                ),
                if (message.isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all_rounded,
                    size: 13,
                    color: AppColors.primary,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MensajesInputBar extends StatelessWidget {
  const MensajesInputBar({
    required this.controller,
    required this.onSend,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        border: Border(top: BorderSide(color: context.appBorder)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file_rounded),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                hintStyle: TextStyle(color: context.appTextSecondary),
                filled: true,
                fillColor: context.appMutedSurface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: context.appBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: context.appBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: IconButton(
              onPressed: onSend,
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MensajesAvatar extends StatelessWidget {
  const MensajesAvatar({
    required this.seed,
    required this.isOnline,
    required this.size,
    Key? key,
  }) : super(key: key);

  final String seed;
  final bool isOnline;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: _avatarGradient(seed),
              shape: BoxShape.circle,
            ),
            child: Text(
              seed,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.36,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (isOnline)
            Positioned(
              right: 1,
              bottom: 2,
              child: Container(
                width: size * 0.22,
                height: size * 0.22,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  LinearGradient _avatarGradient(String seed) {
    switch (seed) {
      case 'M':
      case 'A':
        return const LinearGradient(
          colors: [Color(0xFFB96A5C), Color(0xFF263F31)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'L':
        return const LinearGradient(
          colors: [Color(0xFF2F5B73), Color(0xFF142B38)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF23634E), Color(0xFF0D2B22)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}

class _SmallChatIllustration extends StatelessWidget {
  const _SmallChatIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 76,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2E2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 4, backgroundColor: Color(0xFF78A778)),
              SizedBox(width: 12),
              CircleAvatar(radius: 4, backgroundColor: Color(0xFF78A778)),
              SizedBox(width: 12),
              CircleAvatar(radius: 4, backgroundColor: Color(0xFF78A778)),
            ],
          ),
          Positioned(
            left: 16,
            bottom: -10,
            child: CustomPaint(
              size: Size(18, 18),
              painter: _BubbleTailPainter(color: Color(0xFFE3F2E2)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeChatIllustration extends StatelessWidget {
  const _LargeChatIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: const BoxDecoration(
              color: Color(0xFFE7F4E5),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: 18,
            left: 40,
            child: _MiniBubble(
              color: AppColors.primary.withValues(alpha: 0.70),
              lines: 2,
              hasDrop: true,
            ),
          ),
          const Positioned(
            bottom: 26,
            left: 44,
            child: _MiniBubble(
              color: Color(0xFFE6F4E4),
              lines: 3,
              hasDrop: false,
            ),
          ),
          Positioned(
            right: 34,
            bottom: 28,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: const Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const Positioned(
            top: 20,
            right: 38,
            child: Icon(Icons.auto_awesome, color: Color(0xFFC5DFC3), size: 24),
          ),
          const Positioned(
            left: 22,
            top: 45,
            child: Icon(Icons.auto_awesome, color: Color(0xFFC5DFC3), size: 20),
          ),
          const Positioned(
            right: 14,
            top: 55,
            child: Icon(Icons.auto_awesome, color: Color(0xFFC5DFC3), size: 28),
          ),
        ],
      ),
    );
  }
}

class _MiniBubble extends StatelessWidget {
  const _MiniBubble({
    required this.color,
    required this.lines,
    required this.hasDrop,
  });

  final Color color;
  final int lines;
  final bool hasDrop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 56,
      padding: const EdgeInsets.fromLTRB(18, 14, 14, 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDrop)
            const Icon(Icons.water_drop, size: 12, color: Colors.white),
          for (var index = 0; index < lines; index++) ...[
            if (index > 0 || hasDrop) const SizedBox(height: 6),
            Container(
              width: index == lines - 1 ? 42 : 58,
              height: 5,
              decoration: BoxDecoration(
                color: hasDrop
                    ? Colors.white.withValues(alpha: 0.8)
                    : AppColors.primary.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  const _BubbleTailPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
