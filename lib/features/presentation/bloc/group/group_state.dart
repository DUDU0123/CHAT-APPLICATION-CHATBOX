part of 'group_bloc.dart';

class GroupState extends Equatable {
  final Stream<List<GroupModel>>? groupList;
  final File? groupPickedImageFile;
  final Map<MembersGroupPermission, bool> memberPermissions;
  final Map<AdminsGroupPermission, bool> adminPermissions;
  final bool? value;
  final bool? isLoading;final String? message;

  const GroupState({
    this.value = false,
    this.groupList,
    this.groupPickedImageFile,this.message,
    this.isLoading,
    this.memberPermissions = const {
      MembersGroupPermission.editGroupSettings: false,
      MembersGroupPermission.sendMessages: false,
      MembersGroupPermission.addMembers: false,
    },
    this.adminPermissions = const {
      AdminsGroupPermission.viewMembers: false,
      AdminsGroupPermission.approveMembers: false,
      AdminsGroupPermission.editGroupSettings: true,
      AdminsGroupPermission.sendMessages: true,
      AdminsGroupPermission.addMembers: true,
    },
  });

  GroupState copyWith({
    Stream<List<GroupModel>>? groupList,String? message,
    bool? isLoading,
    File? groupPickedImageFile,
    Map<MembersGroupPermission, bool>? memberPermissions,
    Map<AdminsGroupPermission, bool>? adminPermissions,
    bool? value,
  }) {
    return GroupState(
      groupList: groupList ?? this.groupList,
      message: message?? this.message,
      isLoading: isLoading ?? this.isLoading,
      groupPickedImageFile: groupPickedImageFile ?? this.groupPickedImageFile,
      memberPermissions: memberPermissions ?? this.memberPermissions,
      adminPermissions: adminPermissions ?? this.adminPermissions,
      value: value??this.value,
    );
  }

  @override
  List<Object> get props => [
        groupList ?? [],
        groupPickedImageFile ?? '',
        memberPermissions,
        adminPermissions,value??false,isLoading??false,message??'',
      ];
}

final class GroupInitial extends GroupState {}