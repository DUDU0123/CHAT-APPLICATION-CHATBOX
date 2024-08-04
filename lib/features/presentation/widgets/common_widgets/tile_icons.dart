
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/message_methods.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_small_text_widget.dart';

class MessageStatusIcon {
  final IconData? icon;
  final Color? color;

  MessageStatusIcon({required this.icon, required this.color});
}

Widget messageStatusWidget({
  required ChatModel? chatModel,
  required GroupModel? groupModel,
}) {
  return StreamBuilder<MessageModel?>(
    stream: MessageMethods.getLastMessage(
        chatModel: chatModel, groupModel: groupModel),
    builder: (context, snapshot) {
      final lastMessage = snapshot.data;
      final MessageStatusIcon? messageStatusIcon = findLastMessageStatusIcon(
          lastMessage?.messageStatus);

      return Icon(
        messageStatusIcon?.icon,
        color: messageStatusIcon?.color,
        size: 18.sp,
      );
    },
  );
}

MessageStatusIcon findLastMessageStatusIcon(MessageStatus? lastMessageStatus) {
  switch (lastMessageStatus) {
    case MessageStatus.sent:
      return MessageStatusIcon(icon: Icons.done, color: iconGreyColor);
    case MessageStatus.delivered:
      return MessageStatusIcon(icon: Icons.done_all, color: iconGreyColor);
    case MessageStatus.read:
      return MessageStatusIcon(
          icon: Icons.done_all, color: buttonSmallTextColor);
    case MessageStatus.none:
      return MessageStatusIcon(
          icon: Icons.update, color: iconGreyColor);
    default:
      return MessageStatusIcon(icon: null, color: null); // Default icon and color
  }
}

Widget greyIconWidget({required iconName}) {
  return Icon(
    iconName,
    color: kGrey,
    size: 22.sp,
  );
}

Widget tileMuteIconWidget() {
  return Image.asset(
    mute,
    width: 20.w,
    height: 17.h,
    color: darkSmallTextColor,
  );
}

ChatTileSmallTextWidget recordingWidget({required bool isGroup}) {
  return ChatTileSmallTextWidget(
    smallText: isGroup ? "someOne Recording...." : "Recording",
  );
}

ChatTileSmallTextWidget typingWidget({required bool isGroup}) {
  return ChatTileSmallTextWidget(
    smallText: isGroup ? "someOne Typing...." : "Typing",
  );
}

Widget tileMicrophoneSvgIcon() {
  //{required bool isReaded}
  return SvgPicture.asset(
    microphoneFilled,
    width: 25.w,
    height: 18.h,
    colorFilter: ColorFilter.mode(
      //isReaded?
      kGrey,
      //: buttonSmallTextColor,
      BlendMode.srcIn,
    ),
  );
}

Widget tileDocumentSvgIcon() {
  return SvgPicture.asset(
    document,
    width: 25.w,
    height: 20.h,
    colorFilter: ColorFilter.mode(
      kGrey,
      BlendMode.srcIn,
    ),
  );
}
