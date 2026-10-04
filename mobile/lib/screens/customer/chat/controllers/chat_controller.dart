import 'package:flutter/material.dart';
import '../data/chat_data.dart';
import '../../../../core/utils/helpers.dart';

class ChatController extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final List<MensajeChatMessage> _activeMessages = [...mensajeMockMessages];
  MensajeConversation? _selectedConversation;

  List<MensajeChatMessage> get activeMessages => _activeMessages;
  MensajeConversation? get selectedConversation => _selectedConversation;
  
  void openConversation(MensajeConversation conversation) {
    _selectedConversation = conversation;
    notifyListeners();
  }

  void closeConversation() {
    _selectedConversation = null;
    notifyListeners();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    _activeMessages.add(
      MensajeChatMessage(
        text: text,
        time: _formatNow(),
        isMe: true,
      ),
    );
    messageController.clear();
    notifyListeners();
  }

  String _formatNow() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final suffix = now.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $suffix';
  }
  
  void handleCompose(BuildContext context) {
    Helpers.showCustomSnackBar(
      context,
      message: 'Puedes iniciar conversación desde una reserva.',
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
