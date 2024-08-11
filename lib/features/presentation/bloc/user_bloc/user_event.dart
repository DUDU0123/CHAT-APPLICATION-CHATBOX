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
  List<Object> get props => [chatId??''];
}
class RemoveBlockedUserEvent extends UserEvent {
  final String blockedUserId;
  const RemoveBlockedUserEvent({
    required this.blockedUserId,
  });
  @override
  List<Object> get props => [blockedUserId];
}
class GetBlockedUserEvent extends UserEvent{
  
}