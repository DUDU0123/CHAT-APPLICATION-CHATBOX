

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/core/utils/message_methods.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/tile_icons.dart';

Widget buildProfileImage({
  required String? userProfileImage,
  required BuildContext context,
}) {
  return userProfileImage != null
      ? Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: Theme.of(context).popupMenuTheme.color,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(userProfileImage),
              fit: BoxFit.cover,
            ),
          ),
        )
      : Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: Theme.of(context).popupMenuTheme.color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.person,
              color: const Color.fromARGB(255, 134, 134, 134),
              size: 30.sp,
            ),
          ),
        );
}

Widget buildUserName({required String userName}) {
  return TextWidgetCommon(
    text: userName,
    overflow: TextOverflow.ellipsis,
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
  );
}

Widget buildSubtitle({
  required bool? isIncomingMessage,
  required bool isGroup,
  required bool? isTyping,
  required bool? isVoiceRecoding,
  required ChatModel? chatModel,
  required GroupModel? groupModel,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      // if (isIncomingMessage == null) zeroMeasureWidget,
      // if (isIncomingMessage == false)
        StreamBuilder(
          stream: MessageMethods.getLastMessage(
            chatModel: chatModel,
            groupModel: groupModel,
          ),
          builder: (context, snapshot) {
            if (snapshot.data?.senderID == firebaseAuth.currentUser?.uid) {
             return buildOutgoingStatus(
                isTyping: isTyping,
                isVoiceRecoding: isVoiceRecoding,
                chatModel: chatModel,
                groupModel: groupModel,
              );
            }
            return zeroMeasureWidget;
          },
        ),
        // buildOutgoingStatus(
        //   isTyping: isTyping,
        //   isVoiceRecoding: isVoiceRecoding,
        //   chatModel: chatModel,
        //   groupModel: groupModel,
        // ),
      if (isGroup && isIncomingMessage == true)
        buildIncomingPrefix(
          isTyping: isTyping,
          isVoiceRecoding: isVoiceRecoding,
        ),
      buildMessageText(
        chatModel: chatModel,
        groupModel: groupModel,
        isTyping: isTyping,
        isVoiceRecoding: isVoiceRecoding,
      ),
    ],
  );
}

Widget buildOutgoingStatus({
  required bool? isTyping,
  required bool? isVoiceRecoding,
  required ChatModel? chatModel,
  required GroupModel? groupModel,
}) {
  if (!(isTyping ?? false) && !(isVoiceRecoding ?? false)) {
    return messageStatusWidget(
      chatModel: chatModel,
      groupModel: groupModel,
    );
  }
  return zeroMeasureWidget;
}

Widget buildIncomingPrefix({
  required bool? isTyping,
  required bool? isVoiceRecoding,
}) {
  if (!(isTyping ?? false) && !(isVoiceRecoding ?? false)) {
    return TextWidgetCommon(
      text: "~Irshad: ",
      textColor: kGrey,
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
    );
  }
  return zeroMeasureWidget;
}

String messageByType({required MessageModel? message}) {
  switch (message?.messageType) {
    case MessageType.audio:
      return '🎧Audio';
    case MessageType.contact:
      return '📞Contact';
    case MessageType.document:
      return '📄Doc';
    case MessageType.photo:
      return '📷Photo';
    case MessageType.video:
      return '🎥Video';
    case MessageType.location:
      return '📌Location';
    default:
      return message?.message ?? '';
  }
}

Widget buildMessageText({
  required bool? isTyping,
  required bool? isVoiceRecoding,
  required ChatModel? chatModel,
  required GroupModel? groupModel,
}) {
  return Expanded(
    child: StreamBuilder<MessageModel?>(
        stream: MessageMethods.getLastMessage(
          chatModel: chatModel,
          groupModel: groupModel,
        ),
        builder: (context, snapshot) {
          return TextWidgetCommon(
            text: (!(isTyping ?? false) && !(isVoiceRecoding ?? false))
                ? messageByType(message: snapshot.data)
                : '',
            overflow: TextOverflow.ellipsis,
            textColor: kGrey,
            fontSize: 14.sp,
          );
        }),
  );
}

Widget buildTrailing({
  required BuildContext context,
  required int? notificationCount,
  required bool? isMutedChat,
  required ChatModel? chatModel,
  required GroupModel? groupModel,
}) {
  return SizedBox(
    // width: screenWidth(context: context) / 8,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StreamBuilder<MessageModel?>(
            stream: MessageMethods.getLastMessage(
              chatModel: chatModel,
              groupModel: groupModel,
            ),
            builder: (context, snapshot) {
              return TextWidgetCommon(
                text: snapshot.data != null
                    ? snapshot.data?.messageTime != null
                        ? DateProvider.formatMessageDateTime(
                            messageDateTimeString: snapshot.data!.messageTime!)
                        : ""
                    : "",
                fontSize: 10.sp,
                fontWeight: FontWeight.normal,
                textColor: kGrey,
              );
            }),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isMutedChat ?? false) tileMuteIconWidget(),
            kWidth5,
            if (notificationCount != null)
              if (notificationCount > 0)
                buildNotificationBadge(
                  notificationCount: notificationCount,
                ),
          ],
        ),
      ],
    ),
  );
}

Widget buildNotificationBadge({required int? notificationCount}) {
  return Container(
    height: 20.h,
    width: 28.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.sp),
      color: buttonSmallTextColor,
    ),
    child: Center(
      child: TextWidgetCommon(
        text: notificationCount.toString(),
        fontSize: 12.sp,
        textColor: kWhite,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
