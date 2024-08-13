import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';

class CommonDBFunctions {
  static Future<String> saveUserFileToDataBaseStorage({
    required String ref,
    required File file,
  }) async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while saving file to storage: $e");
    } catch (e, stackTrace) {
      log('Error while saving file to storage: $e', stackTrace: stackTrace);
      throw Exception("Error while saving file to storage: $e");
    }
  }

  static Future<MessageModel?> getOneMessageByItsId({
    required String messageID,
    ChatModel? chatModel,
    GroupModel? groupModel,
    required bool isGroup,
  }) async {
    try {
      final messageMapDoc = !isGroup
          ? await fireStore
              .collection(usersCollection)
              .doc(firebaseAuth.currentUser?.uid)
              .collection(chatsCollection)
              .doc(chatModel?.chatID)
              .collection(messagesCollection)
              .doc(messageID)
              .get()
          : await fireStore
              .collection(usersCollection)
              .doc(firebaseAuth.currentUser?.uid)
              .collection(groupsCollection)
              .doc(groupModel?.groupID)
              .collection(messagesCollection)
              .doc(messageID)
              .get();
      if (messageMapDoc.exists) {
        return MessageModel.fromJson(map: messageMapDoc.data()!);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching message data: $e");
    } catch (e, stackTrace) {
      log('Error while fetching message data: $e', stackTrace: stackTrace);
      throw Exception("Error while fetching message data: $e");
    }
  }

  //get one user data as future
  static Future<UserModel?> getOneUserDataFromDBFuture(
      {required String? userId}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await fireStore.collection(usersCollection).doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromJson(map: documentSnapshot.data()!);
      } else {
        log('User not found with ID: $userId');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching user data: $e");
    } catch (e, stackTrace) {
      log('Error while fetching user data: $e', stackTrace: stackTrace);
      throw Exception("Error while fetching user data: $e");
    }
  }

  //get one user data as stream
  static Stream<UserModel?> getOneUserDataFromDataBaseAsStream(
      {required String userId}) {
    try {
      return fireStore.collection(usersCollection).doc(userId).snapshots().map(
            (event) => UserModel.fromJson(
              map: event.data() ?? {},
            ),
          );
    } on FirebaseException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching user data: $e");
    } catch (e, stackTrace) {
      log('Error while fetching user data: $e', stackTrace: stackTrace);
      throw Exception("Error while fetching user data: $e");
    }
  }

  // get one group as future
  static Future<GroupModel?> getGroupDetailsByGroupID({
    required String userID,
    required String groupID,
  }) async {
    final groupDoc = await fireStore
        .collection(usersCollection)
        .doc(userID)
        .collection(groupsCollection)
        .doc(groupID)
        .get();

    if (groupDoc.exists) {
      return GroupModel.fromJson(map: groupDoc.data()!);
    } else {
      return null;
    }
  }

  static Stream<GroupModel?> getOneGroupDataByStream({
    required String userID,
    required String groupID,
  }) {
    try {
      return fireStore
          .collection(usersCollection)
          .doc(userID)
          .collection(groupsCollection)
          .doc(groupID)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return GroupModel.fromJson(map: snapshot.data()!);
        } else {
          return null;
        }
      });
    } on FirebaseException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching user data: $e");
    } catch (e, stackTrace) {
      log('Error while fetching user data: $e', stackTrace: stackTrace);
      throw Exception("Error while fetching user data: $e");
    }
  }

  static updateUserNetworkStatusInApp({required bool isOnline}) async {
    await fireStore
        .collection(usersCollection)
        .doc(firebaseAuth.currentUser?.uid)
        .update({
      userDbLastActiveTime: DateTime.now().millisecondsSinceEpoch.toString(),
      userDbNetworkStatus: isOnline,
    });
  }

  // Method to generate a chat ID by combining the IDs of receiver and sender
  static String generateChatId(
      {required String currentUserId, required String receiverId}) {
    try {
      List<String> uids = [currentUserId, receiverId];
      uids.sort();
      String chatID = uids.fold("", (id, uid) => "$id$uid");
      return chatID;
    } catch (e) {
      log(name: "Chat Id generate error: ", e.toString());
      throw Exception(e.toString());
    }
  }

  // get all messages of a one to one chat as stream
  static Stream<MessageModel> getMessageStreamChatsCollection(
      String chatID, String messageID) {
    return fireStore
        .collection(chatsCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .doc(messageID)
        .snapshots()
        .map(
          (event) => MessageModel.fromJson(
            map: event.data() ?? {},
          ),
        );
  }

  // this method will update isChatOpen parameter when user open one chat and close it
  static void updateChatOpenStatus(String userId, String chatId, bool isOpen) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .update({'isChatOpen': isOpen});
  }

  // listen to a chat doc
  static void listenToChatDocument(String userId, String chatId) {
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(userId)
        .collection(chatsCollection)
        .doc(chatId)
        .snapshots()
        .listen((DocumentSnapshot docSnapshot) {
      if (docSnapshot.exists) {
        // Check if the chat is opened
        ChatModel chat =
            ChatModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
        if (chat.isChatOpen ?? false) {
          // Handle the case when the chat is opened
          log(
              name: "Checking chat open or not",
              'Chat is opened by the receiver ${chat.isChatOpen}');
        }
      }
    });
  }

  static Future<void> deleteAllMessagesOfAChatInDB(
      {required ChatModel? chatModel}) async {
    try {
      final QuerySnapshot messageDocs = await fireStore
          .collection(usersCollection)
          .doc(chatModel?.senderID)
          .collection(chatsCollection)
          .doc(chatModel?.chatID)
          .collection(messagesCollection)
          .get();

      for (var messageDoc in messageDocs.docs) {
        await messageDoc.reference.delete();
      }
    } on FirebaseException catch (e) {
      log(
        'Firebase exception deleteAllMessagesInDB: $e',
      );
      throw Exception("Error while deleteAllMessagesInDB: $e");
    } catch (e, stackTrace) {
      log('Error while deleteAllMessagesInDB : $e', stackTrace: stackTrace);
      throw Exception("Error while deleteAllMessagesInDB: $e");
    }
  }

  // method to get/read all status
  static Stream<StatusModel?>? getCurrentUserStatus() {
    final currentUser = firebaseAuth.currentUser?.uid;
    try {
      if (currentUser == null) {
        log("No current user found.");
        return Stream.value(null);
      }
      return fireStore
          .collection(usersCollection)
          .doc(currentUser)
          .collection(statusCollection)
          .orderBy('timestamp',
              descending:
                  true) // Ensure you have a 'timestamp' field in each status document
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // log("Fetched status data: ${snapshot.docs.first.data()}");
          return StatusModel.fromJson(map: snapshot.docs.first.data());
        }
        return null;
      });
    } on FirebaseException catch (e) {
      log("Firebase Auth exception on upload status: ${e.message}");
      return null;
    } catch (e, stackTrace) {
      log("Error while uploading status: $e", stackTrace: stackTrace);
      return null;
    }
  }
  static Future<void> updateStatusListInStatusModelInDB({required String? userId,}) async {
    try {
         final currentUser = firebaseAuth.currentUser?.uid;
        final now = DateTime.now();
        final cutoffTime = now.subtract(const Duration(hours: 24));

        if (currentUser == null) {
          debugPrint("No current user found.");
          return;
        }
        final statusCollectionSnap = await fireStore
            .collection(usersCollection)
            .doc(userId)
            .collection(statusCollection)
            .get();
        if (statusCollectionSnap.docs.isEmpty) {
        debugPrint("No statuses found for the current user.");
        return;
      }

        final StatusModel statusModel =
            StatusModel.fromJson(map: statusCollectionSnap.docs.first.data());
        if (statusModel.statusList == null) {
          debugPrint("No statuses in the status list.");
          return;
        }
        final updatedStatusList = statusModel.statusList?.where((uploadedStatus) {
          final statusTime = DateTime.parse(uploadedStatus.statusUploadedTime!);
          return statusTime.isAfter(cutoffTime);
        });
        await fireStore
            .collection(usersCollection)
            .doc(currentUser)
            .collection(statusCollection)
            .doc(statusModel.statusId)
            .update({
          dbStatusContentList:
              updatedStatusList?.map((status) => status.toJson()).toList(),
        });
      // final now = DateTime.now();
      // final cutoffTime = now.subtract(const Duration(hours: 24));

      // final usersCollection = FirebaseFirestore.instance.collection('users');
      // final usersSnapshot = await usersCollection.get();

      // for (var userDoc in usersSnapshot.docs) {
      //   final userId = userDoc.id;
      //   final statusCollectionSnap =
      //       await usersCollection.doc(userId).collection('status').get();

      //   if (statusCollectionSnap.docs.isEmpty) {
      //     continue;
      //   }

      //   final statusDocs = statusCollectionSnap.docs;
      //   for (var doc in statusDocs) {
      //     final StatusModel statusModel = StatusModel.fromJson(map: doc.data());
      //     if (statusModel.statusList == null) {
      //       continue;
      //     }

      //     final updatedStatusList =
      //         statusModel.statusList?.where((uploadedStatus) {
      //       final statusTime =
      //           DateTime.parse(uploadedStatus.statusUploadedTime!);
      //       return statusTime.isAfter(cutoffTime);
      //     }).toList();

      //     await usersCollection
      //         .doc(userId)
      //         .collection(statusCollection)
      //         .doc(statusModel.statusId)
      //         .update({
      //       dbStatusContentList:
      //           updatedStatusList?.map((status) => status.toJson()).toList(),
      //     });
      //   }
      // }
      log("Old statuses deleted successfully.");
    } catch (e) {
      log("Error while deleting old statuses: $e");
      null;
    }
  }

