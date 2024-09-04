import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:just_audio/just_audio.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/emoji_select.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/attachment_list_container_vertical.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/chat_room_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/chat_room_bg_image_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/chatbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/message_listing_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/message/reply_message_small_widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({
    super.key,
    required this.userName,
    required this.isGroup,
    this.chatModel,
    this.groupModel,
    this.receiverID,
  });
  final String userName;
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final bool isGroup;
  final String? receiverID;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final Map<String, VideoPlayerController> videoControllers = {};
  final Map<String, AudioPlayer> audioPlayers = {};
  final recorder = FlutterSoundRecorder();
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<Duration?>? _positionSubscription;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.chatModel != null) {
      context.read<ChatBloc>().add(
            CheckIsBlockedUserEvent(
              currentUserId: firebaseAuth.currentUser?.uid,
              receiverID: widget.chatModel?.receiverID,
            ),
          );
    }
    !widget.isGroup
        ? CommonDBFunctions.updateChatOpenStatus(
            widget.chatModel?.receiverID ?? '',
            widget.chatModel?.chatID ?? '',
            true)
        : null;
  }
  

  @override
  void dispose() {
    focusNode.dispose();
    videoControllers.forEach((key, controller) => controller.dispose());
    audioPlayers.forEach((key, controller) => controller.dispose());
    messageController.dispose();
    scrollController.dispose();
    recorder.closeRecorder();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    !widget.isGroup
        ? CommonDBFunctions.updateChatOpenStatus(
            widget.chatModel?.receiverID ?? '',
            widget.chatModel?.chatID ?? '',
            false)
        : null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MessageBloc>().add(GetAllMessageEvent(
          isGroup: widget.isGroup,
          groupModel: widget.groupModel,
          currentUserId: firebaseAuth.currentUser?.uid ?? '',
          receiverId: widget.receiverID ?? '',
          chatId: widget.chatModel?.chatID ?? "",
        ));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: !widget.isGroup
            ? oneToOneChatAppBarWidget(
                context: context,
                receiverID: widget.receiverID ?? "",
                chatModel: widget.chatModel,
                isGroup: false,
                userName: widget.userName,
              )
            : groupChatAppBarWidget(
                groupModel: widget.groupModel,
                isGroup: true,
                context: context,
              ),
      ),
      body: Stack(
        children: [
          chatRoomBackgroundImageWidget(
            context: context,
            chatModel: widget.chatModel,
            groupModel: widget.groupModel,
          ),
          Column(
            children: [
              Expanded(
                  child: BlocConsumer<MessageBloc, MessageState>(
                listener: (context, state) {
                  if (state is MessageLoadingState) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return commonAnimationWidget(
                          context: context,
                          isTextNeeded: false,
                          lottie: settingsLottie,
                        );
                      },
                    );
                  }
                },
                builder: (context, state) {
                  return messageListingWidget(
                    focusNode: focusNode,
                    rootContext: context,
                    isGroup: widget.isGroup,
                    receiverID: widget.receiverID,
                    chatModel: widget.chatModel,
                    audioPlayers: audioPlayers,
                    scrollController: scrollController,
                    videoControllers: videoControllers,
                    state: state,
                  );
                },
              )),
              widget.isGroup &&
                      (!widget.groupModel!.membersPermissions!
                              .contains(MembersGroupPermission.sendMessages) &&
                          !widget.groupModel!.groupAdmins!
                              .contains(firebaseAuth.currentUser?.uid)) &&
                      widget.groupModel!.groupMembers!
                          .contains(firebaseAuth.currentUser?.uid)
                  ? messageSendRestrictingWidget(
                      context: context, text: "Only Admins can send messages")
                  : widget.isGroup &&
                          !widget.groupModel!.groupMembers!
                              .contains(firebaseAuth.currentUser?.uid)
                      ? messageSendRestrictingWidget(
                          context: context,
                          text: "You're no longer a member in this group")
                      : widget.chatModel != null
                          ?FutureBuilder<Map<String, bool>>(
                              future: Future.wait([
                                CommonDBFunctions.checkIfIsBlocked(
                                  receiverId: widget.chatModel?.receiverID,
                                  currentUserId: firebaseAuth.currentUser?.uid,
                                ),
                                CommonDBFunctions.checkIfIsBlocked(
                                  receiverId: firebaseAuth.currentUser?.uid,
                                  currentUserId: widget.chatModel?.receiverID,
                                ),
                              ]).then((results) {
                                return {
                                  "isReceiverBlocked": results[
                                      0], // True if receiver blocked the sender
                                  "isSenderBlocked": results[
                                      1], // True if sender is blocked by the receiver
                                };
                              }),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return chatMessageBar(
                                    focusNode: focusNode,
                                    recorder: recorder,
                                    messageController: messageController,
                                    isGroup: widget.isGroup,
                                    context: context,
                                    scrollController: scrollController,
                                    chatModel: widget.chatModel,
                                    groupModel: widget.groupModel,
                                    receiverContactName: widget.userName,
                                  );
                                }

                                final isReceiverBlocked =
                                    snapshot.data!['isReceiverBlocked'] ??
                                        false;
                                final isSenderBlocked =
                                    snapshot.data!['isSenderBlocked'] ?? false;

                                if (isSenderBlocked) {
                                  return messageSendRestrictingWidget(
                                    context: context,
                                    text: "You blocked this chat",
                                  );
                                } else if (isReceiverBlocked) {
                                  return messageSendRestrictingWidget(
                                    context: context,
                                    text: "You are blocked",
                                  );
                                } else {
                                  return chatMessageBar(
                                    focusNode: focusNode,
                                    recorder: recorder,
                                    messageController: messageController,
                                    isGroup: widget.isGroup,
                                    context: context,
                                    scrollController: scrollController,
                                    chatModel: widget.chatModel,
                                    groupModel: widget.groupModel,
                                    receiverContactName: widget.userName,
                                  );
                                }
                              },
                            )
                          : chatMessageBar(
                              focusNode: focusNode,
                              recorder: recorder,
                              messageController: messageController,
                              isGroup: widget.isGroup,
                              context: context,
                              scrollController: scrollController,
                              chatModel: widget.chatModel,
                              groupModel: widget.groupModel,
                              receiverContactName: widget.userName,
                            ),
            ],
          ),
          Positioned(
            bottom: 60.h,
            right: screenWidth(context: context) / 3.3,
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.isAttachmentListOpened ?? false,
                  replacement: zeroMeasureWidget,
                  child: AttachmentListContainerVertical(
                    isGroup: widget.isGroup,
                    rootContext: context,
                    groupModel: widget.groupModel,
                    receiverContactName: widget.userName,
                    chatModel: widget.chatModel,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget messageSendRestrictingWidget({
    required BuildContext context,
    required String text,
  }) {
    return Container(
      width: screenWidth(context: context),
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
      ),
      color: darkSwitchColor.withOpacity(0.3),
      child: TextWidgetCommon(
        text: text,
        textColor: buttonSmallTextColor,
        textAlign: TextAlign.center,
        fontSize: 14.sp,
      ),
    );
  }
}

Widget chatMessageBar({
  required FocusNode focusNode,
  required FlutterSoundRecorder recorder,
  required TextEditingController messageController,
  required bool isGroup,
  required BuildContext context,
  GroupModel? groupModel,
  String? receiverContactName,
  required ScrollController scrollController,
  ChatModel? chatModel,
}) {
  return Column(
    children: [
      ChatBarWidget(
        replyMessage: Provider.of<CommonProvider>(context).replyMessage,
        onCancelReply: () {
          cancelReply(context: context);
        },
        focusNode: focusNode,
        isGroup: isGroup,
        groupModel: groupModel,
        receiverContactName: receiverContactName,
        recorder: recorder,
        scrollController: scrollController,
        chatModel: chatModel,
        isImojiButtonClicked: false,
        messageController: messageController,
      ),
      Provider.of<CommonProvider>(context).isEmojiPickerOpened
          ? emojiSelect(
              textEditingController: messageController,
            )
          : zeroMeasureWidget,
    ],
  );
}
