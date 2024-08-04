
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/domain/entities/group_entity/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    super.groupID,
    super.groupName,
    super.groupProfileImage,
    super.groupMembers,
    super.groupAdmins,
    super.groupDescription,
    super.membersPermissions,
    super.adminsPermissions,
    super.groupCreatedAt,
    super.isMuted,
    super.lastMessageStatus,
    super.lastMessage,
    super.lastMessageTime,
    super.lastMessageType,
    super.notificationCount,
    super.isIncomingMessage,
    super.isGroupOpen,
    super.createdBy,
    super.groupWallpaper,
  });

  factory GroupModel.fromJson({required Map<String, dynamic> map}) {
    return GroupModel(
      groupID: map[dbGroupId],
      groupName: map[dbGroupName] ?? "ChatBoxGroup",
      groupDescription: map[dbGroupDescription],
      groupProfileImage: map[dbGroupProfileImage],
      groupAdmins: List<String>.from(map[dbGroupAdminsList] ?? []),
      groupMembers: List<String>.from(map[dbGroupMembersList] ?? []),
      adminsPermissions: stringListToEnumList(
        List<String>.from(map[dbGroupAdminsPermissionList] ?? []),
        AdminsGroupPermission.values,
      ),
      membersPermissions: stringListToEnumList(
        List<String>.from(map[dbGroupMembersPermissionList] ?? []),
        MembersGroupPermission.values,
      ),
      groupCreatedAt: map[dbGroupCreatedAt],
      isMuted: map[dbIsGroupMuted]??false,
      lastMessageStatus: map[dbGroupLastMessageStatus] != null
      ? MessageStatus.values.byName(map[dbGroupLastMessageStatus])
      : null,
      lastMessage: map[dbGroupLastMessage],
      lastMessageTime: map[dbGroupLastMessageTime],
      lastMessageType: map[dbGroupLastMessageType] != null
      ? MessageType.values.byName(map[dbGroupLastMessageType])
      : null,
      notificationCount: map[dbGroupNotificationCount]??0,
      isIncomingMessage: map[dbGroupIsIncomingMessage]??false,
      isGroupOpen: map[dbIsGroupOpen]??false,
      createdBy: map[dbGroupCreatedBy]??'',
      groupWallpaper: map[dbGroupWallpaper],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      dbGroupId: groupID,
      dbGroupName: groupName,
      dbGroupDescription: groupDescription,
      dbGroupProfileImage: groupProfileImage,
      dbGroupAdminsList: groupAdmins,
      dbGroupMembersList: groupMembers,
      dbGroupAdminsPermissionList: enumListToStringList(adminsPermissions!),
      dbGroupMembersPermissionList: enumListToStringList(membersPermissions!),
      dbGroupCreatedAt: groupCreatedAt,
      dbIsGroupOpen: isGroupOpen,
      dbGroupIsIncomingMessage: isIncomingMessage,
      dbGroupNotificationCount: notificationCount,
      dbGroupLastMessageType: lastMessageType?.name,
      dbGroupLastMessageTime: lastMessageTime,
      dbGroupLastMessage: lastMessage,
      dbGroupLastMessageStatus: lastMessageStatus?.name,
      dbIsGroupMuted: isMuted,
      dbGroupCreatedBy: createdBy,
      dbGroupWallpaper: groupWallpaper,
    };
  }

  GroupModel copyWith({
    String? groupID,
    String? groupName,
    String? groupProfileImage,
    List<String>? groupMembers,
    List<String>? groupAdmins,
    String? groupDescription,
    List<MembersGroupPermission>? membersPermissions,
    List<AdminsGroupPermission>? adminsPermissions,
    String? groupCreatedAt,
    bool? isMuted,
    MessageStatus? lastMessageStatus,
    String? lastMessage,
    String? lastMessageTime,
    MessageType? lastMessageType,
    int? notificationCount,
    bool? isIncomingMessage,
    bool? isGroupOpen,
    String? createdBy,
    String? groupWallpaper,
  }) {
    return GroupModel(
      groupID: groupID ?? this.groupID,
      groupName: groupName ?? this.groupName,
      groupProfileImage: groupProfileImage ?? this.groupProfileImage,
      groupMembers: groupMembers ?? this.groupMembers,
      groupAdmins: groupAdmins ?? this.groupAdmins,
      groupDescription: groupDescription ?? this.groupDescription,
      membersPermissions: membersPermissions ?? this.membersPermissions,
      adminsPermissions: adminsPermissions ?? this.adminsPermissions,
      groupCreatedAt: groupCreatedAt ?? this.groupCreatedAt,
      isGroupOpen: isGroupOpen ?? this.isGroupOpen,
      isIncomingMessage: isIncomingMessage ?? this.isIncomingMessage,
      isMuted: isMuted ?? this.isMuted,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageStatus: lastMessageStatus ?? this.lastMessageStatus,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      notificationCount: notificationCount ?? this.notificationCount,
      createdBy: createdBy??this.createdBy,
      groupWallpaper: groupWallpaper ?? this.groupWallpaper
    );
  }
}
