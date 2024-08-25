import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/status_methods.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/status/status_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/status_appbar.dart';
import 'package:video_player/video_player.dart';

class FileShowPage extends StatefulWidget {
  const FileShowPage(
      {super.key,
      this.fileToShow,
      required this.fileType,
      this.statusModel,
      required this.pageType,
      this.chatModel,
      this.groupModel,
      this.receiverContactName,
      this.isGroup, required this.rootContext});
  final File? fileToShow;
  final FileType fileType;
  final StatusModel? statusModel;
  final PageTypeEnum? pageType;
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final String? receiverContactName;
  final bool? isGroup;
  final BuildContext rootContext;

  @override
  State<FileShowPage> createState() => _FileShowPageState();
}

class _FileShowPageState extends State<FileShowPage> {
  TextEditingController fileCaptionController = TextEditingController();

  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    log('File to show: ${widget.fileToShow}');
    log('File type: ${widget.fileType}');

    if (widget.fileToShow != null) {
      log('Not null');
      if (widget.fileType == FileType.video) {
        log('Initializing video player');
        videoPlayerController = VideoPlayerController.file(widget.fileToShow!)
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
          widget.fileToShow != null
              ? widget.fileType == FileType.image
                  ? Center(
                      child: Image.file(
                        widget.fileToShow!,
                        fit: BoxFit.contain,
                      ),
                    )
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: darkScaffoldColor,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, bottom: 15.h, top: 20.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.sp),
                          border: Border.all(
                            color: iconGreyColor,
                          ),
                        ),
                        child: TextFieldCommon(
                          maxLines: 20,
                          border: InputBorder.none,
                          cursorColor: buttonSmallTextColor,
                          controller: fileCaptionController,
                          textAlign: TextAlign.center,
                          hintText: "Add caption",
                          style: TextStyle(color: kWhite),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (widget.pageType == PageTypeEnum.chatStatus) {
                          StatusModel statusModel =
                              await StatusMethods.newStatusUploadMethod(
                            fileToShow: widget.fileToShow,
                            currentStatusModel: widget.statusModel,
                            fileCaption: fileCaptionController.text,
                            statusDuration: videoPlayerController != null
                                ? videoPlayerController!.value.duration
                                    .toString()
                                : "10",
                            statusType: widget.fileType == FileType.video
                                ? StatusType.video
                                : StatusType.image,
                          );
                          if (mounted) {
                            context.read<StatusBloc>().add(StatusUploadEvent(
                                  statusModel: statusModel,
                                ));
                          }
                        } else if (widget.pageType ==
                            PageTypeEnum.messagingPage) {
                          if (widget.fileType == FileType.video &&
                              widget.isGroup != null) {
                            context.read<MessageBloc>().add(
                                  VideoMessageSendEvent(
                                    context: widget.rootContext,
                                    messageCaption: fileCaptionController.text,
                                    videoFile: widget.fileToShow,
                                    isGroup: widget.isGroup!,
                                    receiverContactName:
                                        widget.receiverContactName ?? "",
                                    receiverID:
                                        widget.chatModel?.receiverID ?? "",
                                    imageSource: ImageSource.camera,
                                    chatModel: widget.chatModel,
                                    groupModel: widget.groupModel,
                                  ),
                                );
                          } else {
                            context.read<MessageBloc>().add(
                                  PhotoMessageSendEvent(
                                    context: widget.rootContext,
                                    messageCaption: fileCaptionController.text,
                                    imageFile: widget.fileToShow,
                                    isGroup: widget.isGroup!,
                                    receiverContactName:
                                        widget.receiverContactName ?? "",
                                    receiverID:
                                        widget.chatModel?.receiverID ?? "",
                                    imageSource: ImageSource.camera,
                                    chatModel: widget.chatModel,
                                    groupModel: widget.groupModel,
                                  ),
                                );
                          }
                        }
                        if (mounted) {
                          Navigator.pop(context);
                          context
                              .read<StatusBloc>()
                              .add(const FileResetEvent());
                        }
                      },
                      icon: sendIconWidget(),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
