import 'package:flutter/material.dart';

import '../../core/theme/app_theme_colors.dart';
import '../../core/utils/helpers.dart';
import 'mensajes/mensajes_data.dart';
import 'mensajes/mensajes_widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<MensajeChatMessage> _activeMessages = [
    ...mensajeMockMessages,
  ];
  MensajeConversation? _selectedConversation;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _openConversation(MensajeConversation conversation) {
    setState(() {
      _selectedConversation = conversation;
    });
  }

  void _closeConversation() {
    setState(() {
      _selectedConversation = null;
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _activeMessages.add(
        MensajeChatMessage(
          text: text,
          time: _formatNow(),
          isMe: true,
        ),
      );
    });
    _messageController.clear();
  }

  String _formatNow() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final suffix = now.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedConversation;
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: selected == null
            ? _MensajesListView(
                onOpenConversation: _openConversation,
                onCompose: _handleCompose,
              )
            : _MensajesDetailView(
                conversation: selected,
                messages: _activeMessages,
                controller: _messageController,
                onBack: _closeConversation,
                onSend: _sendMessage,
              ),
      ),
    );
  }

  void _handleCompose() {
    Helpers.showCustomSnackBar(
      context,
      message: 'Puedes iniciar conversación desde una reserva.',
    );
  }
}

class _MensajesListView extends StatelessWidget {
  const _MensajesListView({
    required this.onOpenConversation,
    required this.onCompose,
  });

  final ValueChanged<MensajeConversation> onOpenConversation;
  final VoidCallback onCompose;

  @override
  Widget build(BuildContext context) {
    const conversations = mensajeMockConversations;

    return Stack(
      children: [
        if (conversations.isEmpty)
          MensajesEmptyState(onStart: onCompose)
        else
          ListView(
            padding: const EdgeInsets.fromLTRB(22, 34, 22, 92),
            children: [
              const MensajesHeader(),
              const SizedBox(height: 28),
              for (final conversation in conversations)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: MensajesConversationCard(
                    conversation: conversation,
                    onTap: () => onOpenConversation(conversation),
                  ),
                ),
            ],
          ),
        Positioned(
          right: 22,
          bottom: 20,
          child: MensajesFloatingComposeButton(onTap: onCompose),
        ),
      ],
    );
  }
}

class _MensajesDetailView extends StatelessWidget {
  const _MensajesDetailView({
    required this.conversation,
    required this.messages,
    required this.controller,
    required this.onBack,
    required this.onSend,
  });

  final MensajeConversation conversation;
  final List<MensajeChatMessage> messages;
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MensajesChatHeader(
          conversation: conversation,
          onBack: onBack,
        ),
        const MensajesOnlineLabel(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 16),
            children: [
              for (final message in messages) MensajesBubble(message: message),
            ],
          ),
        ),
        MensajesInputBar(
          controller: controller,
          onSend: onSend,
        ),
      ],
    );
  }
}
