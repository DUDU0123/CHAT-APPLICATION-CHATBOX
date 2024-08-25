import 'dart:developer';

import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/contact_methods.dart';

class PrivacyMethods {
  static String typeGiver({required int? groupValue}) {
    switch (groupValue) {
      case 1:
        return "Everyone";
      case 2:
        return "My contacts";
      case 3:
        return "Nobody";
      default:
        return "Everyone";
    }
  }

  static int typeIntGiver({required String? groupValueString}) {
    switch (groupValueString) {
      case 'Everyone':
        return 1;
      case 'My contacts':
        return 2;
      case 'Nobody':
        return 3;
      default:
        return 1;
    }
  }

  static Future<bool> _isUserInContacts(String receiverID) async {
    // Fetch contacts for the given receiver
    final contactsSnapshot =
        await ContactMethods.getContactsCollection(id: receiverID);
    // Check if the current user is in the contacts list
    if (contactsSnapshot != null) {
      final isUserInContacts = contactsSnapshot.docs
          .any((doc) => doc.id == firebaseAuth.currentUser?.uid);
      return isUserInContacts;
    }

    return false;
  }

  static Future<bool> isBlocked({required String? receiverID}) async {
    final currentUserId = firebaseAuth.currentUser?.uid;

    if (receiverID == null || currentUserId == null) {
      return false;
    }

    try {
      // Check if the current user is in the receiver's blocked list
      final receiverBlockedListStream =
          CommonDBFunctions.getAllBlockedUsers(userId: receiverID);
      final receiverBlockedList = await receiverBlockedListStream?.first;
      final isCurrentUserBlockedByReceiver = receiverBlockedList
          ?.any((blockedUser) => blockedUser.userId == currentUserId);

      if (isCurrentUserBlockedByReceiver == true) {
        return true; // Block exists
      }

      // Check if the receiver is in the current user's blocked list
      final currentUserBlockedListStream =
          CommonDBFunctions.getAllBlockedUsers(userId: currentUserId);
      final currentUserBlockedList = await currentUserBlockedListStream?.first;
      final isReceiverBlockedByCurrentUser = currentUserBlockedList
          ?.any((blockedUser) => blockedUser.userId == receiverID);

      if (isReceiverBlockedByCurrentUser == true) {
        return true; // Block exists
      }
      return false;
    } catch (e, stackTrace) {
      log("Error in isBlocked: $e, StackTrace: $stackTrace");
      return false;
    }
  }

  static Future<bool> isShowableProfileImage(
      {required String? receiverID}) async {
    if (receiverID == null) {
      return false;
    }
    final isBlockedResult = await isBlocked(receiverID: receiverID);
    if (isBlockedResult) {
      return false; // Return false if either user is blocked
    }
    final receiverData =
        await CommonDBFunctions.getOneUserDataFromDBFuture(userId: receiverID);
    final privacySetting =
        receiverData?.privacySettings?[userDbProfilePhotoPrivacy];
    if (privacySetting == 'Nobody') {
      return false;
    } else if (privacySetting == 'My contacts') {
      final isUserInContacts = await _isUserInContacts(receiverID);
      return isUserInContacts;
    } else {
      return true;
    }
  }

  static Future<bool> isShowableOnlineLastSeen(
      {required String? receiverID}) async {
    if (receiverID == null) {
      return false;
    }
    final isBlockedResult = await isBlocked(receiverID: receiverID);
    if (isBlockedResult) {
      return false; // Return false if either user is blocked
    }

    final receiverData =
        await CommonDBFunctions.getOneUserDataFromDBFuture(userId: receiverID);
    final privacySetting = receiverData?.privacySettings?[userDbLastSeenOnline];

    if (privacySetting == 'Nobody') {
      return false;
    } else if (privacySetting == 'My contacts') {
      final isUserInContacts = await _isUserInContacts(receiverID);
      return isUserInContacts;
    } else {
      return true;
    }
  }

  static Future<bool> isShowableAbout({required String? receiverID}) async {
    if (receiverID == null) {
      return false;
    }
    final isBlockedResult = await isBlocked(receiverID: receiverID);
    if (isBlockedResult) {
      return false; // Return false if either user is blocked
    }

    final receiverData =
        await CommonDBFunctions.getOneUserDataFromDBFuture(userId: receiverID);
    final privacySetting = receiverData?.privacySettings?[userDbAboutPrivacy];

    if (privacySetting == 'Nobody') {
      return false;
    } else if (privacySetting == 'My contacts') {
      final isUserInContacts = await _isUserInContacts(receiverID);
      log("Is User in Contacts: $isUserInContacts");
      return isUserInContacts;
    } else {
      return true;
    }
  }

  static Future<bool> isShowableStatus({required String? receiverID}) async {
    if (receiverID == null) {
      return false;
    }
    final isBlockedResult = await isBlocked(receiverID: receiverID);
    if (isBlockedResult) {
      return false; // Return false if either user is blocked
    }

    final receiverData =
        await CommonDBFunctions.getOneUserDataFromDBFuture(userId: receiverID);
    final privacySetting = receiverData?.privacySettings?[userDbStatusPrivacy];

    if (privacySetting == 'Nobody') {
      return false;
    } else if (privacySetting == 'My contacts') {
      final isUserInContacts = await _isUserInContacts(receiverID);
      log("Is User in Contacts: $isUserInContacts");
      return isUserInContacts;
    } else {
      return true;
    }
  }
}
