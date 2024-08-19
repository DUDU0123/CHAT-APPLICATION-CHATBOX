import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/core/utils/image_picker_method.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/camera_icon_button.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/photo_view_section.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/data_edit_dialog_box.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';

commonUserProfileImageShowingBigCircularContainer({
  required BuildContext context,
  required String userProfileImage,
}) {
  userProfileImageShowWidget(
    context: context,
    imageUrl: userProfileImage,
    radius: 80,
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PhotoViewSection(imageToShow: userProfileImage),
          ));
    },
  );
}

Widget infoPageUserDetailsPart({
  required BuildContext context,
  required UserModel? receiverData,
  required GroupModel? groupData,
  required bool isGroup,
  required String? receiverContactName,
  required TextEditingController groupNameEditController,
}) {
  final isShowableProfileImage = context
          .watch<UserBloc>()
          .state
          .userPrivacySettings?[receiverData?.id]?[userDbProfilePhotoPrivacy] ??
      false;
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            receiverData?.userProfileImage != null && !isGroup
                ? isShowableProfileImage
                    ? commonUserProfileImageShowingBigCircularContainer(
                        context: context,
                        userProfileImage: receiverData!.userProfileImage!,
                      )
                    : nullImageReplaceWidget(
                        containerRadius: 150, context: context)
                : groupData?.groupProfileImage != null
                    ? StreamBuilder<GroupModel?>(
                        stream: CommonDBFunctions.getOneGroupDataByStream(
                            userID: firebaseAuth.currentUser!.uid,
                            groupID: groupData?.groupID ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return nullImageReplaceWidget(
                                containerRadius: 150, context: context);
                          }
                          return commonUserProfileImageShowingBigCircularContainer(
                            context: context,
                            userProfileImage:
                                snapshot.data!.groupProfileImage ?? '',
                          );
                        })
                    : nullImageReplaceWidget(
                        containerRadius: 150, context: context),
            Positioned(
              bottom: 0,
              right: 0,
              child: StreamBuilder<GroupModel?>(
                  stream: isGroup
                      ? CommonDBFunctions.getOneGroupDataByStream(
                          userID: firebaseAuth.currentUser!.uid,
                          groupID: groupData?.groupID ?? '',
                        )
                      : null,
                  builder: (context, snapshot) {
                    bool isAdmin = snapshot.data != null
                        ? snapshot.data!.groupAdmins!
                            .contains(firebaseAuth.currentUser?.uid)
                        : false;
                    bool isEditable = snapshot.data != null
                        ? snapshot.data!.membersPermissions!
                            .contains(MembersGroupPermission.editGroupSettings)
                        : false;
                    if (isEditable || isAdmin) {
                      return CameraIconButton(
                        onPressed: () async {
                          if (groupData != null) {
                            File? pickedImageFile = await pickImage(
                                imageSource: ImageSource.gallery);
                            context.read<GroupBloc>().add(
                                  UpdateGroupEvent(
                                    updatedGroupData: groupData,
                                    groupProfileImage: pickedImageFile,
                                  ),
                                );
                          }
                        },
                      );
                    } else {
                      return zeroMeasureWidget;
                    }
                  }),
            )
          ],
        ),
        kHeight10,
        StreamBuilder<GroupModel?>(
            stream: isGroup
                ? CommonDBFunctions.getOneGroupDataByStream(
                    userID: firebaseAuth.currentUser!.uid,
                    groupID: groupData?.groupID ?? '',
                  )
                : null,
            builder: (context, snapshot) {
              bool isAdmin = snapshot.data != null
                  ? snapshot.data!.groupAdmins!
                      .contains(firebaseAuth.currentUser?.uid)
                  : false;
              bool isEditable = snapshot.data != null
                  ? snapshot.data!.membersPermissions!
                      .contains(MembersGroupPermission.editGroupSettings)
                  : false;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: TextWidgetCommon(
                      textAlign: TextAlign.center,
                      text: !isGroup
                          ? receiverContactName ?? receiverData?.userName ?? ''
                          : snapshot.data?.groupName ?? "",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20.sp,
                    ),
                  ),
                  groupData != null
                      ? isAdmin || isEditable
                          ? IconButton(
                              onPressed: () {
                                groupData.groupName != null
                                    ? groupNameEditController.text =
                                        snapshot.data!.groupName!
                                    : '';
                                dataEditDialogBox(
                                  maxLines: 1,
                                  controller: groupNameEditController,
                                  context: context,
                                  fieldTitle: "Group Name",
                                  hintText: "Enter group name",
                                  groupData: groupData,
                                  onPressed: () {
                                    final updatedGroupData = groupData.copyWith(
                                        groupName:
                                            groupNameEditController.text);
                                    context.read<GroupBloc>().add(
                                        UpdateGroupEvent(
                                            updatedGroupData:
                                                updatedGroupData));
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: iconGreyColor,
                              ),
                            )
                          : zeroMeasureWidget
                      : zeroMeasureWidget,
                ],
              );
            }),
        isGroup ? zeroMeasureWidget : kHeight5,
        StreamBuilder<GroupModel?>(
            stream: groupData != null
                ? CommonDBFunctions.getOneGroupDataByStream(
                    userID: firebaseAuth.currentUser!.uid,
                    groupID: groupData.groupID ?? "")
                : null,
            builder: (context, snapshot) {
              return TextWidgetCommon(
                text: !isGroup
                    ? receiverData?.phoneNumber ?? ''
                    : "${snapshot.data?.groupMembers?.length ?? groupData?.groupMembers?.length} Members",
                textAlign: TextAlign.center,
                textColor: iconGreyColor,
                overflow: TextOverflow.ellipsis,
                fontSize: !isGroup ? 20.sp : 13.sp,
              );
            }),
        kHeight10,
        TextWidgetCommon(
          textAlign: TextAlign.center,
          text: isGroup
              ? "Created at ${DateProvider.convertDateToFormatted(date: groupData!.groupCreatedAt.toString())}"
              : '',
          overflow: TextOverflow.ellipsis,
          fontSize: 14.sp,
          textColor: iconGreyColor,
        ),
      ],
    ),
  );
}
