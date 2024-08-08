// import 'dart:developer';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/photo_view_section.dart';
import 'package:video_player/video_player.dart';

class PhotoVideoShowPage extends StatefulWidget {
  const PhotoVideoShowPage({
    super.key,
    this.fileToShowUrl,
    required this.fileType,
  });
  final String? fileToShowUrl;
  final FileType fileType;

  @override
  State<PhotoVideoShowPage> createState() => _PhotoVideoShowPageState();
}

class _PhotoVideoShowPageState extends State<PhotoVideoShowPage> {
  TextEditingController fileCaptionController = TextEditingController();

  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    log('File to show: ${widget.fileToShowUrl}');
    log('File type: ${widget.fileType}');

    if (widget.fileToShowUrl != null) {
      log('Not null');
      if (widget.fileType == FileType.video) {
        log('Initializing video player');
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.fileToShowUrl!))
              ..initialize().then((_) {
                log('Video player initialized');
              }).catchError((error) {
                log('Error initializing video player: $error');
              });
        videoPlayerController?.addListener(_videoPlayerListener);
      } else {
        log('File type is not video');
      }
    } else {
      log('No file to show');
    }
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(_videoPlayerListener);
    videoPlayerController?.dispose();
    fileCaptionController.dispose();
    super.dispose();
  }

  void _videoPlayerListener() {
    if (videoPlayerController == null) {
      return;
    }
    if (videoPlayerController?.value.position ==
        videoPlayerController?.value.duration) {
      context.read<MessageBloc>().add(VideoMessageCompleteEvent());
    } else if (videoPlayerController!.value.isPlaying) {
      context.read<MessageBloc>().add(VideoMessagePlayEvent());
    } else {
      context.read<MessageBloc>().add(VideoMessagePauseEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkScaffoldColor,
      body: Stack(
        children: [
          widget.fileToShowUrl != null
              ? widget.fileType == FileType.image
                  ? PhotoViewSection(imageToShow: widget.fileToShowUrl!)
                  : widget.fileType == FileType.video
                      ? videoPlayerController != null
                          ? VideoPlayer(
                              videoPlayerController!,
                            )
                          : commonErrorWidget(message: "No video selected")
                      : zeroMeasureWidget
              : zeroMeasureWidget,
          videoPlayerController != null
              ? Align(
                  alignment: Alignment.center,
                  child: BlocBuilder<MessageBloc, MessageState>(
                    builder: (context, state) {
                      if (state is MessageLoadingState) {
                        return commonAnimationWidget(
                            context: context, isTextNeeded: false);
                      }
                      IconData icon;
                      if (videoPlayerController?.value.position ==
                          videoPlayerController?.value.duration) {
                        icon = Icons.play_arrow;
                      } else {
                        icon = videoPlayerController!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow;
                      }

                      return GestureDetector(
                        onTap: () {
                          if (videoPlayerController!.value.isPlaying) {
                            videoPlayerController?.pause();
                            context
                                .read<MessageBloc>()
                                .add(VideoMessagePauseEvent());
                          } else {
                            videoPlayerController?.play();
                            context
                                .read<MessageBloc>()
                                .add(VideoMessagePlayEvent());
                          }
                        },
                        child: CircleAvatar(
                          radius: 30.sp,
                          backgroundColor: iconGreyColor.withOpacity(0.5),
                          child: Icon(
                            icon,
                            size: 30.sp,
                            color: kBlack,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : zeroMeasureWidget,
        ],
      ),
    );
  }
}


