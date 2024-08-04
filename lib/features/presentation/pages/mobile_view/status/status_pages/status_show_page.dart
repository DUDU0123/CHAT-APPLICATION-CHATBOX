import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/status/status_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/build_status_item_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/status_appbar.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusShowPage extends StatefulWidget {
  const StatusShowPage({super.key, required this.statusModel});
  final StatusModel statusModel;

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
              },
              storyItems: buildStatusItems(
                controller: controller,
                statusModel: widget.statusModel,
                context: context,
              ),
              controller: controller,
            ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: currentIndexNotifier,
              builder: (context, currentIndex, _) {
                log(widget.statusModel.statusList![currentIndex].statusUploadedTime
                    .toString());
                return StreamBuilder<UserModel?>(
                    stream: widget.statusModel.statusUploaderId != null
                        ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                            userId: widget.statusModel.statusUploaderId!)
                        : null,
                    builder: (context, snapshot) {
                      return statusAppBar(
                        context: context,
                        statusUploaderImage: snapshot.data?.userProfileImage,
                        userName: widget.statusModel.statusUploaderId ==
                                firebaseAuth.currentUser?.uid
                            ? "My status"
                            : snapshot.data?.contactName ??
                                snapshot.data?.userName ??
                                '',
                        howHours: widget.statusModel.statusList != null
                            ? TimeProvider.getRelativeTime(widget.statusModel
                                .statusList![currentIndex].statusUploadedTime
                                .toString())
                            : '',
                        deleteMethod: () {
                          final uploadedStatusId = widget.statusModel
                              .statusList?[currentIndex].uploadedStatusId;
                          widget.statusModel.statusId != null
                              ? uploadedStatusId != null
                                  ? context
                                      .read<StatusBloc>()
                                      .add(StatusDeleteEvent(
                                        statusModelId: widget.statusModel.statusId!,
                                        uploadedStatusId: uploadedStatusId,
                                      ))
                                  : null
                              : null;
                          // Remove the deleted status from the list
                          widget.statusModel.statusList!.removeAt(currentIndex);
                          Navigator.pop(context);
                        },
                        shareMethod: () {
                           Navigator.pop(context);
                          widget.statusModel.statusList != null
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectContactPage(
                                      isGroup: false,
                                      pageType: PageTypeEnum.toSendPage,
                                      uploadedStatusModel:
                                          widget.statusModel.statusList![currentIndex],
                                          statusModel: widget.statusModel,
                                          uploadedStatusModelID: widget.statusModel.statusList![currentIndex].uploadedStatusId,
                                    ),
                                  ))
                              : null;
                             
                        },
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
