import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';

class GroupEntity extends Equatable {
  final String? groupID;
  final String? groupCreatedAt;
  final String? groupProfileImage;
  final bool? isMuted;
  final MessageStatus? lastMessageStatus;
  final String? lastMessage;
  final String? lastMessageTime;
  final MessageType? lastMessageType;
  final int? notificationCount;
  final bool? isIncomingMessage;
  final bool? isGroupOpen;
  final String? groupName;
  final String? createdBy;
  final List<String>? groupMembers;
  final List<String>? groupAdmins;
  final String? groupDescription;
  final String? groupWallpaper;
  final List<MembersGroupPermission>? membersPermissions;
  final List<AdminsGroupPermission>? adminsPermissions;
  const GroupEntity({
    this.groupID,
    this.groupCreatedAt,
    this.groupProfileImage,
    this.isMuted,
    this.lastMessageStatus,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageType,
    this.notificationCount,
    this.isIncomingMessage,
    this.isGroupOpen,
    this.groupName,
    this.createdBy,
    this.groupMembers,
    this.groupAdmins,
    this.groupDescription,
    this.groupWallpaper,
    this.membersPermissions,
    this.adminsPermissions,
  });

  @override
  List<Object?> get props {
    return [
      groupID,
      groupProfileImage,
      groupName,
      groupMembers,
      groupAdmins,
      groupDescription,
      membersPermissions,
      adminsPermissions,
      groupCreatedAt,
      isMuted,
      lastMessageStatus,
      lastMessage,
      lastMessageTime,
      lastMessageType,
      notificationCount,
      isIncomingMessage,
      isGroupOpen,
      createdBy,
      groupWallpaper,
    ];
  }
}
