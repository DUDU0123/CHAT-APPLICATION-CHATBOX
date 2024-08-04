import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/message/message_action_bottom_sheet_show_widget.dart';

class MessageMethods {
  static copyMessage({
    required String textToCopy,
    required BuildContext context,
  }) async {
    await Clipboard.setData(
      ClipboardData(
        text: textToCopy,
      ),
    ).then((value) {
      return commonSnackBarWidget(
        contentText: "Message copied",
        context: context,
      );
    });
  }

  static Future<dynamic> messageActionMethods({
    required BuildContext context,
    required MessageModel? message,
    required bool isGroup,
    required Set<String> selectedMessagesId,
    required GroupModel? groupModel,
    required ChatModel? chatModel,
  }) {
    return showModalBottomSheet(
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.sp),
          topRight: Radius.circular(25.sp),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return messageActionBottomSheetShowWidget(
          context: context,
          selectedMessagesId: selectedMessagesId,
          message: message,
          chatModel: chatModel,
          groupModel: groupModel,
          isGroup: isGroup,
        );
      },
    );
  }

  static Stream<MessageModel?> getLastMessage({
    ChatModel? chatModel,
    GroupModel? groupModel,
  }) {
    log("Im inside message find");
    final currentUser = firebaseAuth.currentUser;
    if (chatModel != null) {
      log("chatmodel NOT nULL");
      return fireStore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('chats')
          .doc(chatModel.chatID)
          .collection('messages')
          .orderBy(dbMessageSendTime, descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return MessageModel.fromJson(map: snapshot.docs.first.data());
        } else {
          return null;
        }
      });
    } else if (groupModel != null) {
      log("Groupmodel Not null");
      return fireStore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('groups')
          .doc(groupModel.groupID)
          .collection('messages')
          .orderBy(dbMessageSendTime, descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return MessageModel.fromJson(map: snapshot.docs.first.data());
        } else {
          return null;
        }
      });
    } else {
      return Stream.value(null);
    }
  }
}
