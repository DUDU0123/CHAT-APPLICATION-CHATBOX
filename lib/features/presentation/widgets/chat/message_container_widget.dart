
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/audio_message_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/contact_message_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/different_message_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/message_container_user_details.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/message_status_show_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/message/reply_message_small_widgets.dart';
import 'package:video_player/video_player.dart';

class MessageContainerWidget extends StatefulWidget {
  const MessageContainerWidget({
    super.key,
    required this.message,
    this.chatModel,
    this.groupModel,
    required this.videoControllers,
    required this.audioPlayers,
    required this.receiverID,
    required this.rootContext,
    required this.isGroup,
    required this.onSwipeMethod,
  });
  final MessageModel message;
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final Map<String, VideoPlayerController> videoControllers;
  final Map<String, AudioPlayer> audioPlayers;
  final String receiverID;
  final BuildContext rootContext;
  final bool isGroup;
  final void Function({required MessageModel message}) onSwipeMethod;

  @override
  State<MessageContainerWidget> createState() => _MessageContainerWidgetState();
}

class _MessageContainerWidgetState extends State<MessageContainerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.message.message == null) {
      return zeroMeasureWidget;
    }
    return Align(
      alignment: checkIsIncomingMessage(
        isGroup: widget.isGroup,
        message: widget.message,
        groupModel: widget.groupModel,
      )
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Stack(
        children: [
          widget.message.messageType == MessageType.audio
              ? audioMessageWidget(
                  onSwipeMethod: widget.onSwipeMethod,
                  context: widget.rootContext,
                  audioPlayers: widget.audioPlayers,
                  message: widget.message,
                  groupModel: widget.groupModel,
                  isGroup: widget.isGroup,
                )
              : Dismissible(
                  confirmDismiss: (direction) async {
                    await Future.delayed(const Duration(milliseconds: 2));
                    widget.onSwipeMethod(message: widget.message);
                    return false;
                  },
                  key: UniqueKey(),
                  child: Column(
                    children: [
                      Container(
                        width: getMessageContainerWidth(
                            context, widget.message, widget.isGroup),
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        padding: widget.message.messageType ==
                                    MessageType.photo ||
                                widget.message.messageType == MessageType.video
                            ? EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 5.h)
                            : EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                top: widget.isGroup ? 5.h : 10.h,
                                bottom: 15.h,
                              ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.sp),
                          gradient: checkIsIncomingMessage(
                            isGroup: widget.isGroup,
                            message: widget.message,
                            groupModel: widget.groupModel,
                          )
                              ? LinearGradient(
                                  colors: [
                                    darkSwitchColor,
                                    lightLinearGradientColorTwo,
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    kBlack,
                                    darkSwitchColor,
                                  ],
                                ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.message.replyToMessage != null
                                ? GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: widget.message.replyToMessage
                                                  ?.messageType ==
                                              MessageType.text
                                          ? widget.message.message!.length > 10
                                              ? screenWidth(context: context) /
                                                  3
                                              : null
                                          : screenWidth(context: context) / 1.4,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.sp),
                                        border: Border(
                                          left: BorderSide(
                                            color: iconGreyColor,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: replyMessageTypeWidget(
                                        message: widget.message.replyToMessage!,
                                      ),
                                    ),
                                  )
                                : zeroMeasureWidget,
                            widget.isGroup
                                ? messageContainerUserDetails(
                                    message: widget.message,
                                  )
                                : zeroMeasureWidget,
                            widget.isGroup ? kHeight5 : zeroMeasureWidget,
                            widget.message.messageType == MessageType.text
                                ? textMessageWidget(
                                    message: widget.message, context: context)
                                : widget.message.messageType ==
                                        MessageType.photo
                                    ? photoMessageShowWidget(
                                        isGroup: widget.isGroup,
                                        groupModel: widget.groupModel,
                                        receiverID: widget.receiverID,
                                        message: widget.message,
                                        chatModel: widget.chatModel,
                                        context: context,
                                      )
                                    : widget.videoControllers[
                                                widget.message.message!] !=
                                            null
                                        ?
                                        //  zeroMeasureWidget
                                        videoMessageShowWidget(
                                            isGroup: widget.isGroup,
                                            groupModel: widget.groupModel,
                                            receiverID: widget.receiverID,
                                            chatModel: widget.chatModel,
                                            videoControllers:
                                                widget.videoControllers,
                                            context: context,
                                            message: widget.message,
                                          )
                                        : widget.message.messageType ==
                                                MessageType.contact
                                            ? contactMessageWidget(
                                                context: context,
                                                message: widget.message,
                                              )
                                            : widget.message.messageType ==
                                                    MessageType.document
                                                ? documentMessageWidget(
                                                    message: widget.message,
                                                  )
                                                : widget.message.messageType ==
                                                        MessageType.location
                                                    ? locationMessageWidget(
                                                        message: widget.message,
                                                      )
                                                    : commonAnimationWidget(
                                                        context: context,
                                                        isTextNeeded: false,
                                                      ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          messageStatusShowWidget(
            isCurrentUserMessage: checkIsIncomingMessage(
              isGroup: widget.isGroup,
              message: widget.message,
              groupModel: widget.groupModel,
            ),
            message: widget.message,
          ),
        ],
      ),
    );
  }
}

double? getMessageContainerWidth(
    BuildContext context, MessageModel message, bool isGroup) {
  if (isGroup) {
    return screenWidth(context: context) / 1.4;
  }
  if (message.messageType == MessageType.text && message.message!.length < 10) {
    return screenWidth(context: context) / 4;
  }
  if (message.messageType == MessageType.text && message.message!.length < 28) {
    return message.messageType == MessageType.video
        ? screenWidth(context: context) / 2
        : null;
  }
  return message.message!.length > 20
      ? screenWidth(context: context) / 1.3
      : message.message!.length < 10
          ? 90.w
          : screenWidth(context: context) / 1.4;
}
