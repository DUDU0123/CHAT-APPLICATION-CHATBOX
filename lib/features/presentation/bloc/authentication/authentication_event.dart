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
  List<Object> get props => [
        selectedCountry,
      ];
}

class CreateUserEvent extends AuthenticationEvent {
  final BuildContext context;
  final String email;
  final String password;
  final String phoneNumberWithCountryCode;
  const CreateUserEvent({
    required this.context,
    required this.email,
    required this.password,
    required this.phoneNumberWithCountryCode,
  });
  @override
  List<Object> get props => [
        context,
        email,
        password,
        phoneNumberWithCountryCode,
      ];
}


class CheckUserLoggedInEvent extends AuthenticationEvent {}

class UserPermanentDeleteEvent extends AuthenticationEvent {
  final BuildContext context;
  final bool mounted;
  const UserPermanentDeleteEvent({
    required this.context,
    required this.mounted,
  });
  @override
  List<Object> get props => [
        context,
        mounted,
      ];
}
