import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';

StreamBuilder<UserModel?> messageContainerUserDetails(
    {required MessageModel message, required BuildContext context,}) {
      context.read<UserBloc>().add(ProfileImageShowCheckerEvent(
          receiverID: message.senderID));
  return StreamBuilder<UserModel?>(
      stream: CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
          userId: message.senderID ?? ''),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return zeroMeasureWidget;
        }
        final contactName = snapshot.data?.contactName;
        String prefix = '';
        if (contactName == null || contactName.isEmpty) {
          prefix = '~';
        }
        String? messageSenderProfileImage = snapshot.data!.userProfileImage;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            messageSenderProfileImage != null
                ? BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      final privacySettings =
                          state.userPrivacySettings?[snapshot.data?.id] ?? {};
                          log("Group Privacy user: $privacySettings");
                      final bool isShowableProfileImage =
                          privacySettings[userDbProfilePhotoPrivacy] ?? false;
                      return isShowableProfileImage
                          ? userProfileImageShowWidget(
                              context: context,
                              imageUrl: messageSenderProfileImage,
                              radius: 10,
                            )
                          : nullImageReplaceWidget(
                              containerRadius: 20,
                              context: context,
                            );
                    },
                  )
                : nullImageReplaceWidget(
                    containerRadius: 20,
                    context: context,
                  ),
            kWidth5,
            Expanded(
              child: TextWidgetCommon(
                text:
                    "$prefix${snapshot.data?.contactName ?? snapshot.data!.userName ?? ''}",
                overflow: TextOverflow.ellipsis,
                fontSize: 10.sp,
                textColor: kWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
            kWidth2,
            TextWidgetCommon(
              text: snapshot.data?.phoneNumber ?? "",
              fontSize: 10.sp,
              textColor: kBlack,
              fontWeight: FontWeight.w600,
            )
          ],
        );
      });
}
