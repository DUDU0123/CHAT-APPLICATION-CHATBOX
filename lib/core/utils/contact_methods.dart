import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';

class ContactMethods {
  static sendSelectedContactMessage(
      {required List<ContactModel>? selectedContactList,
      required String? receiverContactName,
      required BuildContext context,
      required bool isGroup,
      required GroupModel? groupModel,
      required ChatModel? chatModel}) {
    if (selectedContactList!=null && selectedContactList.isNotEmpty) {
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
    }else{
      commonSnackBarWidget(
            contentText: "Select atleast one contact to send",
            context: context,
          );
    }
  }
}