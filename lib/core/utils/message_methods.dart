import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
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
    required BuildContext rootContext,
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
      backgroundColor: Theme.of(rootContext).scaffoldBackgroundColor,
      context: rootContext,
      builder: (context) {
        return messageActionBottomSheetShowWidget(
          context: rootContext,
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
    final currentUser = firebaseAuth.currentUser;
    if (chatModel != null) {
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

  static void sendMessage({
    required BuildContext context,
    required ChatModel? chatModel,
    required TextEditingController messageController,
    required ScrollController scrollController,
    required String? receiverContactName,
    required bool isGroup,
    GroupModel? groupModel,
    MessageModel? replyToMessage,
  }) {
    MessageModel message;
    if (!isGroup) {
      message = MessageModel(
        replyToMessage: replyToMessage,
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        senderID: chatModel?.senderID,
        receiverID: chatModel?.receiverID,
        messageTime: DateTime.now().toString(),
        isPinnedMessage: false,
        isStarredMessage: false,
        isDeletedMessage: false,
        isEditedMessage: false,
        message: messageController.text,
        messageType: MessageType.text,
        messageStatus: MessageStatus.sent,
      );
    } else {
      message = MessageModel(
        replyToMessage: replyToMessage,
        senderID: firebaseAuth.currentUser?.uid,
        messageTime: DateTime.now().toString(),
        isPinnedMessage: false,
        isStarredMessage: false,
        isDeletedMessage: false,
        isEditedMessage: false,
        message: messageController.text,
        messageType: MessageType.text,
        messageStatus: MessageStatus.sent,
      );
    }
    context.read<MessageBloc>().add(
          MessageSentEvent(
            context: context,
            isGroup: isGroup,
            groupModel: groupModel,
            currentUserId: firebaseAuth.currentUser?.uid ?? '',
            receiverContactName: receiverContactName ?? '',
            receiverID: chatModel?.receiverID ?? '',
            chatModel: chatModel,
            message: message,
          ),
        );
        log("Chatmodel id : ${chatModel?.chatID}");
    messageController.clear();
  }

  static void shareMessage({
    required List<ContactModel>? selectedContactList,
    required MessageBloc messageBloc,
    required MessageType? messageType,
    required String? messageContent,
    required BuildContext context,
  }) async {
    for (var contact in selectedContactList!) {
      if (contact.chatBoxUserId != null && firebaseAuth.currentUser != null) {
        final ChatModel? chatModel = await CommonDBFunctions.getChatModel(
          receiverID: contact.chatBoxUserId!,
        );
        final UserModel? receiverModel =
            await CommonDBFunctions.getOneUserDataFromDBFuture(
                userId: contact.chatBoxUserId);

        final MessageModel message = MessageModel(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          message: messageContent,
          isDeletedMessage: false,
          isEditedMessage: false,
          isPinnedMessage: false,
          isStarredMessage: false,
          messageStatus: MessageStatus.sent,
          messageTime: DateTime.now().toString(),
          messageType: messageType,
          receiverID: contact.chatBoxUserId,
          senderID: firebaseAuth.currentUser?.uid,
        );
        messageBloc.add(MessageSentEvent(
          context: context,
          chatModel: chatModel,
          receiverID: contact.chatBoxUserId!,
          currentUserId: firebaseAuth.currentUser!.uid,
          receiverContactName: receiverModel?.contactName ??
              receiverModel?.userName ??
              receiverModel?.phoneNumber ??
              '',
          message: message,
          isGroup: false,
        ));
      }
    }
  }

  // to send
  static void toSendMethod({
  required bool isStatus,
  required StatusModel? statusModel,
  required String? uploadedStatusModelID,
  required bool mounted,
  required MessageBloc messageBloc,
  required BuildContext context,
  required MessageType? messageType,
  required String? messageContent,
  required List<ContactModel>? selectedContactList,
  required BuildContext? rootContext,
}) async {
  if (isStatus) {
    final val = await fireStore
        .collection(usersCollection)
        .doc(firebaseAuth.currentUser?.uid)
        .collection(statusCollection)
        .doc(statusModel?.statusId)
        .get();
    final statusMOdell = StatusModel.fromJson(map: val.data()!);
    final sendingStatus = statusMOdell.statusList?.firstWhere(
        (status) => status.uploadedStatusId == uploadedStatusModelID);

    if (mounted) {
      MessageMethods.shareMessage(
        selectedContactList: selectedContactList,
        messageBloc: messageBloc,
        messageType: sendingStatus?.statusType == StatusType.video
            ? MessageType.video
            : sendingStatus?.statusType == StatusType.image
                ? MessageType.photo
                : MessageType.text,
        messageContent: sendingStatus?.statusContent,
        context: context,
      );
    }
  } else {
    if (messageContent != null && messageType != null) {
      MessageMethods.shareMessage(
        context: rootContext!,
        selectedContactList: selectedContactList,
        messageBloc: messageBloc,
        messageType: messageType,
        messageContent: messageContent,
      );
    }
  }
  if (mounted) {
    Navigator.pop(context);
  }
}

}
