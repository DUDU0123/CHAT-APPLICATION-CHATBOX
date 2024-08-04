part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CountrySelectedEvent extends AuthenticationEvent {
  final Country selectedCountry;
  const CountrySelectedEvent({
    required this.selectedCountry,
  });
  @override
  List<Object> get props => [selectedCountry,];
}

class OtpSentEvent extends AuthenticationEvent {
  final String? phoneNumberWithCountryCode;
  final BuildContext context;
  const OtpSentEvent({
    required this.phoneNumberWithCountryCode,
    required this.context,
  });
  @override
  List<Object> get props => [phoneNumberWithCountryCode??'+91', context];
}

class CreateUserEvent extends AuthenticationEvent {
  final BuildContext context;
  final String otpCode;
  final String verificationId;
  final String phoneNumber;
  const CreateUserEvent({
    required this.context,
    required this.otpCode,
    required this.verificationId,
    required this.phoneNumber,
  });
  @override
  List<Object> get props => [context, verificationId, otpCode, phoneNumber,];
}

class ResendOtpEvent extends AuthenticationEvent {
  final String? phoneNumberWithCountryCode;
  final BuildContext context;
  final int? forceResendingToken;
  const ResendOtpEvent({
    this.phoneNumberWithCountryCode,
    required this.context,
    this.forceResendingToken,
  });
  @override
  List<Object> get props => [phoneNumberWithCountryCode??"", context, forceResendingToken??0];
}

class CheckUserLoggedInEvent extends AuthenticationEvent{}

class UserPermanentDeleteEvent extends AuthenticationEvent {
  final String phoneNumberWithCountryCode;
  final  BuildContext context;
  const UserPermanentDeleteEvent({
    required this.phoneNumberWithCountryCode,
    required this.context,
  });
  @override
  List<Object> get props => [phoneNumberWithCountryCode];
}
