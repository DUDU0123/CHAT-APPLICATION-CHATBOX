import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/domain/entities/user_entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.password,
    super.userName,
    super.userEmailId,
    super.phoneNumber,
    super.userAbout,
    super.userProfileImage,
    super.userNetworkStatus,
    super.createdAt,
    super.tfaPin,
    super.isBlockedUser,
    super.userGroupIdList,
    super.isDisabled,
    super.lastActiveTime,
    super.contactName,
    super.privacySettings,
    super.notificationTone,
    super.ringTone,
    super.notificationName,
    super.ringtoneName,
    super.fcmToken,
  });

  factory UserModel.fromJson({required Map<String, dynamic> map}) {
    return UserModel(
        password: map[userDbPassword],
        id: map[userDbId],
        userName: map[userDbName] ?? 'chatbox user',
        userEmailId: map[userDbEmail] ?? '',
        phoneNumber: map[userDbPhoneNumber] ?? '',
        userAbout: map[userDbAbout] ?? 'chatbox about',
        userProfileImage: map[userDbProfileImage],
        userNetworkStatus: map[userDbNetworkStatus] ?? false,
        createdAt: map[userDbCreatedAt] ?? '',
        tfaPin: map[userDbTFAPin] ?? '',
        isBlockedUser: map[userDbBlockedStatus] ?? false,
        userGroupIdList: map[userDbGroupIdList] ?? [],
        isDisabled: map[isUserDisabled] ?? false,
        lastActiveTime: map[userDbLastActiveTime] ?? '00:00',
        contactName: map[userDbContactName] ?? '',
        privacySettings: map[userDbPrivacySettings] != null
            ? Map<String, dynamic>.from(map[userDbPrivacySettings])
            : {},
        notificationTone: map[userDbNotificationTone],
        ringTone: map[userDbRingTone],
        notificationName: map[userDBNotificationName],
        ringtoneName: map[userDBRingtoneName],
        fcmToken: map[userDbFcmToken]);
  }

  Map<String, dynamic> toJson() {
    return {
      userDbId: id,
      userDbName: userName,
      userDbPassword: password,
      userDbEmail: userEmailId,
      userDbPhoneNumber: phoneNumber,
      userDbAbout: userAbout,
      userDbProfileImage: userProfileImage,
      userDbNetworkStatus: userNetworkStatus,
      userDbCreatedAt: createdAt,
      userDbTFAPin: tfaPin,
      userDbBlockedStatus: isBlockedUser,
      userDbGroupIdList: userGroupIdList,
      isUserDisabled: isDisabled,
      userDbLastActiveTime: lastActiveTime,
      userDbContactName: contactName,
      userDbPrivacySettings: privacySettings,
      userDbNotificationTone: notificationTone,
      userDbRingTone: ringTone,
      userDBNotificationName: notificationName,
      userDBRingtoneName: ringtoneName,
      userDbFcmToken: fcmToken,
    };
  }

  UserModel copyWith({
    String? id,
    String? userName,
    String? userEmailId,
    String? phoneNumber,
    String? userAbout,
    String? userProfileImage,
    bool? userNetworkStatus,
    String? password,
    String? createdAt,
    String? tfaPin,
    bool? isBlockedUser,
    List<dynamic>? userGroupIdList,
    bool? isDisabled,
    String? lastActiveTime,
    String? notificationTone,
    String? ringTone,
    String? contactName,
    String? ringtoneName,
    String? notificationName,
    Map<String, dynamic>? privacySettings,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userEmailId: userEmailId ?? this.userEmailId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userAbout: userAbout ?? this.userAbout,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      userNetworkStatus: userNetworkStatus ?? this.userNetworkStatus,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
      tfaPin: tfaPin ?? this.tfaPin,
      isBlockedUser: isBlockedUser ?? this.isBlockedUser,
      userGroupIdList: userGroupIdList ?? this.userGroupIdList,
      isDisabled: isDisabled ?? this.isDisabled,
      lastActiveTime: lastActiveTime ?? this.lastActiveTime,
      contactName: contactName ?? this.contactName,
      privacySettings: privacySettings ?? this.privacySettings,
      notificationTone: notificationTone ?? this.notificationTone,
      ringTone: ringTone ?? this.ringTone,
      notificationName: notificationName ?? this.notificationName,
      ringtoneName: ringtoneName ?? this.ringtoneName,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
