import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/service/dialog_helper.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/data_sources/contact_data/contact_data.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/contact_repo/contact_repository.dart';
class ContactRepoImpl extends ContactRepository {
  final ContactData contactData;
  final FirebaseFirestore firebaseFirestore;
  ContactRepoImpl({
    required this.contactData,
    required this.firebaseFirestore,
  });
  @override
  Future<List<ContactModel>> getAccessToUserContacts(
      {required BuildContext context}) async {
    List<ContactModel> contactsModelList = [];
    try {
      final contacts = await contactData.getContactsInUserDevice();

      // Normalize and map phone numbers from the device contacts
      final phoneNumbers = contacts
          .where((contact) => contact.phones.isNotEmpty)
          .map((contact) => CommonDBFunctions.normalizePhoneNumber(contact.phones.first.number))
          .toList();

      // Fetch users from Firestore by normalized phone numbers
      final userSnapshots =
          await Future.wait(phoneNumbers.map((normalizedPhone) {
        log('Normalized phone from contacts: $normalizedPhone'); // Log normalized phone number
        return firebaseFirestore
            .collection(usersCollection)
            .where(userDbPhoneNumber, isEqualTo: normalizedPhone)
            .get();
      }));

      print("snapshots: ${userSnapshots.first.docs}");

      // Create a map of normalized phone numbers to Firestore data
      final userMap = <String, Map<String, dynamic>>{};
      for (var snapshot in userSnapshots) {
        print("User snap: ${snapshot.docs}");
        if (snapshot.docs.isNotEmpty) {
          var userData = snapshot.docs.first.data();

          // Normalize phone number from Firestore before storing in map
          var phoneInDb = CommonDBFunctions.normalizePhoneNumber(userData[userDbPhoneNumber]);
          userMap[phoneInDb] = userData;
        }
      }

      // Process contacts with normalized phone numbers
      for (var contact in contacts) {
        var contactModel = ContactModel.fromJson(contact);

        if (contactModel.userContactNumber != null) {
          var normalizedContactPhone =
              CommonDBFunctions.normalizePhoneNumber(contactModel.userContactNumber!);

          if (userMap.containsKey(normalizedContactPhone)) {
            var userData = userMap[normalizedContactPhone]!;

            contactModel = ContactModel(
              contactId: contactModel.contactId,
              chatBoxUserId: userData[userDbId],
              userContactName: contactModel.userContactName,
              userAbout: userData[userDbAbout],
              userProfilePhotoOnChatBox: userData[userDbProfileImage],
              userContactNumber: contactModel.userContactNumber,
              isChatBoxUser: true,
            );

            await fireStore
                .collection(usersCollection)
                .doc(contactModel.chatBoxUserId)
                .update({
              userDbContactName: contactModel.userContactName,
            });
          }
        }

        contactsModelList.add(contactModel);

        // Save each contact to Firestore if not already saved
        if (firebaseAuth.currentUser?.uid != null &&
            contactModel.chatBoxUserId != null) {
          var currentUserDoc = firebaseFirestore
              .collection(usersCollection)
              .doc(firebaseAuth.currentUser?.uid);

          var contactDoc = await currentUserDoc
              .collection(contactsCollection)
              .doc(contactModel.chatBoxUserId)
              .get();

          if (!contactDoc.exists) {
            await currentUserDoc
                .collection(contactsCollection)
                .doc(contactModel.chatBoxUserId)
                .set(contactModel.toJson());
          }
        }
      }

      return contactsModelList;
    } on SocketException catch (e) {
      DialogHelper.showDialogMethod(
        title: "Network Error",
        contentText: "Please check your network connection",
      );
      return [];
    } catch (e) {
      DialogHelper.showSnackBar(
          title: "Error Occurred", contentText: e.toString());
      return [];
    }
  }


}