import 'dart:developer';

import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/contact_methods.dart';

class PrivacyMethods{
 static Future<bool> isShowableProfileImage({required String? receiverID}) async {
  if (receiverID == null) {
    log("Receiver ID is null");
    return false;
  }

  final receiverData = await CommonDBFunctions.getOneUserDataFromDBFuture(userId: receiverID);
  log("Fetched receiver data: ${receiverData.toString()}");

  final privacySetting = receiverData?.privacySettings?[userDbProfilePhotoPrivacy];
  log("Profile photo privacy setting: $privacySetting");

  if (privacySetting == 'Nobody') {
    return false;
  } else if (privacySetting == 'My contacts') {
    final contactsSnapshot = await ContactMethods.getContactsCollection(id: receiverID);
    if (contactsSnapshot != null) {
      final isUserInContacts = contactsSnapshot.docs.any((doc) => doc.id == firebaseAuth.currentUser?.uid);
      return isUserInContacts;
    }
    return false;
  } else {
    return true;
  }
}

  static Future<bool> isShowableOnlineLastSeen({required String? receiverID}) async {
    if (receiverID == null) {
      return false;
    }
    final receiverData = await CommonDBFunctions.getOneUserDataFromDBFuture(
      userId: receiverID,
    );
    if (receiverData?.privacySettings?[userDbLastSeenOnline] == 'Nobody') {
      return false;
    } else if (receiverData?.privacySettings?[userDbLastSeenOnline] ==
        'My contacts') {
      final contactsSnapshot = await ContactMethods.getContactsCollection(
        id: receiverID,
      );
      if (contactsSnapshot != null) {
        final isUserInContacts = contactsSnapshot.docs
            .any((doc) => doc.id == firebaseAuth.currentUser?.uid);
        if (!isUserInContacts) {
          return false;
        } else {
          return true;
        }
      }
      return false;
    }else{
      return true;
    }
  }
  static Future<bool> isShowableAbout({required String? receiverID}) async {
    if (receiverID == null) {
      return false;
    }

    final receiverData = await CommonDBFunctions.getOneUserDataFromDBFuture(
      userId: receiverID,
    );
    if (receiverData?.privacySettings?[userDbAboutPrivacy] == 'Nobody') {
      return false;
    } else if (receiverData?.privacySettings?[userDbAboutPrivacy] ==
        'My contacts') {
      final contactsSnapshot = await ContactMethods.getContactsCollection(
        id: receiverID,
      );
      if (contactsSnapshot != null) {
        final isUserInContacts = contactsSnapshot.docs
            .any((doc) => doc.id == firebaseAuth.currentUser?.uid);
        if (!isUserInContacts) {
          return false;
        } else {
          return true;
        }
      }
      return false;
    }else{
      return true;
    }
  }
}