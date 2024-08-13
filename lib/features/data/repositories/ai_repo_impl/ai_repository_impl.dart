import 'package:official_chatbox_application/features/data/data_sources/ai_data/ai_data.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/ai_repo/ai_repository.dart';

class AIRepositoryImpl extends AIRepository {
  final AIData aiData;
  AIRepositoryImpl({
    required this.aiData,
  });
  @override
  Future<bool> sendMessageInAIChat({required String messageText}) {
    return aiData.sendMessageInAIChat(messageText: messageText);
  }

  @override
  Stream<List<MessageModel>>? getAllAIChatMessages() {
    return aiData.getAllAIChatMessages();
  }
  
  @override
  Future<bool> deleteMessage({required String messageId}) {
    return aiData.deleteMessage(messageId: messageId);
  }
  
  @override
  Future<bool> clearChat() async{
    return aiData.clearChat();
  }
}
