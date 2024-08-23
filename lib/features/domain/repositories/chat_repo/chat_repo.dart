import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/report_model/report_model.dart';

abstract class ChatRepo {
  Future<void> createNewChat({
    required String receiverId,
    required String recieverContactName,
  });
  Stream<List<ChatModel>> getAllChats();
  void deleteAChat({required ChatModel chatModel});
  Future<void> clearChatMethodInOneToOne({required String chatID});
  Future<bool> clearAllChatsInApp();
  Future<bool> updateChatData({required ChatModel chatModel});
  Future<bool> reportAccount({
    required ReportModel reportModel,
  });
}
