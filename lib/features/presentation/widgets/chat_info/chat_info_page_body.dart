import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/report_model/report_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_actions_on_longpress_method.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_info/chat_info_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_list_tile_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_user_details_part_widget.dart';

Widget chatInfoPageBody({
  required TextEditingController groupNameEditController,
  required UserModel? receiverData,
  required BuildContext context,
  required bool isAdmin,
  required CallBloc callBloc,
  required ChatModel? chatModel,
  required GroupModel? groupData,
  required bool isGroup,
  required String? receiverContactName,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          infoPageUserDetailsPart(
            groupNameEditController: groupNameEditController,
            context: context,
            receiverData: receiverData,
            groupData: groupData,
            isGroup: isGroup,
            receiverContactName: receiverContactName,
          ),
          kHeight20,
          receiverData?.id != firebaseAuth.currentUser?.uid
              ? infoPageActionIconsBlueGradient(
                  callBloc: callBloc,
                  chatModel: chatModel,
                  groupModel: groupData,
                  receiverTitle: receiverData != null
                      ? receiverData.contactName ?? receiverData.phoneNumber!
                      : groupData!.groupName!,
                  receiverImage: receiverData != null
                      ? receiverData.contactName ??
                          receiverData.userProfileImage
                      : groupData!.groupProfileImage,
                  context: context,
                  isGroup: isGroup,
                )
              : zeroMeasureWidget,
          chatDescriptionOrAbout(
            groupData: groupData,
            context: context,
            isGroup: isGroup,
            receiverAbout: receiverData?.userAbout,
            groupDescription: groupData?.groupDescription,
            receiverData: receiverData,
          ),
          heightWidgetReturnOnCondition(
            isGroup: isGroup,
            groupData: groupData,
          ),
          !isGroup
              ? chatMediaGradientContainerWidget(
                  context: context,
                  chatModel: chatModel,
                )
              : isAdmin
                  ? groupPermissionGraientContainerWidget(
                      context: context,
                      groupData: groupData,
                    )
                  : zeroMeasureWidget,
          heightWidgetReturnOnCondition(
            isGroup: isGroup,
            groupData: groupData,
          ),
          membersListOrGroupListWidget(
            context: context,
            receiverData: receiverData,
            groupData: groupData,
          ),
          kHeight20,
          chatModel != null &&
                  chatModel.receiverID != firebaseAuth.currentUser?.uid
              ? StreamBuilder<List<BlockedUserModel>>(
                  stream: CommonDBFunctions.getAllBlockedUsers(),
                  builder: (context, snapshot) {
                    final blockList = snapshot.data;
                    final isBlocker = blockList?.any((blockedUser) =>
                        blockedUser.userId == chatModel.receiverID);
                    return infoPageListTileWidget(
                      isBlockTile: true,
                      context: context,
                      icon: Icons.block,
                      tileText:
                          "${isBlocker != null ? isBlocker ? 'Unblock' : 'Block' : 'Block'} ${receiverData?.contactName ?? receiverData?.phoneNumber}",
                      chatModel: chatModel,
                    );
                  })
              : zeroMeasureWidget,
          // for group
          groupData != null
              ? groupData.groupMembers!.contains(firebaseAuth.currentUser?.uid)
                  ? groupListTile(
                      context: context,
                      isGroup: isGroup,
                      title: "Exit group",
                      groupData: groupData,
                      icon: Icons.logout,
                      tileType: 'exit-tile',
                    )
                  : zeroMeasureWidget
              : zeroMeasureWidget,
          // for group
          groupData != null
              ? !groupData.groupMembers!
                      .contains(firebaseAuth.currentUser?.uid)
                  ? commonListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: kRed,
                        size: 28.sp,
                      ),
                      color: kRed,
                      onTap: () {
                        deleteChatMethodCommon(
                          context: context,
                          isGroup: isGroup,
                          chatModel: chatModel,
                          groupModel: groupData,
                        );
                      },
                      title: "Delete Group",
                      isSmallTitle: false,
                      context: context,
                    )
                  : zeroMeasureWidget
              : zeroMeasureWidget,
          // for one-to-one chat
          chatModel != null &&
                  chatModel.receiverID != firebaseAuth.currentUser?.uid
              ? infoPageListTileWidget(
                  isBlockTile: false,
                  context: context,
                  icon: Icons.report_gmailerrorred_outlined,
                  dialogTitle:
                      "Report ${receiverData?.contactName ?? receiverData?.phoneNumber}",
                  dialogSubTitle:
                      "Do you want to report ${receiverData?.contactName ?? receiverData?.phoneNumber}",
                  actionButtonName: "Report",
                  tileText:
                      "Report ${receiverData?.contactName ?? receiverData?.phoneNumber}",
                  chatModel: chatModel,
                  onPressed: () {
                    if (receiverData != null) {
                      final reportModel = ReportModel(
                        reportedUserId: receiverData.id,
                      );
                      context.read<ChatBloc>().add(ReportAccountEvent(
                            reportModel: reportModel,
                            context: context,
                          ));
                    }

                    Navigator.pop(context);
                  },
                )
              : zeroMeasureWidget,
        ],
      ),
    ),
  );
}
