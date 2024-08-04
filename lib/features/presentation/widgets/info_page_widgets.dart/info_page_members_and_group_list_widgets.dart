import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/group_members_listtile_widget.dart';

Widget infoPageGroupMembersList({
  required GroupModel? groupData,
  required BuildContext context,
}) {
  return Column(
    children: [
      addGroupMembersTile(
        context: context,
        groupModel: groupData,
      ),
      groupData!.adminsPermissions!
                  .contains(AdminsGroupPermission.viewMembers) &&
              !groupData.groupAdmins!.contains(firebaseAuth.currentUser?.uid)
          ? zeroMeasureWidget
          : StreamBuilder<GroupModel?>(
              stream: groupData != null
                  ? CommonDBFunctions.getOneGroupDataByStream(
                      userID: firebaseAuth.currentUser!.uid,
                      groupID: groupData.groupID!)
                  : null,
              builder: (context, snapshot) {
                final group = snapshot.data;
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return FutureBuilder<UserModel?>(
                        future: CommonDBFunctions.getOneUserDataFromDBFuture(
                            userId: group != null
                                ? group.groupMembers![index]
                                : groupData.groupMembers![index]),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            log("Some Error Occured ${snapshot.error} ${snapshot.stackTrace}");
                            return commonErrorWidget(
                                message:
                                    "Some Error Occured in group member listing ${snapshot.error} ${snapshot.stackTrace}");
                          }
                          return groupMemberListTileWidget(
                            context: context,
                            groupMemberSnapshot: snapshot,
                            groupData: group ?? groupData,
                          );
                        });
                  },
                  separatorBuilder: (context, index) => kHeight5,
                  itemCount: group != null
                      ? group.groupMembers != null
                          ? group.groupMembers!.length
                          : groupData.groupMembers!.length
                      : groupData.groupMembers!.length,
                );
              }),
    ],
  );
}

Widget addGroupMembersTile({
  required BuildContext context,
  required GroupModel? groupModel,
}) {
  if (groupModel == null) {
    return zeroMeasureWidget;
  }
  return !groupModel.membersPermissions!
              .contains(MembersGroupPermission.addMembers) &&
          groupModel.groupAdmins!.contains(firebaseAuth.currentUser?.uid)
      ? addTile(context: context, groupmodel: groupModel)
      : groupModel.membersPermissions!
              .contains(MembersGroupPermission.addMembers)
          ? addTile(context: context, groupmodel: groupModel)
          : zeroMeasureWidget;
}

Widget addTile(
    {required BuildContext context,
    String? tileText = "Add members",
    required GroupModel groupmodel}) {
  return ListTile(
    contentPadding: const EdgeInsets.all(0),
    leading: Container(
      height: 50.h,
      width: 50.w,
      decoration: BoxDecoration(
        border: Border.all(color: kWhite, width: 2.w),
        shape: BoxShape.circle,
        color: darkSwitchColor,
      ),
      child: Center(
        child: StreamBuilder<GroupModel?>(
            stream: groupmodel != null
                ? CommonDBFunctions.getOneGroupDataByStream(
                    userID: firebaseAuth.currentUser!.uid,
                    groupID: groupmodel.groupID!)
                : null,
            builder: (context, snapshot) {
              return IconButton(
                onPressed: () {
                  if (tileText == "Add members") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectContactPage(
                          pageType: PageTypeEnum.groupInfoPage,
                          isGroup: true,
                          groupModel: snapshot.data ?? groupmodel,
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.add,
                  color: kBlack,
                  size: 28.sp,
                ),
              );
            }),
      ),
    ),
    title: TextWidgetCommon(
      text: tileText ?? "Add members",
      textColor: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}