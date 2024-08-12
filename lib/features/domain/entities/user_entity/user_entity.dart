import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? userName;
  final String? phoneNumber;
  final String? contactName;
  final String? userEmailId;
  final String? userAbout;
  final String? userProfileImage;
  final bool? userNetworkStatus;
  final String? createdAt;
  final String? tfaPin;
  final bool? isBlockedUser;
  final bool? isDisabled;
  final String? lastActiveTime;
  final List<dynamic>? userGroupIdList;
  final Map<String, dynamic>? privacySettings;
  final String? notificationTone;
  final String? ringTone;
  final String? notificationName;
  final String? ringtoneName;
  const UserEntity({
    this.id,
    this.userName,
    this.phoneNumber,
    this.contactName,
    this.userEmailId,
    this.userAbout,
    this.userProfileImage,
    this.userNetworkStatus,
    this.createdAt,
    this.tfaPin,
    this.isBlockedUser,
    this.isDisabled,
    this.lastActiveTime,
    this.userGroupIdList,
    this.privacySettings,
    this.notificationTone,
    this.ringTone,
    this.notificationName,
    this.ringtoneName,
  });

  @override
  List<Object?> get props {
    return [
      id,
      userName,
      phoneNumber,
      userEmailId,
      contactName,
      userAbout,
      userProfileImage,
      userNetworkStatus,
      createdAt,
      tfaPin,
      isBlockedUser,
      userGroupIdList,
      isDisabled,
      lastActiveTime,
      privacySettings,
      notificationTone,
      ringTone,
      notificationName,
      ringtoneName,
    ];
  }
}
