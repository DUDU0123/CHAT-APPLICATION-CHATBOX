import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/user_profile_show_dialog.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/group_member_tile_small_widgets.dart';

import '../../../../core/utils/remove_or_exit_from_group_method.dart';

Widget groupMemberListTileWidget({
  required BuildContext context,
  required AsyncSnapshot<UserModel?> groupMemberSnapshot,
  required GroupModel groupData,
}) {
  context.read<UserBloc>().add(
      UserPrivacyCheckerEvent(receiverID: groupMemberSnapshot.data?.id));

  final String? groupMemberName =
      groupMemberSnapshot.data?.id == firebaseAuth.currentUser?.uid
          ? '${groupMemberSnapshot.data?.userName} (You)'
          : groupMemberSnapshot.data?.contactName ??
              groupMemberSnapshot.data?.userName;
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      final privacySettings =
          state.userPrivacySettings?[groupMemberSnapshot.data?.id] ?? {};

      final isShowableProfileImage =
          privacySettings[userDbProfilePhotoPrivacy] ?? false;
      return ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: GestureDetector(
          onTap: () {
            userProfileShowDialog(
                groupModel: groupData,
                context: context,
                userProfileImage: isShowableProfileImage
                    ? groupMemberSnapshot.data?.userProfileImage
                    : null);
          },
          child: buildProfileImage(
            userProfileImage: isShowableProfileImage
                ? groupMemberSnapshot.data?.userProfileImage
                : null,
            context: context,
          ),
        ),
        title: TextWidgetCommon(
          text: groupMemberName ?? '',
          overflow: TextOverflow.ellipsis,
        ),
        trailing: groupData.groupAdmins!.contains(groupMemberSnapshot.data?.id)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  groupMemberSnapshot.data?.id !=
                              firebaseAuth.currentUser?.uid &&
                          groupData.groupAdmins!
                              .contains(firebaseAuth.currentUser?.uid)
                      ? removeButtonWidget(
                          context: context,
                          groupMemberName: groupMemberName,
                          groupData: groupData,
                          groupMemberSnapshot: groupMemberSnapshot,
                        )
                      : zeroMeasureWidget,
                  commonContainerChip(
                    onTap: () {
                      if (groupMemberSnapshot.data?.id !=
                          firebaseAuth.currentUser?.uid) {
                        groupData.groupAdmins!
                                .contains(firebaseAuth.currentUser?.uid)
                            ? dismissAdminMethodInGroup(
                                context: context,
                                groupMemberName: groupMemberName,
                                groupData: groupData,
                                groupMemberSnapshot: groupMemberSnapshot,
                              )
                            : null;
                      }
                    },
                    chipText: "Group Admin",
                    chipColor: buttonSmallTextColor.withOpacity(0.3),
                    chipWidth: 100.w,
                  ),
                ],
              )
            : groupData.groupAdmins!.contains(firebaseAuth.currentUser?.uid)
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (groupMemberSnapshot.data?.id !=
                          firebaseAuth.currentUser?.uid)
                        removeButtonWidget(
                          context: context,
                          groupMemberName: groupMemberName,
                          groupData: groupData,
                          groupMemberSnapshot: groupMemberSnapshot,
                        ),
                      if (groupMemberSnapshot.data?.id !=
                          firebaseAuth.currentUser?.uid)
                        commonContainerChip(
                          chipWidth: 80.w,
                          chipColor: buttonSmallTextColor.withOpacity(0.3),
                          chipText: "as admin",
                          onTap: () {
                            makeAMemberAsAdminInGroupMethod(
                              context: context,
                              groupMemberName: groupMemberName,
                              groupMemberSnapshot: groupMemberSnapshot,
                              groupData: groupData,
                            );
                          },
                        ),
                    ],
                  )
                : zeroMeasureWidget,
      );
    },
  );
}
