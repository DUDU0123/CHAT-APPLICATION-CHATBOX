import 'dart:io';

import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';

abstract class MessageRepo {
  Stream<List<MessageModel>> getAllMessages({
    String? chatId,
     GroupModel? groupModel,
    required bool isGroup,
  });

  Stream<List<MessageModel>>? getAllMessageOfAGroupChat(
      {required String groupID});

  Future<MessageModel> getOneMessage({
    required String chatId,
    required String messageId,
  });
  Future<void> sendMessage({
    required String? chatId,
    required MessageModel message,
    required String receiverId,
    required String receiverContactName,
  });
  Future<bool> sendMessageToAGroupChat({
    required groupID,
    required MessageModel message,
  });
  Future<String> sendAssetMessage({String? chatID, String? groupID, required File file});

  Future<bool> editMessage({
    GroupModel? groupModel,
    ChatModel? chatModel,
    required String messageId,
    required MessageModel updatedMessage,
    required bool isGroup,
  });
  Future<bool> deleteForEveryOne({
    GroupModel? groupModel,
    required String messageID,
    required bool isGroup,
    ChatModel? chatModel,
  });
  Future<bool> deleteMultipleMessageForOneUser({
    GroupModel? groupModel,
    ChatModel? chatModel,
    required List<String> messageIdList,
    required bool isGroup,
    required String userID,
  });

}