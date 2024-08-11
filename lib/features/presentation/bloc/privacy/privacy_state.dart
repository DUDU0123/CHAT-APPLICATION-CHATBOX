part of 'privacy_bloc.dart';

class PrivacyState extends Equatable {
  const PrivacyState({
    this.lastSeenPrivacyGroupValue =1,
    this.profilePhotoPrivacyGroupValue=1,
    this.aboutPrivacyGroupValue=1,
  });
  final int? lastSeenPrivacyGroupValue;
  final int? profilePhotoPrivacyGroupValue;
  final int? aboutPrivacyGroupValue;
  PrivacyState copyWith({
    int? lastSeenPrivacyGroupValue =1 ,
    int? profilePhotoPrivacyGroupValue,
    int? aboutPrivacyGroupValue,
  }) {
    return PrivacyState(
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
        lastSeenPrivacyGroupValue ?? 1,
        profilePhotoPrivacyGroupValue ?? 1,
        aboutPrivacyGroupValue ?? 1,
      ];
}

final class PrivacyInitial extends PrivacyState {}

class LastSeenPrivacyChangeState extends PrivacyState {
  final int? currentValue;
  const LastSeenPrivacyChangeState({
    required this.currentValue,
  });
  @override
  List<Object> get props => [currentValue ?? 1];
}

class ProfilePhotoPrivacyChangeState extends PrivacyState {
  final int? currentValue;
  const ProfilePhotoPrivacyChangeState({
    required this.currentValue,
  });
  @override
  List<Object> get props => [currentValue ?? 1];
}

class AboutPrivacyChangeState extends PrivacyState {
  final int? currentValue;
  const AboutPrivacyChangeState({
    required this.currentValue,
  });
  @override
  List<Object> get props => [currentValue ?? 1];
}

class PrivacyErrorState extends PrivacyState {
  final String errorMessage;
  const PrivacyErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [errorMessage];
}
