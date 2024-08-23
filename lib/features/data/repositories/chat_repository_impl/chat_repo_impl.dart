import 'package:firebase_auth/firebase_auth.dart';
import 'package:official_chatbox_application/features/data/data_sources/chat_data/chat_data.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/report_model/report_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/chat_repo/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  final ChatData chatData;
  final FirebaseAuth firebaseAuth;
  ChatRepoImpl({
    required this.chatData,
    required this.firebaseAuth,
  });
  @override
  Future<void> createNewChat({
    required String receiverId,
    required String recieverContactName,
  }) async {
    if (firebaseAuth.currentUser != null) {
      final isChatExists = await chatData.checkIfChatExistAlready(
        firebaseAuth.currentUser!.uid,
        receiverId,
      );
      if (!isChatExists) {
        await chatData.createANewChat(
          receiverId: receiverId,
          receiverContactName: recieverContactName,
        );
      } else {
        return;
      }
    }
  }

  @override
  Stream<List<ChatModel>> getAllChats() {
    return chatData.getAllChatsFromDB();
  }

  @override
  void deleteAChat({
    required ChatModel chatModel,
  }) async {
    chatData.deleteOneChat(
      chatModel: chatModel,
    );
  }

  @override
  Future<void> clearChatMethodInOneToOne({required String chatID}) async {
    await chatData.clearChatInOneToOne(chatID: chatID);
  }

  @override
  Future<bool> clearAllChatsInApp() async {
    return await chatData.clearAllChats();
  }

  @override
  Future<bool> updateChatData({required ChatModel chatModel}) async {
    return await chatData.updateChatData(chatModel: chatModel);
  }

  @override
  Future<bool> reportAccount({
    required ReportModel reportModel,
  }) {
    return chatData.reportAccount(
      reportModel: reportModel,
    );
  }
}
