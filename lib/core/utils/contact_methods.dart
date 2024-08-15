import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';

class ContactMethods {
  static sendSelectedContactMessage(
      {required List<ContactModel>? selectedContactList,
      required String? receiverContactName,
      required BuildContext context,
      required bool isGroup,
      required GroupModel? groupModel,
      required ChatModel? chatModel}) {
    if (selectedContactList != null && selectedContactList.isNotEmpty) {
      receiverContactName != null
          ? context.read<MessageBloc>().add(
                ContactMessageSendEvent(
                  isGroup: isGroup,
                  groupModel: groupModel,
                  receiverID: chatModel?.receiverID,
                  receiverContactName: receiverContactName,
                  contactListToSend: selectedContactList,
                  chatModel: chatModel,
                ),
              )
          : null;
      Navigator.pop(context);
    } else {
      commonSnackBarWidget(
        contentText: "Select atleast one contact to send",
        context: context,
      );
    }
  }

  static openContactInDevice({
    required BuildContext context,
    required String? receiverID,
  }) async {
    final contactBloc = context.read<ContactBloc>();
    final userModel = await CommonDBFunctions.getOneUserDataFromDBFuture(
      userId: receiverID,
    );
    try {
      // Find the contact where the chatBoxUserId matches the userModel's id
      final contactList = contactBloc.state.contactList?.where((contact) {
        log("Phone number userModel: ${userModel?.phoneNumber}");
        log("Phone number contact: ${contact.userContactNumber}");
        return contact.chatBoxUserId == userModel?.id;
      }).toList();

      if (contactList != null && contactList.isNotEmpty) {
        // Check if the first contact's contactId is not null
        if (contactList.first.contactId != null) {
          await FlutterContacts.openExternalView(contactList.first.contactId!);
        } else {
          log("Contact ID is null for the matched contact.");
        }
      } else {
        log("No contact matched the provided criteria.");
      }
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  static openEditContactInDevice({
    required BuildContext context,
    required String? receiverID,
  }) async {
    final contactBloc = context.read<ContactBloc>();
    final userModel = await CommonDBFunctions.getOneUserDataFromDBFuture(
      userId: receiverID,
    );
    try {
      // Find the contact where the chatBoxUserId matches the userModel's id
      final contactList = contactBloc.state.contactList?.where((contact) {
        log("Phone number userModel: ${userModel?.phoneNumber}");
        log("Phone number contact: ${contact.userContactNumber}");
        return contact.chatBoxUserId == userModel?.id;
      }).toList();

      if (contactList != null && contactList.isNotEmpty) {
        // Check if the first contact's contactId is not null
        if (contactList.first.contactId != null) {
          await FlutterContacts.openExternalEdit(contactList.first.contactId!);
        } else {
          log("Contact ID is null for the matched contact.");
        }
      } else {
        log("No contact matched the provided criteria.");
      }
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>?> getContactsCollection({
    required String? id,
  }) async {
    try {
      return await fireStore
          .collection(usersCollection)
          .doc(id)
          .collection(callsCollection)
          .get();
    } catch (e) {
      log("Error from get contacts collection: ${e.toString()}");
      return null;
    }
  }
}
