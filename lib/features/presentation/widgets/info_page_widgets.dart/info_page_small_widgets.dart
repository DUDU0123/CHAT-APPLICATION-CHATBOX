import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/icon_container_widget_gradient_color.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/call_buttons.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/group_description_add_page.dart';
import 'package:provider/provider.dart';

Widget userProfileImageShowWidget(
    {required BuildContext context,
    required String imageUrl,
    double? radius,
    void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      radius: radius?.sp ?? 20.sp,
      backgroundImage: NetworkImage(
        imageUrl,
      ),
    ),
  );
}

Widget chatDescriptionOrAbout({
  required bool isGroup,
  String? receiverAbout,
  String? groupDescription,
  required BuildContext context,
  required GroupModel? groupData,
  required UserModel? receiverData,
}) {
  return StreamBuilder<GroupModel?>(
      stream: groupData != null
          ? CommonDBFunctions.getOneGroupDataByStream(
              userID: firebaseAuth.currentUser!.uid,
              groupID: groupData.groupID!)
          : null,
      builder: (context, snapshot) {
        final commonProvider =
            Provider.of<CommonProvider>(context, listen: true);
        bool isAdmin = snapshot.data != null
            ? snapshot.data!.groupAdmins!
                .contains(firebaseAuth.currentUser?.uid)
            : false;
        bool isEditable = snapshot.data != null
            ? snapshot.data!.membersPermissions!
                .contains(MembersGroupPermission.editGroupSettings)
            : false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                isGroup
                    ? snapshot.data != null
                        ? isEditable || isAdmin
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupDescriptionAddPage(
                                    groupModel: snapshot.data!,
                                  ),
                                ))
                            : null
                        : null
                    : null;
              },
              child: TextWidgetCommon(
                text: !isGroup
                    ? "About"
                    : snapshot.data != null
                        ? isEditable || isAdmin
                            ? "Add Group Description"
                            : "Group Description"
                        : "About",
                textColor: buttonSmallTextColor,
                overflow: TextOverflow.ellipsis,
                fontSize: 18.sp,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                !isGroup
                    ? BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          final privacySettings =
                              state.userPrivacySettings?[receiverData?.id] ??
                                  {};

                          final isShowableAbout =
                              privacySettings[userDbAboutPrivacy] ?? false;
                          return aboutDescriptionWidget(
                            isGroup: false,
                            commonProvider: commonProvider,
                            text: isShowableAbout
                                ? receiverAbout ?? 'No about'
                                : '',
                          );
                        },
                      )
                    : aboutDescriptionWidget(
                        isGroup: true,
                        commonProvider: commonProvider,
                        text:
                            snapshot.data?.groupDescription ?? 'No description',
                      ),
                if (isGroup)
                  isGroup
                      ? snapshot.data != null
                          ? snapshot.data?.groupDescription != null
                              ? snapshot.data!.groupDescription!.length > 100
                                  ? readMoreButton(
                                      context: context,
                                      commonProvider: commonProvider)
                                  : zeroMeasureWidget
                              : zeroMeasureWidget
                          : zeroMeasureWidget
                      : zeroMeasureWidget,
              ],
            ),
            (groupData != null && isGroup)
                ? StreamBuilder<UserModel?>(
                    stream: groupData.createdBy != null
                        ? groupData.createdBy!.isNotEmpty
                            ? CommonDBFunctions
                                .getOneUserDataFromDataBaseAsStream(
                                    userId: groupData.createdBy!)
                            : null
                        : null,
                    builder: (context, snapshot) {
                      return TextWidgetCommon(
                        text:
                            "Created by ${snapshot.data?.contactName ?? snapshot.data?.userName ?? ''}, (${DateProvider.formatMessageDateTime(
                          messageDateTimeString:
                              groupData.groupCreatedAt.toString(),
                          isInsideChat: true,
                        )})",
                        fontSize: 14.sp,
                        textColor: iconGreyColor,
                        fontWeight: FontWeight.normal,
                      );
                    })
                : zeroMeasureWidget,
          ],
        );
      });
}

Widget aboutDescriptionWidget({
  required String text,
  required bool isGroup,
  required CommonProvider commonProvider,
}) {
  return TextWidgetCommon(
    text: text,
    overflow: TextOverflow.ellipsis,
    fontSize: 14.sp,
    textColor: iconGreyColor,
    maxLines: !isGroup
        ? 1
        : !commonProvider.isExpanded
            ? 6
            : null,
  );
}

Widget infoPageActionIconsBlueGradient({
  required bool isGroup,
  required BuildContext context,
  required ChatModel? chatModel,
  required GroupModel? groupModel,
  required String receiverTitle,
  required String? receiverImage,
  required CallBloc callBloc,
}) {
  return FutureBuilder<Map<String, bool>>(
      future: chatModel != null
          ? Future.wait([
              CommonDBFunctions.checkIfIsBlocked(
                receiverId: chatModel.receiverID,
                currentUserId: firebaseAuth.currentUser?.uid,
              ),
              CommonDBFunctions.checkIfIsBlocked(
                receiverId: firebaseAuth.currentUser?.uid,
                currentUserId: chatModel.receiverID,
              ),
            ]).then((results) {
              return {
                "isReceiverBlocked":
                    results[0], // True if receiver blocked the sender
                "isSenderBlocked":
                    results[1], // True if sender is blocked by the receiver
              };
            })
          : null,
      builder: (context, snapshot) {
        final isReceiverBlocked = snapshot.data?['isReceiverBlocked'] ?? false;
        final isSenderBlocked = snapshot.data?['isSenderBlocked'] ?? false;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: chatModel!=null?(isSenderBlocked || isReceiverBlocked)?0:80:80,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              decoration: gradientButtonDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  callButtonsMethods(
                      isSenderOrReceiverBlocked:
                          (isSenderBlocked || isReceiverBlocked),
                      chatModel: chatModel,
                      groupModel: groupModel,
                      isVideoCall: false,
                      receiverTitle: receiverTitle,
                      receiverImage: receiverImage,
                      callBloc: callBloc,
                      theme: Theme.of(context),
                      context: context,
                      buttonIconColor: kWhite),
                  gradientButtonText(subtitle: "Audio")
                ],
              ),
            ),
            kWidth10,
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              height: chatModel!=null?(isSenderBlocked || isReceiverBlocked)?0:80:80,
              decoration: gradientButtonDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  callButtonsMethods(
                    isSenderOrReceiverBlocked:
                        (isSenderBlocked || isReceiverBlocked),
                    buttonIconColor: kWhite,
                    chatModel: chatModel,
                    groupModel: groupModel,
                    isVideoCall: true,
                    receiverTitle: receiverTitle,
                    receiverImage: receiverImage,
                    callBloc: callBloc,
                    theme: Theme.of(context),
                    context: context,
                  ),
                  gradientButtonText(subtitle: "Video")
                ],
              ),
            ),
            kWidth10,
          ],
        );
      });
}
