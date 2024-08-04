part of 'group_bloc.dart';

sealed class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadGroupPermissionsEvent extends GroupEvent {
  final GroupModel groupModel;
  final PageTypeEnum pageTypeEnum;
  const LoadGroupPermissionsEvent({
    required this.groupModel,
    required this.pageTypeEnum,
  });

  @override
  List<Object> get props => [groupModel, pageTypeEnum];
}

class CreateGroupEvent extends GroupEvent {
  final GroupModel newGroupData;
  final BuildContext context;
  final File? groupProfileImage;
  const CreateGroupEvent({
    required this.newGroupData,
    required this.context,
    this.groupProfileImage,
  });
  @override
  List<Object> get props =>
      [context, newGroupData, groupProfileImage ?? File('')];
}

class GetAllGroupsEvent extends GroupEvent {
  @override
  List<Object> get props => [];
}

class UpdateGroupEvent extends GroupEvent {
  final GroupModel updatedGroupData;
  final File? groupProfileImage;
  const UpdateGroupEvent({
    required this.updatedGroupData,
    this.groupProfileImage,
  });
  @override
  List<Object> get props => [
        updatedGroupData,
        groupProfileImage ?? File(''),
      ];
}

class ClearGroupChatEvent extends GroupEvent {
  final String groupID;
  const ClearGroupChatEvent({
    required this.groupID,
  });
  @override
  List<Object> get props => [
        groupID,
      ];
}

class DeleteGroupEvent extends GroupEvent {
  final String groupID;
  const DeleteGroupEvent({
    required this.groupID,
  });
  @override
  List<Object> get props => [groupID];
}

class GroupImagePickEvent extends GroupEvent {
  final File? pickedFile;
  const GroupImagePickEvent({
    this.pickedFile,
  });
  @override
  List<Object> get props => [pickedFile ?? ''];
}
// class ResetPickedFileEvent extends GroupEvent{}

class UpdateMemberPermissionEvent extends GroupEvent {
  final MembersGroupPermission permission;
  final bool isEnabled;
  final PageTypeEnum pageTypeEnum;
  final GroupModel? groupModel;

  const UpdateMemberPermissionEvent({
    required this.permission,
    required this.isEnabled,
    required this.pageTypeEnum,
    this.groupModel,
  });

  @override
  List<Object> get props => [
        permission,
        isEnabled,
        pageTypeEnum,
        groupModel ?? const GroupModel(),
      ];
}

class UpdateAdminPermissionEvent extends GroupEvent {
  final AdminsGroupPermission permission;
  final bool isEnabled;
  final PageTypeEnum pageTypeEnum;
  final GroupModel? groupModel;

  const UpdateAdminPermissionEvent({
    required this.permission,
    required this.isEnabled,
    required this.pageTypeEnum,
    this.groupModel,
  });

  @override
  List<Object> get props => [
        permission,
        isEnabled,
        pageTypeEnum,
        groupModel ?? const GroupModel(),
      ];
}
