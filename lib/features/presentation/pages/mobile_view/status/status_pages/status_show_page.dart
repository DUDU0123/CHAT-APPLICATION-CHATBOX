import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/status/status_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/build_status_item_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/status_appbar_show_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/status_viewers_show_widgets.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusShowPage extends StatefulWidget {
  const StatusShowPage(
      {super.key, required this.statusModel, required this.isCurrentUser, this.currentUserId});
  final StatusModel statusModel;
  final String? currentUserId;
  final bool isCurrentUser;

  @override
  State<StatusShowPage> createState() => _StatusShowPageState();
}

class _StatusShowPageState extends State<StatusShowPage> {
  final StoryController controller = StoryController();

  final ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (widget.statusModel.statusList != null &&
              widget.statusModel.statusList!.isNotEmpty)
            StoryView(
              onComplete: () {
                Navigator.pop(context);
              },
              onVerticalSwipeComplete: (p0) {
                Navigator.pop(context);
              },
              onStoryShow: (s, i) {
                currentIndexNotifier.value = i;
             widget.currentUserId!=null?   context.read<StatusBloc>().add(
                      UpdateStatusViewersList(
                        statusModel: widget.statusModel,
                        uploadedStatusModel: widget.statusModel.statusList![i],
                        viewerId: widget.currentUserId!,
                      ),
                    ):null;
                log(widget.statusModel.statusList![currentIndexNotifier.value]
                    .viewers!.length
                    .toString());
              },
              storyItems: buildStatusItems(
                controller: controller,
                statusModel: widget.statusModel,
                context: context,
              ),
              controller: controller,
            ),
          widget.isCurrentUser
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      final viewersList = widget.statusModel
                          .statusList![currentIndexNotifier.value].viewers
                          ?.where((viewerId) =>
                              viewerId != firebaseAuth.currentUser?.uid)
                          .toList();

                      statusViewersListShowBottomSheet(
                        context: context,
                        viewersList: viewersList,
                      );
                    },
                    child: viewersShowButton(
                      viewersLength: widget
                                  .statusModel
                                  .statusList?[currentIndexNotifier.value]
                                  .viewers !=
                              null
                          ? widget
                                  .statusModel
                                  .statusList![currentIndexNotifier.value]
                                  .viewers!
                                  .length -
                              1
                          : 0,
                    ),
                  ),
                )
              : zeroMeasureWidget,
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: currentIndexNotifier,
              builder: (context, currentIndex, _) {
                log(widget
                    .statusModel.statusList![currentIndex].statusUploadedTime
                    .toString());
                return statusAppBarShowWidget(
                  isCurrentUser: widget.isCurrentUser,
                  statusList: widget.statusModel.statusList,
                  statusModel: widget.statusModel,
                  statusUploaderId: widget.statusModel.statusUploaderId,
                  currentIndex: currentIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
