import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/features/data/data_sources/group_data/group_data.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';
// method for remove or exit a group member
void removeOrExitFromGroupMethod({
  required BuildContext context,
  required String title,
  required String subtitle,
  required GroupModel groupData,
  required AsyncSnapshot<UserModel?> groupMemberSnapshot,
  required String actionButtonName,
}) {
  return normalDialogBoxWidget(
    context: context,
    title: title,
    subtitle: subtitle,
    onPressed: () {
      log("Indide it");
      final Set<String> updatedGroupMembers =Set<String>.from(groupData.groupMembers ?? []);
      final Set<String> updatedGroupAdmins =Set<String>.from(groupData.groupAdmins ?? []);
          log("Current group members: ${groupData.groupMembers}");
      log("Current group admins: ${groupData.groupAdmins}");
      log("Current user ID: ${groupMemberSnapshot.data?.id}");
      if (groupData.groupAdmins!.contains(groupMemberSnapshot.data?.id)) {
        log("Indide it admin");
        updatedGroupAdmins.remove(groupMemberSnapshot.data?.id);
      }
      log("Also outside");
      updatedGroupMembers.remove(groupMemberSnapshot.data?.id);
      if (groupMemberSnapshot.data!=null && groupData.groupID!=null) {
         GroupData.unsubscribeUserFromGroupTopic(groupMemberSnapshot.data!.id!, groupData.groupID!);
      }
      final updatedGroupData = groupData.copyWith(
        groupMembers: updatedGroupMembers.toList(),
        groupAdmins: updatedGroupAdmins.toList(),
      );
      context.read<GroupBloc>().add(
            RemoveOrExitFromGroupEvent(
              updatedGroupData: updatedGroupData,
              oldGroupModel: groupData,
            ),
          );
           log("Updated group members: ${updatedGroupData.groupMembers}");
      log("Updated group admins: ${updatedGroupData.groupAdmins}");
      Navigator.pop(context);
    },
    actionButtonName: actionButtonName,
  );
}

// method to dismiss admin
void dismissAdminMethodInGroup({
  required BuildContext context,
  required String? groupMemberName,
  required GroupModel groupData,
  required AsyncSnapshot<UserModel?> groupMemberSnapshot,
}) {
  return normalDialogBoxWidget(
    context: context,
    title: "Dismiss $groupMemberName Admin",
    subtitle: "They will no longer able to manage group data",
    onPressed: () {
      final Set<String> updatedGroupAdmins =
          Set<String>.from(groupData.groupAdmins ?? []);
      updatedGroupAdmins.remove(groupMemberSnapshot.data?.id);
      final updatedGroupData = groupData.copyWith(
        groupAdmins: updatedGroupAdmins.toList(),
      );

      context.read<GroupBloc>().add(
            UpdateGroupEvent(
              updatedGroupData: updatedGroupData,
            ),
          );
      Navigator.pop(context);
    },
    actionButtonName: "Dismiss as admin",
  );
}

//method to make a member as admin group
void makeAMemberAsAdminInGroupMethod({
  required BuildContext context,
  required String? groupMemberName,
  required AsyncSnapshot<UserModel?> groupMemberSnapshot,
  required GroupModel groupData,
}) {
  return normalDialogBoxWidget(
    context: context,
    title: "Make $groupMemberName as admin",
    subtitle: "$groupMemberName will be able to manage this group data",
    onPressed: () {
      if (groupMemberSnapshot.data != null) {
        if (groupMemberSnapshot.data?.id != null) {
          final Set<String> updatedGroupAdmins =
              Set<String>.from(groupData.groupAdmins ?? []);
          updatedGroupAdmins.add(groupMemberSnapshot.data!.id!);
          final updatedGroupData = groupData.copyWith(
            groupAdmins: updatedGroupAdmins.toList(),
          );
          context.read<GroupBloc>().add(
                UpdateGroupEvent(
                  updatedGroupData: updatedGroupData,
                ),
              );
          Navigator.pop(context);
        }
      }
    },
    actionButtonName: "Make as admin",
  );
}