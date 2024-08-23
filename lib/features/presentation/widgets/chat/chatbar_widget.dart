import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/message_methods.dart';
import 'package:official_chatbox_application/core/utils/video_photo_from_camera_source_method.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/message/reply_message_small_widgets.dart';
import 'package:provider/provider.dart';

class ChatBarWidget extends StatefulWidget {
  ChatBarWidget({
    super.key,
    required this.messageController,
    required this.isImojiButtonClicked,
    this.chatModel,
    required this.scrollController,
    required this.recorder,
    this.receiverContactName,
    this.groupModel,
    required this.isGroup,
    required this.focusNode,
    required this.replyMessage,
    this.onCancelReply,
  });
  final TextEditingController messageController;
  bool isImojiButtonClicked;
  final ScrollController scrollController;
  final FlutterSoundRecorder recorder;
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final String? receiverContactName;
  final bool isGroup;
  final FocusNode focusNode;
  final MessageModel? replyMessage;
  final void Function()? onCancelReply;

  @override
  State<ChatBarWidget> createState() => _ChatBarWidgetState();
}

class _ChatBarWidgetState extends State<ChatBarWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.sp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.replyMessage != null)
              buildReplyWidget(
                message: widget.replyMessage!,
                onCancelReply: widget.onCancelReply,
                context: context,
              ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    width: screenWidth(context: context) / 1.2,
                    decoration: BoxDecoration(
                      borderRadius: widget.replyMessage != null
                          ? BorderRadius.only(
                              bottomRight: Radius.circular(20.sp),
                              bottomLeft: Radius.circular(20.sp))
                          : BorderRadius.circular(20.sp),
                      color: const Color.fromARGB(255, 39, 52, 78),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.focusNode.unfocus();
                            Provider.of<CommonProvider>(context, listen: false).setEmojiPickerStatus();
                          },
                          icon: SvgPicture.asset(
                            width: 25.w,
                            height: 25.h,
                            colorFilter: ColorFilter.mode(
                                iconGreyColor, BlendMode.srcIn),
                            smileIcon,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Focus(
                                onFocusChange: (hasFocus) {
                                  if (hasFocus &&
                                      Provider.of<CommonProvider>(context,
                                              listen: false)
                                          .isEmojiPickerOpened) {
                                    Provider.of<CommonProvider>(context,
                                            listen: false)
                                        .setEmojiPickerStatus();
                                  }
                                },
                                child: TextFieldCommon(
                                  focusNode: widget.focusNode,
                                  style: fieldStyle(context: context).copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: kWhite,
                                  ),
                                  onChanged: (value) {
                                    log(widget.messageController.text);

                                    context.read<MessageBloc>().add(
                                          MessageTypedEvent(
                                            textLength: value.length,
                                          ),
                                        );
                                  },
                                  hintText: "Type message...",
                                  maxLines: 5,
                                  controller: widget.messageController,
                                  textAlign: TextAlign.start,
                                  border: InputBorder.none,
                                  cursorColor: buttonSmallTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                context
                                    .read<MessageBloc>()
                                    .add(AttachmentIconClickedEvent());
                              },
                              icon: Icon(
                                Icons.attach_file,
                                color: iconGreyColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                videoOrPhotoTakeFromCameraSourceMethod(
                                  isGroup: widget.isGroup,
                                  groupModel: widget.groupModel,
                                  receiverContactName:
                                      widget.receiverContactName,
                                  chatModel: widget.chatModel,
                                  context: context,
                                );
                              },
                              icon: SvgPicture.asset(
                                width: 25.w,
                                height: 25.h,
                                colorFilter: ColorFilter.mode(
                                  iconGreyColor,
                                  BlendMode.srcIn,
                                ),
                                cameraIcon,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //kWidth2,
                  Expanded(
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: buttonSmallTextColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () async {
                            if (widget.messageController.text.isNotEmpty) {
                              cancelReply(context: context);

                              MessageMethods.sendMessage(
                                replyToMessage: widget.replyMessage,
                                isGroup: widget.isGroup,
                                groupModel: widget.groupModel,
                                receiverContactName: widget.receiverContactName,
                                chatModel: widget.chatModel,
                                context: context,
                                messageController: widget.messageController,
                                scrollController: widget.scrollController,
                              );
                            } else {
                              context.read<MessageBloc>().add(
                                    AudioRecordToggleEvent(
                                      isGroup: widget.isGroup,
                                      groupModel: widget.groupModel,
                                      receiverID:
                                          widget.chatModel?.receiverID ?? '',
                                      receiverContactName:
                                          widget.receiverContactName ?? '',
                                      chatModel: widget.chatModel,
                                      recorder: widget.recorder,
                                    ),
                                  );
                            }
                          },
                          icon: BlocBuilder<MessageBloc, MessageState>(
                            builder: (context, state) {
                              return !state.isRecording!
                                  ? SvgPicture.asset(
                                      width: 24.w,
                                      height: 24.h,
                                      colorFilter: ColorFilter.mode(
                                          kBlack, BlendMode.srcIn),
                                      state.isTyped ??
                                              false ||
                                                  widget.messageController.text
                                                      .isNotEmpty
                                          ? sendIcon
                                          : microphoneFilled,
                                    )
                                  : Icon(
                                      Icons.stop,
                                      color: kBlack,
                                    );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
