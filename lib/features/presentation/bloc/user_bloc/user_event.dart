part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class PickProfileImageFromDevice extends UserEvent {
  final ImageSource imageSource;
  const PickProfileImageFromDevice({
    required this.imageSource,
  });
  @override
  List<Object> get props => [imageSource];
}

class GetCurrentUserData extends UserEvent {}

class EditCurrentUserData extends UserEvent {
  final UserModel userModel;
  final File? userProfileImage;
  const EditCurrentUserData({
    this.userProfileImage,
    required this.userModel,
  });
  @override
  List<Object> get props => [userModel, userProfileImage ?? File('')];
}

class DeleteUserPermenantEvent extends UserEvent {
  final String? phoneNumberWithCountryCode;
  const DeleteUserPermenantEvent({
    this.phoneNumberWithCountryCode,
  });
  @override
  List<Object> get props => [phoneNumberWithCountryCode ?? ''];
}

class BlockUserEvent extends UserEvent {
  final BlockedUserModel blockedUserModel;
  final String? chatId;
  const BlockUserEvent({
    required this.blockedUserModel,
    required this.chatId,
  });
  @override
  List<Object> get props => [chatId ?? ''];
}

class RemoveBlockedUserEvent extends UserEvent {
  final String blockedUserId;
  const RemoveBlockedUserEvent({
    required this.blockedUserId,
  });
  @override
  List<Object> get props => [blockedUserId];
}

class GetBlockedUserEvent extends UserEvent {}

class UpdateTFAPinEvent extends UserEvent {
  final String tfAPin;
  const UpdateTFAPinEvent({
    required this.tfAPin,
  });
  @override
  List<Object> get props => [
        tfAPin,
      ];
}

class SetNoficationSoundEvent extends UserEvent {
  final File notficationSoundFile;
  final String notificationName;
  const SetNoficationSoundEvent({
    required this.notficationSoundFile,
    required this.notificationName,
  });
  @override
  List<Object> get props => [
        notficationSoundFile,
        notificationName,
      ];
}

class SetRingtoneSoundEvent extends UserEvent {
  final File ringtoneSoundFile;
  final String ringtoneName;
  const SetRingtoneSoundEvent({
    required this.ringtoneSoundFile,
    required this.ringtoneName,
  });
  @override
  List<Object> get props => [
        ringtoneSoundFile,
        ringtoneName,
      ];
}
class LastSeenPrivacyChangeEvent extends UserEvent {
  final int? currentValue;
  const LastSeenPrivacyChangeEvent({
    required this.currentValue,
  });
   @override
  List<Object> get props => [currentValue??1];
}
class ProfilePhotoPrivacyChangeEvent extends UserEvent{
  final int? currentValue;
  const ProfilePhotoPrivacyChangeEvent({
    required this.currentValue,
  });
   @override
  List<Object> get props => [currentValue??1];
}
class AboutPrivacyChangeEvent extends UserEvent{
  final int? currentValue;
  const AboutPrivacyChangeEvent({
    required this.currentValue,
  });
   @override
  List<Object> get props => [currentValue??1];
}

class ProfileImageShowCheckerEvent extends UserEvent {
  final String? receiverID;
 const ProfileImageShowCheckerEvent({
    this.receiverID,
  });
  @override
  List<Object> get props => [receiverID??''];
}

class OnlineStatusShowCheckerEvent extends UserEvent {
  final String? receiverID;
 const OnlineStatusShowCheckerEvent({
    this.receiverID,
  });
  @override
  List<Object> get props => [receiverID??''];
}
class AboutShowCheckerEvent extends UserEvent {
  final String? receiverID;
 const AboutShowCheckerEvent({
    this.receiverID,
  });
  @override
  List<Object> get props => [receiverID??''];
}
