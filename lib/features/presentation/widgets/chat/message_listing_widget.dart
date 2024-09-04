import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/message_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/message_page_date_show_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/message/reply_message_small_widgets.dart';
import 'package:video_player/video_player.dart';

Widget messageListingWidget({
  required MessageState state,
  required ScrollController scrollController,
  ChatModel? chatModel,
  String? receiverID,
  required Map<String, AudioPlayer> audioPlayers,
  required Map<String, VideoPlayerController> videoControllers,
  required BuildContext rootContext,
  required bool isGroup,
  GroupModel? groupModel,
  required FocusNode focusNode,
}) {

  return StreamBuilder<List<MessageModel>>(
    stream: state.messages,
    builder: (context, snapshot) {
      if (snapshot.data == null) {
        return zeroMeasureWidget;
      }

      final messages = snapshot.data!;
      List<Widget> messageWidgets = [];
      String? currentDate;

      // Check if any audio is playing
      bool isAnyAudioPlaying = audioPlayers.values.any((player) => player.playing);

      if (!isAnyAudioPlaying) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(
            scrollController.position.maxScrollExtent,
          );
        });
      }

      for (int i = 0; i < messages.length; i++) {
        final message = messages[i];
        final messageDate = DateProvider.formatMessageDateTime(
          isInsideChat: true,
          messageDateTimeString: message.messageTime.toString(),
        );

        if (currentDate != messageDate) {
          currentDate = messageDate;
          messageWidgets.add(
            Center(
              child: MessagePageDateShowWidget(date: messageDate),
            ),
          );
        }

        if (message.messageType == MessageType.video &&
            !videoControllers.containsKey(message.message) &&
            message.message != null) {
          videoControllers[message.message!] = VideoPlayerController.networkUrl(
            Uri.parse(message.message!),
          )..initialize().then((_) {});
        }
        if (message.messageType == MessageType.audio &&
            !audioPlayers.containsKey(message.message)) {
          final player = AudioPlayer();
          audioPlayers[message.message!] = player;

          player.durationStream.listen((duration) {
            if (duration != null) {
              context.read<MessageBloc>().add(
                  AudioPlayerDurationChangedEvent(message.message!, duration));
            }
          });
          player.positionStream.listen((position) {
            context.read<MessageBloc>().add(
                AudioPlayerPositionChangedEvent(message.message!, position));
          });
          player.playingStream.listen((isPlaying) {
            context.read<MessageBloc>().add(
                AudioPlayerPlayStateChangedEvent(message.message!, isPlaying));
          });
        }
        bool isSelected =
            state.selectedMessageIds?.contains(message.messageId) ?? false;
        messageWidgets.add(
          GestureDetector(
            onLongPress: () {
              context.read<MessageBloc>().add(
                    MessageSelectedEvent(
                      isGroup: isGroup,
                      context: context,
                      messageModel: message,
                      chatModel: chatModel,
                      groupModel: groupModel,
                    ),
                  );
            },
            onTap: () {
              if (isSelected) {
                context
                    .read<MessageBloc>()
                    .add(UnSelectEvent(messageId: message.messageId));
              }
            },
            child: BlocSelector<MessageBloc, MessageState, bool>(
              selector: (state) {
                return state.selectedMessageIds?.contains(message.messageId) ??
                    false;
              },
              builder: (context, state) {
                return Container(
                    width: screenWidth(context: context),
                    color: state
                        ? buttonSmallTextColor.withOpacity(0.3)
                        : kTransparent,
                    child: MessageContainerWidget(
                      onSwipeMethod: ({required message}) {
                        replyToMessage(
                            message: message,
                            focusNode: focusNode,
                            context: context);
                      },
                      isGroup: isGroup,
                      rootContext: rootContext,
                      receiverID: receiverID ?? '',
                      groupModel: groupModel,
                      message: message,
                      audioPlayers: audioPlayers,
                      videoControllers: videoControllers,
                    ));
              },
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        controller: scrollController,
        itemCount: messageWidgets.length,
        itemBuilder: (context, index) {
          return messageWidgets[index];
        },
      );
    },
  );
}
