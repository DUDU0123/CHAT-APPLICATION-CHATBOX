import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/status/status_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/status/status_pages/status_show_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/profile_image_selector_bottom_sheet.dart';
import 'package:status_view/status_view.dart';

int getSeenStatusIndex(StatusModel? statusModel, String? currentUserId) {
  if (statusModel == null || statusModel.statusList == null || currentUserId == null) {
    log('Invalid input: statusModel or statusList or currentUserId is null');
    return -1;
  }

  log('currentUserId: $currentUserId');
  log('Status List Length: ${statusModel.statusList!.length}');
  
  for (int i = statusModel.statusList!.length - 1; i >= 0; i--) {
    final status = statusModel.statusList![i];
    log('Checking status index: $i');
    log('Viewers: ${status.viewers}');
    if (status.viewers != null) {
      log('Contains currentUserId: ${status.viewers!.contains(currentUserId)}');
      if (status.viewers!.contains(currentUserId)) {
        return i;
      }
    }
  }
  return -1;
}


Widget statusTileWidget({
  required BuildContext context,
  StatusModel? statusModel,
  bool? isCurrentUser = false,
  final String? currentUserId,
}) {
  return ListTile(
    onTap: () {
      if (statusModel != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatusShowPage(
              statusModel: statusModel,
              isCurrentUser: isCurrentUser,
              currentUserId: currentUserId,
            ),
          ),
        );
      }
    },
    leading: Stack(
      children: [
        StreamBuilder<UserModel?>(
            stream: CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                userId: isCurrentUser != null
                    ? isCurrentUser
                        ? firebaseAuth.currentUser!.uid
                        : statusModel != null
                            ? statusModel.statusUploaderId ?? ''
                            : firebaseAuth.currentUser!.uid
                    : ''),
            builder: (context, snapshot) {
              log(name: "Index of seen", getSeenStatusIndex(statusModel, currentUserId).toString());
              return StatusView(
                padding: 0,
                indexOfSeenStatus:
                    getSeenStatusIndex(statusModel, currentUserId),
                numberOfStatus: statusModel != null
                    ? statusModel.statusList != null
                        ? statusModel.statusList!.length
                        : 0
                    : 0,
                radius: 30,
                strokeWidth: 2,
                seenColor: !isCurrentUser!
                    ? iconGreyColor
                    : darkLinearGradientColorOne,
                unSeenColor: !isCurrentUser
                    ? lightLinearGradientColorOne
                    : darkLinearGradientColorOne,
                centerImageUrl: snapshot.data?.userProfileImage ??
                    "https://cdn.pixabay.com/photo/2024/05/26/10/15/bird-8788491_1280.jpg",
              );
            }),
        if (isCurrentUser!)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                assetSelectorBottomSheet(
                  context: context,
                  firstButtonName: "Image",
                  secondButtonName: "Video",
                  firstButtonAction: () {
                    context.read<StatusBloc>().add(
                          PickStatusEvent(
                            statusModel: statusModel,
                            context: context,
                            statusType: StatusType.image,
                          ),
                        );
                    Navigator.pop(context);
                  },
                  firstButtonIcon: Icons.photo,
                  secondButtonIcon: Icons.video_library_outlined,
                  secondButtonAction: () {
                    context.read<StatusBloc>().add(
                          PickStatusEvent(
                              statusType: StatusType.video,
                              context: context,
                              statusModel: statusModel),
                        );
                    Navigator.pop(context);
                  },
                );
              },
              child: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      lightLinearGradientColorOne,
                      lightLinearGradientColorTwo
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: kWhite,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          )
      ],
    ),
    title: StreamBuilder<UserModel?>(
        stream: statusModel != null
            ? statusModel.statusUploaderId != null
                ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                    userId: statusModel.statusUploaderId!)
                : null
            : null,
        builder: (context, snapshot) {
          return TextWidgetCommon(
            text: isCurrentUser
                ? "My status"
                : snapshot.data?.contactName ??
                    snapshot.data?.userName ??
                    'My Status',
            fontSize: 16.sp,
          );
        }),
    trailing: TextWidgetCommon(
      text: !isCurrentUser
          ? TimeProvider.getRelativeTime(
              statusModel!.statusList!.last.statusUploadedTime!)
          : "",
      textColor: iconGreyColor,
      fontWeight: FontWeight.normal,
      fontSize: 10.sp,
    ),
  );
}
