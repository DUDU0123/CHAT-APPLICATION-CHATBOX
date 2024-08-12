import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/message_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/circle_image_show_prevent_error_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AudioMessageContentShowWidget extends StatefulWidget {
  const AudioMessageContentShowWidget({
    super.key,
    required this.message,
    required this.audioPlayers,
  });
  final MessageModel message;
  final Map<String, AudioPlayer> audioPlayers;

  @override
  State<AudioMessageContentShowWidget> createState() =>
      _AudioMessageContentShowWidgetState();
}

class _AudioMessageContentShowWidgetState
    extends State<AudioMessageContentShowWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<UserModel?>(
            stream: widget.message.senderID != null
                ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                    userId: widget.message.senderID!)
                : null,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return nullImageReplaceWidget(
                    containerRadius: 50, context: context);
              }
              return circleImageShowPreventErrorWidget(
                containerSize: 50,
                image: snapshot.data!.userProfileImage ?? '',
              );
            }),
        SizedBox(width: 10.w),

        GestureDetector(
          onTap: () async {
            if (await checkAssetExists(widget.message.message!)) {
              await widget.audioPlayers[widget.message.message]
                ?.setUrl(widget.message.message ?? '');

            final isPlaying =
                widget.audioPlayers[widget.message.message]?.playing ?? false;
            if (isPlaying) {
              await widget.audioPlayers[widget.message.message]?.pause();
              if (mounted) {
                context.read<MessageBloc>().add(
                    AudioPlayerPlayStateChangedEvent(
                        widget.message.message!, false));
              }
            } else {
              await widget.audioPlayers[widget.message.message]!.play();
              if (mounted) {
                context.read<MessageBloc>().add(
                    AudioPlayerPlayStateChangedEvent(
                        widget.message.message!, true));
              }
            }
            }else{
              if (mounted) {
                simpleDialogBox(context: context, title: "Can't play this audio, it is deleted", buttonText: "Ok", onPressed: () {
                Navigator.pop(context);
              },);
              }
            }
            
          },
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              final isPlaying =
                  state.audioPlayingStates[widget.message.message] ?? false;
              return Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 40.sp,
                color: kWhite,
              );
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              final currentPosition =
                  state.audioPositions[widget.message.message] ?? Duration.zero;
              final duration =
                  state.audioDurations[widget.message.message] ?? Duration.zero;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: currentPosition.inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      final newPosition = Duration(seconds: value.toInt());
                      widget.audioPlayers[widget.message.message]
                          ?.seek(newPosition);
                      context.read<MessageBloc>().add(
                          AudioPlayerPositionChangedEvent(
                              widget.message.message!, newPosition));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: TimeProvider.formatDuration(currentPosition) !=
                            "00:00"
                        ? TextWidgetCommon(
                            text: TimeProvider.formatDuration(currentPosition),
                            textColor: kWhite,
                            fontSize: 8.sp,
                          )
                        : TextWidgetCommon(
                            text: TimeProvider.formatDuration(duration),
                            textColor: kWhite,
                            fontSize: 8.sp,
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
