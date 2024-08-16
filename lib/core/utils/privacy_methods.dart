import 'dart:developer';

import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/contact_methods.dart';

class PrivacyMethods {
  static Future<bool> _isUserInContacts(String receiverID) async {
    // Fetch contacts for the given receiver
    final contactsSnapshot = await ContactMethods.getContactsCollection(id: receiverID);
    // Check if the current user is in the contacts list
    if (contactsSnapshot != null) {
      final isUserInContacts = contactsSnapshot.docs.any((doc) => doc.id == firebaseAuth.currentUser?.uid);
      return isUserInContacts;
    }

    return false;
  }
  static Future<bool> isShowableProfileImage(
      {required String? receiverID}) async {
    if (receiverID == null) {
      log("Receiver ID is null");
      return false;
    }

    final receiverData =
        await CommonDBFunctions.getOneUserDataFromDBFuture(userId: receiverID);
    log("Fetched receiver data: ${receiverData.toString()}");

    final privacySetting =
        receiverData?.privacySettings?[userDbProfilePhotoPrivacy];
    log("Profile photo privacy setting: $privacySetting");

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

  static Future<bool> isShowableOnlineLastSeen(
      {required String? receiverID}) async {
    if (receiverID == null) {
      log("Receiver ID is null");
      return false;
    }

    final receiverData =await CommonDBFunctions.getOneUserDataFromDBFuture(userId: receiverID);
    final privacySetting = receiverData?.privacySettings?[userDbLastSeenOnline];
    log("Fetched receiver data: ${receiverData.toString()}");
    log("Last seen privacy setting: $privacySetting");

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
  static Future<bool> isShowableAbout({required String? receiverID}) async {
    if (receiverID == null) {
      log("Receiver ID is null");
      return false;
    }

    final receiverData = await CommonDBFunctions.getOneUserDataFromDBFuture(userId: receiverID);
    final privacySetting = receiverData?.privacySettings?[userDbAboutPrivacy];

    log("Fetched receiver data: ${receiverData.toString()}");
    log("Fetched About Privacy Setting: $privacySetting");

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
      log("Receiver ID is null");
      return false;
    }

    final receiverData = await CommonDBFunctions.getOneUserDataFromDBFuture(userId: receiverID);
    final privacySetting = receiverData?.privacySettings?[userDbStatusPrivacy];

    log("Fetched receiver data: ${receiverData.toString()}");
    log("Fetched About Privacy Setting: $privacySetting");

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
