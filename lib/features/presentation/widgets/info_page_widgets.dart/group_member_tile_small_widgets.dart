import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/remove_or_exit_from_group_method.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget removeButtonWidget({
  required BuildContext context,
  String? groupMemberName,
  required GroupModel groupData,
  required AsyncSnapshot<UserModel?> groupMemberSnapshot,
}) {
  return IconButton(
    onPressed: () {
      removeOrExitFromGroupMethod(
        context: context,
        title: "Remove $groupMemberName",
        subtitle: "$groupMemberName will permanently removed from this group",
        groupData: groupData,
        groupMemberSnapshot: groupMemberSnapshot,
        actionButtonName: "Remove",
      );
    },
    icon: Icon(
      Icons.remove_circle,
      color: kRed.withOpacity(0.6),
    ),
  );
}

Widget commonContainerChip(
    {void Function()? onTap,
    required String chipText,
    required Color chipColor,
    required double chipWidth}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.sp),
        color: chipColor,
      ),
      height: 20.h,
      width: chipWidth,
      child: Center(
        child: TextWidgetCommon(
          text: chipText,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}

Widget infoPageCommonGroupList({
  required UserModel? receiverData,
}) {
  return
   ListView.separated(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return FutureBuilder<GroupModel?>(
          future: CommonDBFunctions.getGroupDetailsByGroupID(
            groupID: receiverData.userGroupIdList![index],
            userID: receiverData.id!,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              log("Some Error Occured ${snapshot.error} ${snapshot.stackTrace}");
              return commonErrorWidget(
                  message:
                      "Some Error Occured ${snapshot.error} ${snapshot.stackTrace}");
            }
            return commonGroupDataShowWidgetInChatInfo(
              context: context,
              groupData: snapshot.data,
            );
          });
    },
    separatorBuilder: (context, index) => kHeight5,
    itemCount: receiverData!.userGroupIdList!.length,
  );
}

Widget commonGroupDataShowWidgetInChatInfo({
  required BuildContext context,
  required GroupModel? groupData,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.all(0),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomPage(
            groupModel: groupData,
            userName: groupData?.groupName ?? '',
            isGroup: true,
          ),
        ),
      );
    },
    leading: GestureDetector(
      child: buildProfileImage(
        userProfileImage: groupData?.groupProfileImage,
        context: context,
      ),
    ),
    title: buildUserName(userName: groupData?.groupName ?? ''),
  );
}
