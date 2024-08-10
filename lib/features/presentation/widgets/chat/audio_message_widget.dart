
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/message_container_user_details.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/message_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/message/audio_message_content_show_widget.dart';

Widget audioMessageWidget({
  required MessageModel message,
  required BuildContext context,
  required Map<String, AudioPlayer> audioPlayers,
  required GroupModel? groupModel,
  required bool isGroup,
  required void Function({required MessageModel message}) onSwipeMethod,
}) {
  audioPlayers[message.message]?.durationStream.listen((duration) {
    if (duration != null) {
      context
          .read<MessageBloc>()
          .add(AudioPlayerDurationChangedEvent(message.message!, duration));
    }
  });
  audioPlayers[message.message]?.positionStream.listen((position) {
    context
        .read<MessageBloc>()
        .add(AudioPlayerPositionChangedEvent(message.message!, position));
  });
  audioPlayers[message.message]?.playerStateStream.listen((playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      context
          .read<MessageBloc>()
          .add(AudioPlayerCompletedEvent(message.message!));
    }
  });
 
  return Dismissible(
    confirmDismiss: (direction) async {
      await Future.delayed(const Duration(milliseconds: 2));
      onSwipeMethod(message: message);
      return false;
    },
    key: UniqueKey(),
    child: Container(
      // height: !isGroup?
      //  70.h
      //  :null,
      height: null,
      width: screenWidth(context: context) / 1.26,
      margin: EdgeInsets.symmetric(vertical: 3.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        gradient: checkIsIncomingMessage(
          isGroup: isGroup,
          message: message,
          groupModel: groupModel,
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
        children: [
          isGroup
              ? messageContainerUserDetails(message: message)
              : zeroMeasureWidget,
          AudioMessageContentShowWidget(
            audioPlayers: audioPlayers,
            message: message,
          ),
        ],
      ),
    ),
  );
}

