part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class LoadCurrentUserData extends UserState{}

class CurrentUserLoadedState extends UserState {
  final UserModel currentUserData;
  const CurrentUserLoadedState({
    required this.currentUserData,
  });
  @override
  List<Object> get props => [currentUserData,];
}

class CurrentUserEditState extends UserState{}

class CurrentUserDeleteState extends UserState{}

class CurrentUserDeleteErrorState extends UserState{
  final String message;
  const CurrentUserDeleteErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message,];
}

class CurrentUserErrorState extends UserState {
  final String message;
  const CurrentUserErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message,];
}

class ImagePickErrorState extends UserState{
  final String message;
  const ImagePickErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message,];
}