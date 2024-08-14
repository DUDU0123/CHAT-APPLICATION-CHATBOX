part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState({
    this.currentUserData,
    this.blockedUsersList,
    this.lastSeenPrivacyGroupValue = 1,
    this.profilePhotoPrivacyGroupValue = 1,
    this.aboutPrivacyGroupValue = 1,
  });
  final UserModel? currentUserData;
  final Stream<List<BlockedUserModel>>? blockedUsersList;
  final int? lastSeenPrivacyGroupValue;
  final int? profilePhotoPrivacyGroupValue;
  final int? aboutPrivacyGroupValue;
  UserState copyWith({
    UserModel? currentUserData,
    Stream<List<BlockedUserModel>>? blockedUsersList,
    int? lastSeenPrivacyGroupValue =1 ,
    int? profilePhotoPrivacyGroupValue,
    int? aboutPrivacyGroupValue,
  }) {
    return UserState(
      currentUserData: currentUserData ?? this.currentUserData,
      blockedUsersList: blockedUsersList ?? this.blockedUsersList,
      aboutPrivacyGroupValue:
          aboutPrivacyGroupValue ?? this.aboutPrivacyGroupValue,
      lastSeenPrivacyGroupValue:
          lastSeenPrivacyGroupValue ?? this.lastSeenPrivacyGroupValue,
      profilePhotoPrivacyGroupValue:
          profilePhotoPrivacyGroupValue ?? this.profilePhotoPrivacyGroupValue,
    );
  }

  @override
  List<Object> get props => [
        currentUserData ?? UserModel(),
        blockedUsersList ?? [],
        lastSeenPrivacyGroupValue ?? 1,
        profilePhotoPrivacyGroupValue ?? 1,
        aboutPrivacyGroupValue ?? 1,
      ];
}

final class UserInitial extends UserState {}

class LoadCurrentUserData extends UserState {}

class CurrentUserEditState extends UserState {}

class CurrentUserDeleteState extends UserState {}

class CurrentUserDeleteErrorState extends UserState {
  final String message;
  const CurrentUserDeleteErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}

class CurrentUserErrorState extends UserState {
  final String message;
  const CurrentUserErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}

class ImagePickErrorState extends UserState {
  final String message;
  const ImagePickErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}

class BlockUserErrorState extends UserState {
  final String errorMessage;
  const BlockUserErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [errorMessage];
}
