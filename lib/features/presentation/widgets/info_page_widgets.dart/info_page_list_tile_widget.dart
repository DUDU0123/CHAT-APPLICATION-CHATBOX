// import 'dart:developer';

// import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
// import 'package:chatbox/core/constants/colors.dart';
// import 'package:chatbox/core/utils/common_db_functions.dart';
// import 'package:chatbox/core/utils/remove_or_exit_from_group_method.dart';
// import 'package:chatbox/features/data/models/group_model/group_model.dart';
// import 'package:chatbox/features/data/models/user_model/user_model.dart';
// import 'package:chatbox/features/presentation/widgets/common_widgets/common_list_tile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Widget infoPageListTileWidget({
//   required BuildContext context,
//   required bool isGroup,
//   IconData? icon,
//   UserModel? receiverData,
//   required bool isFirstTile,
//   required GroupModel? groupData,
// }) {
//   return StreamBuilder<UserModel?>(
//     stream:groupData!=null? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(userId: firebaseAuth.currentUser!.uid):null,
//     builder: (context, snapshot) {
//       return commonListTile(
//         onTap: () {
//           if (isGroup && groupData!=null) {
//             if (isFirstTile) {
//               log("Indide first");
//               removeOrExitFromGroupMethod(
//                 context: context,
//                 title: "Exit from ${groupData.groupName}",
//                 subtitle:
//                     "You can't send messaged to this group and you will no longer a member in this group",
//                 groupData: groupData,
//                 groupMemberSnapshot: snapshot,
//                 actionButtonName: "Exit",
//               );
//             }
//           }
//         },
//         title: isFirstTile
//             ? !isGroup
//                 ? "Block ${receiverData?.userName ?? ''}"
//                 : "Exit group"
//             : !isGroup
//                 ? "Report ${receiverData?.userName ?? ''}"
//                 : "Report group",
//         isSmallTitle: false,
//         context: context,
//         color: kRed,
//         leading: Icon(
//           isFirstTile
//               ? !isGroup
//                   ? Icons.block
//                   : Icons.logout
//               : Icons.report_outlined,
//           color: kRed,
//           size: 28.sp,
//         ),
//       );
//     }
//   );
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/remove_or_exit_from_group_method.dart';
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

Widget infoPageListTileWidget({
  required BuildContext context,
  UserModel? receiverData,
  required bool isFirstTile,
  required ChatModel? chatModel,
}) {
  return commonListTile(
    onTap: () {
      normalDialogBoxWidget(
        context: context,
        title:
            "${isFirstTile?'Block':'Report'} ${receiverData?.contactName ?? receiverData?.userName ?? receiverData?.phoneNumber}",
        subtitle:
            "Do you want to ${isFirstTile?'block':'report'} ${receiverData?.contactName ?? receiverData?.userName ?? receiverData?.phoneNumber}?",
        onPressed: () {
          if (isFirstTile) {
            BlockedUserModel blockedUserModel = BlockedUserModel(
              userId: receiverData?.id,
            );
            context.read<UserBloc>().add(
                  BlockUserEvent(
                      blockedUserModel: blockedUserModel,
                      chatId: chatModel?.chatID),
                );
          }else{
            // write method to report a user
          }
          Navigator.pop(context);
        },
        actionButtonName: isFirstTile?"Block":"Report",
      );
    },
    title: isFirstTile
        ? "Block ${receiverData?.contactName ?? receiverData?.userName ?? ''}"
        : "Report ${receiverData?.contactName ?? receiverData?.userName ?? ''}",
    isSmallTitle: false,
    context: context,
    color: kRed,
    leading: Icon(
      isFirstTile ? Icons.block : Icons.report_outlined,
      color: kRed,
      size: 28.sp,
    ),
  );
}

Widget groupListTile({
  required BuildContext context,
  required bool isGroup,
  IconData? icon,
  required String title,
  required GroupModel groupData,
  required String tileType,
}) {
  return StreamBuilder<UserModel?>(
    stream: CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
        userId: firebaseAuth.currentUser!.uid),
    builder: (context, snapshot) {
      return commonListTile(
        onTap: () {
          switch (tileType) {
            case 'exit-tile':
              if (groupData.groupMembers!
                  .contains(firebaseAuth.currentUser?.uid)) {
                log("Inside first tile");
                removeOrExitFromGroupMethod(
                  context: context,
                  title: "Exit from ${groupData.groupName}",
                  subtitle:
                      "You can't send messages to this group and you will no longer be a member of this group",
                  groupData: groupData,
                  groupMemberSnapshot: snapshot,
                  actionButtonName: "Exit",
                );
                log(groupData.toString());
              }
              break;
            case 'report-tile':
            // write method to report a group
            default:
          }
        },
        title: title,
        isSmallTitle: false,
        context: context,
        color: kRed,
        leading: Icon(
          icon,
          color: kRed,
          size: 28.sp,
        ),
      );
    },
  );
}
