part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState({
    this.currentUserData,
    this.blockedUsersList,
  });
  final UserModel? currentUserData;
  final Stream<List<BlockedUserModel>>? blockedUsersList;
  UserState copyWith(
      {UserModel? currentUserData,
      Stream<List<BlockedUserModel>>? blockedUsersList}) {
    return UserState(
      currentUserData: currentUserData ?? this.currentUserData,
      blockedUsersList: blockedUsersList ?? this.blockedUsersList,
    );
  }

  @override
  List<Object> get props => [
        currentUserData ?? UserModel(),
        blockedUsersList ?? [],
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
