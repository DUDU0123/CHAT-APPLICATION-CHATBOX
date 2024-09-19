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
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';

class CommonDBFunctions {
  static Future<bool> saveUserDataToDB(
      {required UserModel userData, File? profileImage}) async {
    try {
      if (profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
            ref: "profile_images/${userData.id}", file: profileImage);
        userData = userData.copyWith(userProfileImage: userProfileImage);
      }
      await fireStore
          .collection(usersCollection)
          .doc(userData.id)
          .set(userData.toJson());
      return true;
    } on FirebaseAuthException catch (e) {
      log("Error while saving user data: $e");
      return false;
    } catch (e) {
      log("Error while saving user data: $e");
      return false;
    }
  }

  static Future<String> saveUserFileToDataBaseStorage({
    required String ref,
    required File file,
  }) async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while saving file to storage: $e");
    } catch (e) {
      throw Exception("Error while saving file to storage: $e");
    }
  }

  static Future<bool> isPhoneNumberAlreadyExists(
      {required String phoneNumber}) async {
    final normalizedNumber = normalizePhoneNumber(phoneNumber);

    // Query Firestore to check if the phone number exists
    final querySnapshot = await fireStore
        .collection(usersCollection)
        .where(userDbPhoneNumber, isEqualTo: normalizedNumber)
        .get();

    // Return true if any document exists, false otherwise
    return querySnapshot.docs.isNotEmpty;
  }

  static String normalizePhoneNumber(String phoneNumber) {
    // Remove all characters except digits and the plus sign
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (phoneNumber.startsWith('+91') &&
        phoneNumber.length > 3 &&
        phoneNumber[3] != ' ') {
      phoneNumber = '+91 ' + phoneNumber.substring(3);
    }
    if (phoneNumber.length == 10) {
      phoneNumber = '+91 ' + phoneNumber;
    }

    return phoneNumber;
  }

  static Future<bool> checkIfIsBlocked({
    required String? receiverId,
    required String? currentUserId,
  }) async {
    try {
      final blockedUserDoc = await fireStore
          .collection(usersCollection)
          .doc(receiverId)
          .collection(blockedUsersCollection)
          .where('blocked_user_id', isEqualTo: currentUserId)
          .get();

      return blockedUserDoc.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<BlockedUserModel>>? getAllBlockedUsers({String? userId}) {
    try {
      return fireStore
          .collection(usersCollection)
          .doc(userId ?? firebaseAuth.currentUser?.uid)
          .collection(blockedUsersCollection)
          .snapshots()
          .map((blockSnap) {
        return blockSnap.docs
            .map((blocDoc) => BlockedUserModel.fromJson(map: blocDoc.data()))
            .toList();
      });
    } on FirebaseAuthException catch (e) {
      return null;
    } catch (e) {
      return null;
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
      throw Exception("Error while fetching message data: $e");
    } catch (e) {
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
        return null;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while fetching user data: $e");
    } catch (e, stackTrace) {
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
      throw Exception("Error while fetching user data: $e");
    } catch (e, stackTrace) {
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
      throw Exception("Error while fetching user data: $e");
    } catch (e, stackTrace) {
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
      throw Exception(e.toString());
    }
  }

  static Future<bool> checkAssetExists(String url) async {
    try {
      // Extract the path from the URL
      Uri uri = Uri.parse(url);
      String path = uri.path;
      // Remove the initial "/v0/b/<bucket-name>/o/" part
      path = path.replaceFirst(RegExp(r'^/v0/b/[^/]+/o/'), '');
      // Decode the URL-encoded path
      path = Uri.decodeFull(path);

      // Get a reference to the file
      final ref = FirebaseStorage.instance.ref(path);

      // Try to fetch the metadata
      await ref.getMetadata();

      // If we reach here, the file exists
      return true;
    } catch (e) {
      // If we get here, the file doesn't exist or there was an error
      return false;
    }
  }

  static void saveGroupMessageTime(
      {required GroupModel? groupModel, required String? messageTime}) async {
    if (groupModel?.groupMembers != null) {
      for (var memberID in groupModel!.groupMembers!) {
        await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(memberID)
            .collection(groupsCollection)
            .doc(groupModel.groupID)
            .update({
          dbGroupLastMessageTime: messageTime,
        });
      }
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
        .collection(usersCollection)
        .doc(userId)
        .collection(chatsCollection)
        .doc(chatId)
        .update({isUserChatOpen: isOpen});
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
      throw Exception("Error while deleteAllMessagesInDB: $e");
    } catch (e, stackTrace) {
      throw Exception("Error while deleteAllMessagesInDB: $e");
    }
  }

  // method to get/read all status
  static Stream<StatusModel?>? getCurrentUserStatus() {
    final currentUser = firebaseAuth.currentUser?.uid;
    try {
      if (currentUser == null) {
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
      return null;
    } catch (e, stackTrace) {
      return null;
    }
  }

  static Future<void> updateStatusListInStatusModelInDB({
    required String? userId,
  }) async {
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
    } catch (e) {
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
    required File wallpaperFile,
    required For forWhich,
  }) async {
    final currentUserId = firebaseAuth.currentUser?.uid;
    if (currentUserId == null) return;
    if (chatModel != null && forWhich == For.notAll) {
      final wallpaperUrl = await saveUserFileToDataBaseStorage(
          ref: "WallPaper/$currentUserId${chatModel.chatID}",
          file: wallpaperFile);
      final ChatModel updatedChatModel = chatModel.copyWith(
        chatWallpaper: wallpaperUrl,
      );
      fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatModel.chatID)
          .update(updatedChatModel.toJson());
    } else if (groupModel != null && forWhich == For.notAll) {
      final wallpaperUrl = await saveUserFileToDataBaseStorage(
          ref: "WallPaper/$currentUserId${groupModel.groupID}",
          file: wallpaperFile);
      final GroupModel updatedGroupModel = groupModel.copyWith(
        groupWallpaper: wallpaperUrl,
      );
      fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(groupsCollection)
          .doc(groupModel.groupID)
          .update(updatedGroupModel.toJson());
    } else {
      // For all
      final wallpaperUrl = await saveUserFileToDataBaseStorage(
          ref: "WallPaper/$currentUserId", file: wallpaperFile);
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
