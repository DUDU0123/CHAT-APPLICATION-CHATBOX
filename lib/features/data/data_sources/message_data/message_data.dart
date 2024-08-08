import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';

// if (userId==currentUserId) {
//   continue;
// }
class MessageData {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  MessageData({
    required this.firestore,
    required this.firebaseAuth,
  });
  // this method is for sending message to a group chat
  Future<bool> sendMessageToAGroup({
    required groupID,
    required MessageModel message,
    // required String userID,
  }) async {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      if (currentUserId == null) {
        return false;
      }
      GroupModel? groupData = await CommonDBFunctions.getGroupDetailsByGroupID(
        userID: currentUserId,
        groupID: groupID,
      );
      if (groupData == null) {
        return false;
      }
      if (groupData.groupMembers == null) {
        return false;
      }
      if (groupData.groupMembers!.isEmpty) {
        return false;
      }
      final groupMessageDocumentReference = firestore
          .collection(groupsCollection)
          .doc(groupID)
          .collection(messagesCollection)
          .doc();
      final String messageId = groupMessageDocumentReference.id;
      MessageModel updatedMessageModel = message.copyWith(
        messageId: messageId,
      );
      WriteBatch batch = firestore.batch();
      batch.set(groupMessageDocumentReference, updatedMessageModel.toJson());
      for (var userId in groupData.groupMembers!) {
        final newDocReference = firestore
            .collection(usersCollection)
            .doc(userId)
            .collection(groupsCollection)
            .doc(groupID)
            .collection(messagesCollection)
            .doc(messageId);
        batch.set(newDocReference, updatedMessageModel.toJson());
      }
      await batch.commit();
      return true;
    } on FirebaseException catch (e) {
      log("From group send message ${e.message}");
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Stream<List<MessageModel>>? getAllMessageOfAGroupChat(
      {required String groupID}) {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      if (currentUserId == null) {
        log("Current user id null from getAllMessageOfAGroupChat");
        return null;
      }
      return firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(groupsCollection)
          .doc(groupID)
          .collection(messagesCollection)
          .orderBy(dbMessageSendTime, descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (messageMap) => MessageModel.fromJson(map: messageMap.data()),
              )
              .toList());
    } on FirebaseException catch (e) {
      log("Get all group message: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("Current user id null from getAllMessageOfAGroupChat");
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> sendMessageToAChat({
    required String? chatId,
    required MessageModel message,
    required String receiverId,
    required String receiverContactName,
  }) async {
    try {
      final String? currentUserId = firebaseAuth.currentUser?.uid;
      if (currentUserId == null) {
        return;
      }
      if (message.senderID == message.receiverID) {
        await firestore
            .collection(usersCollection)
            .doc(message.senderID)
            .collection(chatsCollection)
            .doc(chatId)
            .collection(messagesCollection)
            .doc(message.messageId)
            .set(message.toJson());
      } else {
        await firestore
            .collection(usersCollection)
            .doc(message.senderID)
            .collection(chatsCollection)
            .doc(chatId)
            .collection(messagesCollection)
            .doc(message.messageId)
            .set(message.toJson());
        await firestore
            .collection(usersCollection)
            .doc(message.receiverID)
            .collection(chatsCollection)
            .doc(chatId)
            .collection(messagesCollection)
            .doc(message.messageId)
            .set(message.toJson());
      }
    } on FirebaseException catch (e) {
      log("From Chat Data: 241: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  String getMediaFolderByType({required MessageType? messageType}) {
    switch (messageType) {
      case MessageType.photo:
        return photoFolder;
      case MessageType.video:
        return videoFolder;
      case MessageType.audio:
        return audioFolder;
      case MessageType.document:
        return docsFolder;
      default:
        return '';
    }
  }

  Future<String?> sendAssetMessage({
    String? chatID,
    String? groupID,
    MessageType? messageType,
    required File file,
  }) async {
    try {
      if (chatID != null) {
        final assetUrl = await CommonDBFunctions.saveUserFileToDataBaseStorage(
            ref:
                "$mediaAttachmentsFolder/$chatsMediaFolder/$chatID/${messageType == MessageType.audio ? audioFolder : messageType == MessageType.video ? videoFolder : messageType == MessageType.document ? docsFolder : photoFolder}/${DateTime.now()}",
            file: file);
        return assetUrl;
      } else if (groupID != null) {
        final assetUrl = await CommonDBFunctions.saveUserFileToDataBaseStorage(
            ref:
                "$mediaAttachmentsFolder/$groupsMediaFolder/$groupID/${messageType == MessageType.audio ? audioFolder : messageType == MessageType.video ? videoFolder : messageType == MessageType.document ? docsFolder : photoFolder}/${DateTime.now()}",
            file: file);
        return assetUrl;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      log("Photo send error chat data: ${e.message}");
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static void updateChatMessageDataOfUser({
    ChatModel? chatModel,
    GroupModel? groupModel,
    required MessageModel message,
    required bool isGroup,
  }) async {
    if ((chatModel?.senderID == null || chatModel?.receiverID == null) &&
        !isGroup) {
      return;
    }
    if (chatModel == null && !isGroup) {
      return;
    }

    String messageStatus = MessageStatus.none.name;

    // Determine the message type and last message string
    // switch (message.messageType) {
    //   case MessageType.audio:
    //     messageType = 'audio';
    //     lastMessage = '🎧Audio';
    //     break;
    //   case MessageType.contact:
    //     messageType = 'contact';
    //     lastMessage = '📞Contact';
    //     break;
    //   case MessageType.document:
    //     messageType = 'document';
    //     lastMessage = '📄Doc';
    //     break;
    //   case MessageType.photo:
    //     messageType = 'photo';
    //     lastMessage = '📷Photo';
    //     break;
    //   case MessageType.video:
    //     messageType = 'video';
    //     lastMessage = '🎥Video';
    //     break;
    //   case MessageType.location:
    //     messageType = 'location';
    //     lastMessage = '📌Location';
    //     break;
    //   default:
    //     lastMessage = message.message ?? '';
    //     messageType = 'text';
    // }

    // Listen to receiver's network status and chat state
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(chatModel?.receiverID)
        .snapshots()
        .listen((receiverSnapshot) async {
      if (receiverSnapshot.exists) {
        final receiverData = receiverSnapshot.data();
        bool userNetworkStatus = receiverData![userDbNetworkStatus] ?? false;

        bool isChatOpen = await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(chatModel?.receiverID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .get()
            .then((doc) => doc[isUserChatOpen] ?? false);
        log("Is chat open: $isChatOpen");

        // Get the current message status
        String currentMessageStatus = await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(chatModel?.senderID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .collection(messagesCollection)
            .doc(message.messageId)
            .get()
            .then((doc) => doc[dbMessageStatus] ?? MessageStatus.none.name);

        // Only update the status if it's not already 'read'
        if (currentMessageStatus != MessageStatus.read.name) {
          if (userNetworkStatus && isChatOpen) {
            messageStatus = MessageStatus.read.name;
          } else if (userNetworkStatus && !isChatOpen) {
            messageStatus = MessageStatus.delivered.name;
          } else if (!userNetworkStatus) {
            messageStatus = MessageStatus.sent.name;
          }
        } else {
          messageStatus = MessageStatus.read.name;
        }

        // getting the messages collection of sender chat
        final senderMessagesSnapshot = await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(chatModel?.senderID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .collection(messagesCollection)
            .get();
        // getting the messages collection of receiver chat
        final receiverMessagesSnapshot = await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(chatModel?.receiverID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .collection(messagesCollection)
            .get();

        // sender message snapshot editing message status
        if (senderMessagesSnapshot.docs.isNotEmpty) {
          final batch = FirebaseFirestore.instance.batch();

          for (final doc in senderMessagesSnapshot.docs) {
            String currentStatus =
                doc.data()[dbMessageStatus] ?? MessageStatus.none.name;
            if (currentStatus != MessageStatus.read.name) {
              batch.update(doc.reference, {
                dbMessageStatus: messageStatus,
              });
            }
          }

          await batch.commit();
        } else {
          log("No messages to update for sender");
        }
        // receiver message snapshot editing message status
        if (receiverMessagesSnapshot.docs.isNotEmpty) {
          final batch = FirebaseFirestore.instance.batch();

          for (final doc in receiverMessagesSnapshot.docs) {
            String currentStatus =
                doc.data()[dbMessageStatus] ?? MessageStatus.none.name;
            if (currentStatus != MessageStatus.read.name) {
              batch.update(doc.reference, {
                dbMessageStatus: messageStatus,
              });
            }
          }

          await batch.commit();
        } else {
          log("No messages to update for receiver");
        }
        // if (isGroup && groupModel != null) {
        //   if (groupModel.groupMembers != null) {
        //     for (var memberID in groupModel.groupMembers!) {
        //       await FirebaseFirestore.instance
        //           .collection(usersCollection)
        //           .doc(memberID)
        //           .collection(groupsCollection)
        //           .doc(groupModel.groupID)
        //           .update({
        //         dbGroupLastMessageTime: message.messageTime,
        //       });
        //     }
        //   }
        // }
        // // Update sender's chat document
        await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(chatModel?.senderID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .update({
          chatLastMessageTime: message.messageTime,
          // lastChatType: messageType,
          // chatLastMessage: lastMessage,
          // lastChatStatus: messageStatus,
          // isIncoming: message.senderID == chatModel?.receiverID,
        });

        // // Update receiver's chat document
        await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(chatModel?.receiverID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .update({
          chatLastMessageTime: message.messageTime,
          // lastChatType: messageType,
          // chatLastMessage: lastMessage,
          // lastChatStatus: messageStatus,
          // isIncoming: message.senderID != chatModel?.receiverID,
        });

        await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(chatModel?.receiverID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .collection(messagesCollection)
            .doc(message.messageId)
            .update({
          dbMessageStatus: messageStatus,
        });
      } else {
        log("Receiver snapshot does not exist");
      }
    });
  }

  Stream<List<MessageModel>> getAllMessagesFromDB({
    String? chatId,
    GroupModel? groupModel,
    required bool isGroup,
  }) {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      return firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .orderBy(dbMessageSendTime, descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromJson(map: doc.data()))
              .toList());
    } on FirebaseException catch (e) {
      log("From Chat Data: 186: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<MessageModel> getOneMessageFromDB(
      {required String chatId, required String messageId}) async {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      DocumentSnapshot doc = await firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .doc(messageId)
          .get();
      return MessageModel.fromJson(map: doc.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      log("From Chat Data: 208: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> editMessageInAChat({
    GroupModel? groupModel,
    ChatModel? chatModel,
    required String messageId,
    required MessageModel updatedData,
    required bool isGroup,
  }) async {
    try {
      if (chatModel == null && !isGroup) {
        return false;
      }
      if (groupModel == null && isGroup) {
        return false;
      }
      if (!isGroup) {
        log("Inside not is group");
        await firestore
            .collection(usersCollection)
            .doc(chatModel?.senderID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .collection(messagesCollection)
            .doc(messageId)
            .update(updatedData.toJson());
        await firestore
            .collection(usersCollection)
            .doc(chatModel?.receiverID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .collection(messagesCollection)
            .doc(messageId)
            .update(updatedData.toJson());
        return true;
      } else {
        for (var memberID in groupModel!.groupMembers!) {
          await firestore
              .collection(usersCollection)
              .doc(memberID)
              .collection(groupsCollection)
              .doc(groupModel.groupID)
              .collection(messagesCollection)
              .doc(messageId)
              .update(updatedData.toJson());
        }
        return true;
      }
    } on FirebaseException catch (e) {
      log("From edit message: ${e.message}");
      return false;
    } catch (e) {
      log("From edit message catch: $e");
      return false;
    }
  }

  void deleteMessageFilFromStorageForEveryone({
    required String? memberID,
    required bool isGroup,
    ChatModel? chatmodel,
    GroupModel? groupmodel,
    required String messageID,
  }) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> message;
      if (isGroup) {
        message = await firestore
            .collection(usersCollection)
            .doc(memberID)
            .collection(groupsCollection)
            .doc(groupmodel?.groupID)
            .collection(messagesCollection)
            .doc(messageID)
            .get();
      } else {
        message = await firestore
            .collection(usersCollection)
            .doc(memberID)
            .collection(chatsCollection)
            .doc(chatmodel?.chatID)
            .collection(messagesCollection)
            .doc(messageID)
            .get();
      }
      if (!message.exists) {
        log("Message with ID $messageID does not exist.");
        return;
      }

      final data = message.data();
      if (data == null) {
        return;
      }

      log("Message data: $data");

      final messagemodel = MessageModel.fromJson(map: data);

      if (messagemodel.messageType == MessageType.audio ||
          messagemodel.messageType == MessageType.video ||
          messagemodel.messageType == MessageType.photo ||
          messagemodel.messageType == MessageType.document) {
        if (messagemodel.message != null) {
          final mediaReference =
              firebaseStorage.refFromURL(messagemodel.message!);
          await mediaReference.delete();
        }
      }
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  Future<bool> deleteMessageForEveryOne({
    GroupModel? groupModel,
    required String messageID,
    required bool isGroup,
    ChatModel? chatModel,
  }) async {
    if (groupModel == null && isGroup) {
      return false;
    }
    if (chatModel == null && !isGroup) {
      return false;
    }
    try {
      if (isGroup) {
        for (final memberID in groupModel!.groupMembers!) {
          deleteMessageFilFromStorageForEveryone(
              groupmodel: groupModel,
              memberID: memberID,
              isGroup: isGroup,
              messageID: messageID);

          await firestore
              .collection(usersCollection)
              .doc(memberID)
              .collection(groupsCollection)
              .doc(groupModel.groupID)
              .collection(messagesCollection)
              .doc(messageID)
              .delete();
        }
        return true;
      } else {
        final chatMembers = [chatModel?.senderID, chatModel?.receiverID];
        for (var member in chatMembers) {
          deleteMessageFilFromStorageForEveryone(
              chatmodel: chatModel,
              memberID: member,
              isGroup: isGroup,
              messageID: messageID);
        }
        await firestore
            .collection(usersCollection)
            .doc(chatModel?.senderID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .collection(messagesCollection)
            .doc(messageID)
            .delete();
        await firestore
            .collection(usersCollection)
            .doc(chatModel?.receiverID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .collection(messagesCollection)
            .doc(messageID)
            .delete();
        return true;
      }
    } on FirebaseException catch (e) {
      log("delete message for everyone error: ${e.toString()}");
      return false;
    } catch (e) {
      log("delete message for everyone error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteMultipleMessageForParticularUser({
    GroupModel? groupModel,
    ChatModel? chatModel,
    required List<String> messageIdList,
    required bool isGroup,
    required String userID,
  }) async {
    try {
      for (var messageID in messageIdList) {
        String currentUserId = firebaseAuth.currentUser!.uid;
        isGroup
            ? await firestore
                .collection(usersCollection)
                .doc(currentUserId)
                .collection(groupsCollection)
                .doc(groupModel?.groupID)
                .collection(messagesCollection)
                .doc(messageID)
                .delete()
            : await firestore
                .collection(usersCollection)
                .doc(currentUserId)
                .collection(chatsCollection)
                .doc(chatModel?.chatID)
                .collection(messagesCollection)
                .doc(messageID)
                .delete();
      }
      return true;
    } on FirebaseException catch (e) {
      log("Delete multiple message error: ${e.toString()}");
      return false;
    } catch (e) {
      log("Delete multiple message error: ${e.toString()}");
      return false;
    }
  }
}
