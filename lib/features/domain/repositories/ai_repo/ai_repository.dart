import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';

abstract class AIRepository{
  Future<bool> sendMessageInAIChat({
    required String messageText,
  });
  Stream<List<MessageModel>>? getAllAIChatMessages();
  Future<bool> deleteMessage({
    required String messageId,
  });
  Future<bool> clearChat();
}