// contacts collection fetch
  static Stream<List<ContactModel>>? getContactsCollection() {
    return fireStore
        .collection(usersCollection)
        .doc(firebaseAuth.currentUser?.uid)
        .collection(contactsCollection)
        .snapshots()
        .map(
      (contactsSnapshot) {
        return contactsSnapshot.docs
            .map((contactMap) => ContactModel.fromjson(contactMap.data()))
            .toList();
      },
    );
  }

  static Future<ChatModel?> getChatModelByChatID(
      {required String chatModelId}) async {
    try {
      final chatDocRef = await fireStore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser?.uid)
          .collection(chatsCollection)
          .doc(chatModelId)
          .get();
      if (chatDocRef.exists) {
        return ChatModel.fromJson(chatDocRef.data()!);
      } else {
        return null;
      }
    } catch (e) {
      log("Error on chatModel get");
      return null;
    }
  }

  static Stream<ChatModel?>? getChatModelByChatIDAsStream(
      {required String? chatModelId}) {
    try {
      return fireStore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser?.uid)
          .collection(chatsCollection)
          .doc(chatModelId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return ChatModel.fromJson(snapshot.data()!);
        } else {
          return null;
        }
      });
    } catch (e) {
      log("Error on chatModel get");
      return null;
    }
  }

  static Future<ChatModel?> getChatModel({required String receiverID}) async {
    final chatInSenderAppWithReceiver = await fireStore
        .collection(usersCollection)
        .doc(firebaseAuth.currentUser?.uid)
        .collection(chatsCollection)
        .where(receiverId, isEqualTo: receiverID)
        .get();
    final chatInReceiverAppWithSender = await fireStore
        .collection(usersCollection)
        .doc(receiverID)
        .collection(chatsCollection)
        .where(senderId, isEqualTo: firebaseAuth.currentUser?.uid)
        .get();

    if (chatInSenderAppWithReceiver.docs.isNotEmpty) {
      return ChatModel.fromJson(chatInSenderAppWithReceiver.docs.first.data());
    } else if (chatInReceiverAppWithSender.docs.isNotEmpty) {
      return ChatModel.fromJson(chatInReceiverAppWithSender.docs.first.data());
    } else {
      return null;
    }
  }

  static setWallpaper({
    required ChatModel? chatModel,
    required GroupModel? groupModel,
    required File? wallpaperFile,
    required For forWhich,
  }) async {
    log("Inside wallpaper function");
    final currentUserId = firebaseAuth.currentUser?.uid;
    log("Curent : $currentUserId");
    if (currentUserId == null) return;
    if (chatModel != null && forWhich == For.notAll) {
      final wallpaperUrl = await saveUserFileToDataBaseStorage(
          ref: "WallPaper/$currentUserId${chatModel.chatID}",
          file: wallpaperFile!);
      final ChatModel updatedChatModel = chatModel.copyWith(
        chatWallpaper: wallpaperUrl,
      );
      fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatModel.chatID)
          .update(updatedChatModel.toJson());
      log("Inside wallpaper chatmodel");
    } else if (groupModel != null && forWhich == For.notAll) {
      final wallpaperUrl = await saveUserFileToDataBaseStorage(
          ref: "WallPaper/$currentUserId${groupModel.groupID}",
          file: wallpaperFile!);
      final GroupModel updatedGroupModel = groupModel.copyWith(
        groupWallpaper: wallpaperUrl,
      );
      fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(groupsCollection)
          .doc(groupModel.groupID)
          .update(updatedGroupModel.toJson());
      log("Inside wallpaper groupmodel");
    } else {
      // For all
      final wallpaperUrl = await saveUserFileToDataBaseStorage(
          ref: "WallPaper/$currentUserId", file: wallpaperFile!);
      final chatDocs = await fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .get();
      for (var doc in chatDocs.docs) {
        await doc.reference.update({dbchatWallpaper: wallpaperUrl});
      }

      final groupDocs = await fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(groupsCollection)
          .get();
      for (var doc in groupDocs.docs) {
        await doc.reference.update({dbGroupWallpaper: wallpaperUrl});
      }
      log("Inside wallpaper all");
    }
  }
}

List<T> filterPermissions<T>(Map<T, bool> permissions) {
  return permissions.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();
}

List<String> enumListToStringList<T>(List<T> enumList) {
  return enumList.map((e) => e.toString().split('.').last).toList();
}

List<T> stringListToEnumList<T>(List<String> stringList, List<T> enumValues) {
  return stringList.map((e) {
    return enumValues
        .firstWhere((enumValue) => enumValue.toString().split('.').last == e);
  }).toList();
}

// check message is incoming or not
bool checkIsIncomingMessage({
  GroupModel? groupModel,
  required bool isGroup,
  required MessageModel message,
}) {
  bool isCurrentUserMessage;
  if (isGroup && groupModel != null) {
    isCurrentUserMessage =
        groupModel.groupMembers!.contains(firebaseAuth.currentUser?.uid) &&
            message.senderID == firebaseAuth.currentUser?.uid;
  } else {
    isCurrentUserMessage = firebaseAuth.currentUser?.uid == message.senderID;
  }
  return isCurrentUserMessage;
}
