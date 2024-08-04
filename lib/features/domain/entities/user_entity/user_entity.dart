import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  String? id;
  String? userName;
  String? phoneNumber;
  String? contactName;
  String? userEmailId;
  String? userAbout;
  String? userProfileImage;
  bool? userNetworkStatus;
  String? createdAt;
  String? tfaPin;
  bool? isBlockedUser;
  bool? isDisabled;
  String? lastActiveTime;
  List<dynamic>? userGroupIdList;
  UserEntity({
    this.id,
    this.userName,
    this.phoneNumber,
    this.userEmailId,
    this.userAbout,
    this.contactName,
    this.userProfileImage,
    this.userNetworkStatus,
    this.createdAt,
    this.tfaPin,
    this.isBlockedUser,
    this.userGroupIdList,
    this.isDisabled,
    this.lastActiveTime,
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
    ];
  }
}
