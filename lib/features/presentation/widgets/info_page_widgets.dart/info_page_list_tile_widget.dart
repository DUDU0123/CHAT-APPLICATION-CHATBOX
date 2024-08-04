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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/remove_or_exit_from_group_method.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';

Widget infoPageListTileWidget({
  required BuildContext context,
  required bool isGroup,
  IconData? icon,
  UserModel? receiverData,
  required bool isFirstTile,
  required GroupModel? groupData,
}) {
  return StreamBuilder<UserModel?>(
    stream: groupData != null
        ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
            userId: firebaseAuth.currentUser!.uid)
        : null,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(
            child:
                CircularProgressIndicator()); // Show a loader while fetching data
      }

      return commonListTile(
        onTap: () {
          if (isGroup && groupData != null) {
            if (isFirstTile) {
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
              print(groupData);
            }
          }
        },
        title: isFirstTile
            ? !isGroup
                ? "Block ${receiverData?.userName ?? ''}"
                : "Exit group"
            : !isGroup
                ? "Report ${receiverData?.userName ?? ''}"
                : "Report group",
        isSmallTitle: false,
        context: context,
        color: kRed,
        leading: Icon(
          isFirstTile
              ? !isGroup
                  ? Icons.block
                  : Icons.logout
              : Icons.report_outlined,
          color: kRed,
          size: 28.sp,
        ),
      );
    },
  );
}
