part of 'privacy_bloc.dart';

sealed class PrivacyEvent extends Equatable {
  const PrivacyEvent();

  @override
  List<Object> get props => [];
}

class LastSeenPrivacyChangeEvent extends PrivacyEvent {
  final int? currentValue;
  const LastSeenPrivacyChangeEvent({
    required this.currentValue,
  });
   @override
  List<Object> get props => [currentValue??1];
}
class ProfilePhotoPrivacyChangeEvent extends PrivacyEvent{
  final int? currentValue;
  const ProfilePhotoPrivacyChangeEvent({
    required this.currentValue,
  });
   @override
  List<Object> get props => [currentValue??1];
}
class AboutPrivacyChangeEvent extends PrivacyEvent{
  final int? currentValue;
  const AboutPrivacyChangeEvent({
    required this.currentValue,
  });
   @override
  List<Object> get props => [currentValue??1];
}
class GetAllBlockedContactsEvent extends PrivacyEvent{}