import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../controllers/chat_controller.dart';
import '../data/chat_data.dart';
import 'widgets/chat_widgets.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController(),
      child: const _ChatTabContent(),
    );
  }
}

class _ChatTabContent extends StatelessWidget {
  const _ChatTabContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    final selected = controller.selectedConversation;

    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: selected == null
            ? _MensajesListView(
                onOpenConversation: controller.openConversation,
                onCompose: () => controller.handleCompose(context),
              )
            : _MensajesDetailView(
                conversation: selected,
                messages: controller.activeMessages,
                messageController: controller.messageController,
                onBack: controller.closeConversation,
                onSend: controller.sendMessage,
              ),
      ),
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
    required this.messageController,
    required this.onBack,
    required this.onSend,
  });

  final MensajeConversation conversation;
  final List<MensajeChatMessage> messages;
  final TextEditingController messageController;
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
          controller: messageController,
          onSend: onSend,
        ),
      ],
    );
  }
}
