import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';

class ChatData {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatData({
    required this.firestore,
    required this.firebaseAuth,
  });
  // check if chat exists or not
  Future<bool> checkIfChatExistAlready(
      String currentUserId, String contactId) async {
    try {
      String chatId = CommonDBFunctions.generateChatId(
          currentUserId: currentUserId, receiverId: contactId);
      DocumentSnapshot chatSnapshot = await fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .get();
      return chatSnapshot.exists;
    } on FirebaseException catch (e) {
      log("From Chat Data: 47: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  // create a new new chat if it is not exists
  Future<void> createANewChat({
    required String receiverId,
    required String receiverContactName,
  }) async {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      String chatId = CommonDBFunctions.generateChatId(
        currentUserId: currentUserId,
        receiverId: receiverId,
      );

      final Stream<UserModel?> receiverDataStream =
          CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
              userId: receiverId);
      final Stream<UserModel?> currentUserDataStream =
          CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
              userId: currentUserId);
      receiverDataStream.listen((UserModel? data) async {
        if (data != null) {
          ChatModel chat = ChatModel(
            chatID: chatId,
            senderID: currentUserId,
            receiverID: data.id,
            lastMessage: "",
            lastMessageTime: DateTime.now().toString(),
            lastMessageStatus: MessageStatus.none,
            lastMessageType: MessageType.none,
            notificationCount: 0,
            receiverName: receiverContactName,
            receiverProfileImage: data.userProfileImage,
            isMuted: false,
          );

          await firestore
              .collection(usersCollection)
              .doc(currentUserId)
              .collection(chatsCollection)
              .doc(chatId)
              .set(chat.toJson());
        } else {
          throw Exception("User data is null");
        }
      });

      currentUserDataStream.listen((UserModel? data) async {
        if (data != null) {
          ChatModel chat = ChatModel(
            chatID: chatId,
            senderID: receiverId,
            receiverID: currentUserId,
            lastMessage: "",
            lastMessageTime: DateTime.now().toString(),
            lastMessageStatus: MessageStatus.none,
            lastMessageType: MessageType.none,
            notificationCount: 0,
            receiverName: data.userName,
            receiverProfileImage: data.userProfileImage,
            isMuted: false,
          );

          await firestore
              .collection(usersCollection)
              .doc(receiverId)
              .collection(chatsCollection)
              .doc(chatId)
              .set(chat.toJson());
        } else {
          throw Exception("User data is null");
        }
      });
    } on FirebaseException catch (e) {
      log("Firebase Auth exception: ${e.message}");
      throw Exception("Error while creating chat: ${e.message}");
    } catch (e, stackTrace) {
      log("Error while creating chat: $e", stackTrace: stackTrace);
      throw Exception("Error while creating chat: $e");
    }
  }

  // read all chat doc of a particular user
  Stream<List<ChatModel>> getAllChatsFromDB() {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      return firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .orderBy(chatLastMessageTime, descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data()))
              .toList());
    } on FirebaseException catch (e) {
      log("From Chat Data: 107: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("Status error: ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // method for deleting a chat
  void deleteOneChat({required ChatModel chatModel}) async {
    try {
      await CommonDBFunctions.deleteAllMessagesOfAChatInDB(
          chatModel: chatModel);
      await firestore
          .collection(usersCollection)
          .doc(chatModel.senderID)
          .collection(chatsCollection)
          .doc(chatModel.chatID)
          .delete();
    } on FirebaseException catch (e) {
      log("From Chat Data: 220: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> clearChatInOneToOne({required String chatID}) async {
    try {
      final User? currentUser = firebaseAuth.currentUser;
      final messageCollectionSnapshot = await firestore
          .collection(usersCollection)
          .doc(currentUser?.uid)
          .collection(chatsCollection)
          .doc(chatID)
          .collection(messagesCollection)
          .get();
      final WriteBatch batch = firestore.batch();
      for (final DocumentSnapshot messageDoc
          in messageCollectionSnapshot.docs) {
        batch.delete(messageDoc.reference);
      }

      // Commit the batch
      await batch.commit();
    } on FirebaseException catch (e) {
      log("From new group creation firebase: ${e.toString()}");
    } catch (e) {
      log("From new group creation catch: ${e.toString()}");
    }
  }

  Future<bool> clearAllChats() async {
    try {
      final User? currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return false;
      }
      final WriteBatch batch = firestore.batch();
      final chatSnaphot = await firestore
          .collection(usersCollection)
          .doc(currentUser.uid)
          .collection(chatsCollection)
          .get();
      for (var chatDoc in chatSnaphot.docs) {
        final chatDocRef = chatDoc.reference;
        final messageSnapShot =
            await chatDocRef.collection(messagesCollection).get();
        for (var messageDoc in messageSnapShot.docs) {
          batch.delete(messageDoc.reference);
        }
      }
      final groupSnapShot = await firestore
          .collection(usersCollection)
          .doc(currentUser.uid)
          .collection(groupsCollection)
          .get();
      for (var groupDoc in groupSnapShot.docs) {
        final groupDocRef = groupDoc.reference;
        final messageSnapShot =
            await groupDocRef.collection(messagesCollection).get();
        for (var messageDoc in messageSnapShot.docs) {
          batch.delete(messageDoc.reference);
        }
      }
      await batch.commit();
      return true;
    } on FirebaseException catch (e) {
      log("From new group creation firebase: ${e.toString()}");
      return false;
    } catch (e) {
      log("From new group creation catch: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateChatData({required ChatModel chatModel}) async {
    try {
      final User? currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return false;
      }
      await fireStore
          .collection(usersCollection)
          .doc(currentUser.uid)
          .collection(chatsCollection)
          .doc(chatModel.chatID)
          .update(
            chatModel.toJson(),
          );
      return true;
    } on FirebaseException catch (e) {
      log("From mute chat firebase: ${e.toString()}");
      return false;
    } catch (e) {
      log("From mute chat catch: ${e.toString()}");
      return false;
    }
  }
}
