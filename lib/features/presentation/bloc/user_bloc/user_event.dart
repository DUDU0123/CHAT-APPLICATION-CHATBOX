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

class GetCurrentUserData extends UserEvent{}
class EditCurrentUserData extends UserEvent {
  final UserModel userModel;
  File? userProfileImage;
  EditCurrentUserData({
    this.userProfileImage,
    required this.userModel,
  });
}
class DeleteUserPermenantEvent extends UserEvent {
  final String? phoneNumberWithCountryCode;
  const DeleteUserPermenantEvent({
    this.phoneNumberWithCountryCode,
  });
}
