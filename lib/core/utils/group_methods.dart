import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/data_sources/group_data/group_data.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/group/group_pages/group_details_add_page.dart';

class GroupMethods {
  static void groupDetailsAddOnCreationMethod({
    required BuildContext context,
    required List<ContactModel>? selectedContactList,
    required String? groupName,
    required File? pickedGroupImageFile,
  }) {
    final String? currentUserId = firebaseAuth.currentUser?.uid;
    if (currentUserId == null) {
      return;
    }
    List<String> selectUsersID = [];
    for (var user in selectedContactList!) {
      if (user.chatBoxUserId != null) {
        selectUsersID.add(user.chatBoxUserId!);
      }
    }
    List<MembersGroupPermission> memberPermissions = filterPermissions(
      context.read<GroupBloc>().state.memberPermissions,
    );
    List<AdminsGroupPermission> adminPermissions = filterPermissions(
      context.read<GroupBloc>().state.adminPermissions,
    );
    GroupModel newGroupData = GroupModel(
      groupCreatedAt: DateTime.now().toString(),
      groupName: groupName,
      groupAdmins: [currentUserId],
      createdBy: currentUserId,
      groupMembers: [currentUserId, ...selectUsersID],
      adminsPermissions: adminPermissions,
      membersPermissions: memberPermissions,
    );
    groupName != null
        ? groupName.isNotEmpty
            ? context.read<GroupBloc>().add(
                  CreateGroupEvent(
                    context: context,
                    newGroupData: newGroupData,
                    groupProfileImage: pickedGroupImageFile,
                  ),
                )
            : commonSnackBarWidget(
                contentText: "Enter group name",
                context: context,
              )
        : commonSnackBarWidget(
            contentText: "Enter group name",
            context: context,
          );
  }

  // update group member list after creation method
  static void updateGroupMembersAfterCreationMethod({
    required List<ContactModel>? selectedContactList,
    required GroupModel? groupModel,
    required BuildContext context,
  }) {
    if (selectedContactList != null) {
      if (selectedContactList.isNotEmpty) {
        final Set<String> updatedGroupMembers =
            Set<String>.from(groupModel?.groupMembers ?? []);
        for (var selectedContact in selectedContactList) {
          updatedGroupMembers.add(selectedContact.chatBoxUserId!);
          if (selectedContact.chatBoxUserId!=null && groupModel!=null) {
            GroupData.subscribeUserToGroupTopic(selectedContact.chatBoxUserId!, groupModel.groupID!);
          }
        }
        final updatedGroupData =
            groupModel?.copyWith(groupMembers: updatedGroupMembers.toList());
        updatedGroupData != null
            ? context.read<GroupBloc>().add(
                  UpdateGroupEvent(
                    updatedGroupData: updatedGroupData,
                  ),
                )
            : null;
        Navigator.pop(context);
      } else {
        commonSnackBarWidget(
          contentText: "Select atleast 1 members",
          context: context,
        );
      }
    } else {
      commonSnackBarWidget(
        contentText: "Select atleast 1 members",
        context: context,
      );
    }
  }

  static void selectGroupMembersOnCreationAndSendToDetailsAddPageMethod(
    {required List<ContactModel>? selectedContactList,
    required BuildContext context}) {
  selectedContactList != null
      ? selectedContactList.length >= 2
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailsAddPage(
                  selectedGroupMembers: selectedContactList,
                ),
              ),
            )
          : commonSnackBarWidget(
              contentText: "Select atleast 2 members",
              context: context,
            )
      : commonSnackBarWidget(
          contentText: "Select atleast 2 members",
          context: context,
        );
}
}
