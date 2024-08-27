import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/service/dialog_helper.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';

class GroupData {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  GroupData({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });
  // group subscription for sending notification
  static Future<void> subscribeUserToGroupTopic({
    required String userId,
    required String groupid,
  }) async {
    try {
      final userDoc =
          await fireStore.collection(usersCollection).doc(userId).get();
      if (userDoc.exists) {
        final userData = UserModel.fromJson(map: userDoc.data()!);
        log('User ID: ${userData.id}');
        if (userData.fcmToken != null && userData.fcmToken!.isNotEmpty) {
          log("FCM Token: ${userData.fcmToken}");
          await FirebaseMessaging.instance.subscribeToTopic('group_$groupid');
          log("Successfully subscribed to group topic: group_$groupid");
        } else {
          log("User FCM Token is null or empty.");
        }
      } else {
        log("User document does not exist.");
      }
    } catch (e) {
      log("Error subscribing to group topic: ${e.toString()}");
    }
  }

  static Future<void> unsubscribeUserFromGroupTopic({
    required String userId,
    required String groupId,
  }) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic('group_$groupId');
      log("Successfully unsubscribed from group topic: group_$groupId");
    } catch (e) {
      log("Error unsubscribing from group topic: ${e.toString()}");
    }
  }

// new group create method
  Future<bool?> createNewGroup(
      {required GroupModel newGroupData, required File? groupImageFile}) async {
    try {
      final User? currentser = firebaseAuth.currentUser;
      if (currentser == null) {
        log("Current user is null");
        return false;
      }
      if (newGroupData.groupMembers == null ||
          newGroupData.groupMembers!.isEmpty) {
        log("group member empty, or null");
        return false;
      }

      // here we are creating a group doc and getting the id for making the id of the group for all members the same
      final groupDocumentReference =
          firebaseFirestore.collection(groupsCollection).doc();
      // Group profile image upload to storage db and its url to firestore db

      final groupDocumentID = groupDocumentReference.id;
      log("Generated group document ID: $groupDocumentID");

      String groupProfilePhotoUrl = '';
      if (groupImageFile != null) {
        groupProfilePhotoUrl =
            await CommonDBFunctions.saveUserFileToDataBaseStorage(
          ref: "GroupsProfilePhotoFolder/$groupDocumentID",
          file: groupImageFile,
        );
      }

      GroupModel updatedGroupData = newGroupData.copyWith(
        groupID: groupDocumentID,
        groupProfileImage:
            groupProfilePhotoUrl.isNotEmpty ? groupProfilePhotoUrl : null,
      );
      log(
          name: "Updated Group Data",
          "${updatedGroupData.groupName} ${updatedGroupData.groupCreatedAt}");
      WriteBatch batch = firebaseFirestore.batch();
      // setting the groupdata with id before setting it for all members
      batch.set(groupDocumentReference, updatedGroupData.toJson());

      // iterating through each user id and creating group in their groups collection using the id of the group doc before created
      for (String userID in newGroupData.groupMembers!) {
        final newDocumentRefernce = firebaseFirestore
            .collection(usersCollection)
            .doc(userID)
            .collection(groupsCollection)
            .doc(groupDocumentID);
        final user =
            await CommonDBFunctions.getOneUserDataFromDBFuture(userId: userID);
        if (user != null) {
          final userGroupIDList = user.userGroupIdList ?? [];
          userGroupIDList.add(groupDocumentID);
          final updatedUser = user.copyWith(userGroupIdList: userGroupIDList);
          batch.update(
            firebaseFirestore.collection(usersCollection).doc(userID),
            updatedUser.toJson(),
          );
        }
        batch.set(
          newDocumentRefernce,
          updatedGroupData.toJson(),
        );
      }

      await batch.commit();
      log("Group created successfully with ID: $groupDocumentID");
      for (String userID in newGroupData.groupMembers!) {
        await subscribeUserToGroupTopic(
            userId: userID, groupid: updatedGroupData.groupID!);
      }
      return true;
    } on FirebaseException catch (e) {
      log("From new group creation firebase: ${e.toString()}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    } catch (e) {
      log("From new group creation catch: ${e.toString()}");
    }
    log("Can't do try ctach");
    return false;
  }

  // read all groups of current user to display in application UI
  Stream<List<GroupModel>>? getAllGroups() {
    try {
      final User? currentser = firebaseAuth.currentUser;
      return firebaseFirestore
          .collection(usersCollection)
          .doc(currentser?.uid)
          .collection(groupsCollection)
          .orderBy(dbGroupLastMessageTime, descending: true)
          .snapshots()
          .map((groupSnapShot) {
        return groupSnapShot.docs.map((doc) {
          return GroupModel.fromJson(map: doc.data());
        }).toList();
      });
    } on FirebaseException catch (e) {
      log("From new group creation firebase: ${e.toString()}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    } catch (e) {
      log("From new group creation catch: ${e.toString()}");
    }
    return null;
  }

  Future<bool> updateGroupData({
    required GroupModel updatedGroupModel,
    required File? groupImageFile,
  }) async {
    try {
      final User? currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return false;
      }
      if (updatedGroupModel.groupMembers == null ||
          updatedGroupModel.groupMembers!.isEmpty) {
        return false;
      }

      String groupProfilePhotoUrl = '';
      if (groupImageFile != null) {
        groupProfilePhotoUrl =
            await CommonDBFunctions.saveUserFileToDataBaseStorage(
          ref: "GroupsProfilePhotoFolder/${updatedGroupModel.groupID}",
          file: groupImageFile,
        );
      }

      GroupModel updatedGroupData = updatedGroupModel.copyWith(
        groupProfileImage: groupProfilePhotoUrl.isNotEmpty
            ? groupProfilePhotoUrl
            : updatedGroupModel.groupProfileImage,
      );
      WriteBatch batch = firebaseFirestore.batch();
      DocumentReference groupDocRef = firebaseFirestore
          .collection(groupsCollection)
          .doc(updatedGroupData.groupID);
      batch.update(groupDocRef, updatedGroupData.toJson());
      for (String userID in updatedGroupData.groupMembers!) {
        final updatedDocumentRefernce = firebaseFirestore
            .collection(usersCollection)
            .doc(userID)
            .collection(groupsCollection)
            .doc(updatedGroupData.groupID);
        batch.set(updatedDocumentRefernce, updatedGroupData.toJson(),
            SetOptions(merge: true));
      }
      await batch.commit();
      return true;
    } on FirebaseException catch (e) {
      log("From new group creation firebase: ${e.toString()}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    } catch (e) {
      log("From new group creation catch: ${e.toString()}");
    }
    return false;
  }

  Future<bool> removeOrExitFromGroupMethod({
    required GroupModel updatedGroupModel,
    required GroupModel oldGroupModel,
  }) async {
    try {
      final User? currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return false;
      }
      if (updatedGroupModel.groupMembers == null ||
          updatedGroupModel.groupMembers!.isEmpty) {
        return false;
      }

      WriteBatch batch = firebaseFirestore.batch();
      DocumentReference groupDocRef = firebaseFirestore
          .collection(groupsCollection)
          .doc(updatedGroupModel.groupID);
      batch.update(groupDocRef, updatedGroupModel.toJson());
      for (String userID in oldGroupModel.groupMembers!) {
        final updatedDocumentRefernce = firebaseFirestore
            .collection(usersCollection)
            .doc(userID)
            .collection(groupsCollection)
            .doc(updatedGroupModel.groupID);
        batch.set(updatedDocumentRefernce, updatedGroupModel.toJson(),
            SetOptions(merge: true));
      }
      await batch.commit();
      return true;
    } on FirebaseException catch (e) {
      log("From new group creation firebase: ${e.toString()}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    } catch (e) {
      log("From new group creation catch: ${e.toString()}");
    }
    return false;
  }

  Future<String> deleteAgroupFromGroupsCurrentUser(
      {required String groupID}) async {
    try {
      final User? currentUser = firebaseAuth.currentUser;

      await firebaseFirestore
          .collection(usersCollection)
          .doc(currentUser?.uid)
          .collection(groupsCollection)
          .doc(groupID)
          .delete();
      return "Deleted successfully";
    } on FirebaseException catch (e) {
      log("From new group creation firebase: ${e.toString()}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    } catch (e) {
      log("From new group creation catch: ${e.toString()}");
    }
    return "Can't delete";
  }

  Future<void> clearGroupChat({required String groupID}) async {
    try {
      final User? currentUser = firebaseAuth.currentUser;
      final messageCollectionSnapshot = await firebaseFirestore
          .collection(usersCollection)
          .doc(currentUser?.uid)
          .collection(groupsCollection)
          .doc(groupID)
          .collection(messagesCollection)
          .get();
      final WriteBatch batch = firebaseFirestore.batch();
      for (final DocumentSnapshot messageDoc
          in messageCollectionSnapshot.docs) {
        batch.delete(messageDoc.reference);
      }

      // Commit the batch
      await batch.commit();
    } on FirebaseException catch (e) {
      log("From new group creation firebase: ${e.toString()}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    } catch (e) {
      log("From new group creation catch: ${e.toString()}");
    }
  }
}
