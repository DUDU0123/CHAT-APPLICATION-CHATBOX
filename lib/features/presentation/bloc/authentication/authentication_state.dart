part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final Country? country;
   Country selectedCountry = Country(
    phoneCode: "+91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );
   AuthenticationState({this.country});
  @override
  List<Object> get props => [country??selectedCountry,];
}

class AuthenticationInitial extends AuthenticationState {
  final bool isUserSignedIn;
  AuthenticationInitial({
    required this.isUserSignedIn,
  });
  @override
  List<Object> get props => [isUserSignedIn,];
}

class AuthenticationLoadingState extends AuthenticationState {}

class OtpSentState extends AuthenticationState{}
class OtpReSentState extends AuthenticationState{}
class AuthenticationSuccessState extends AuthenticationState {
  final UserModel user;
   AuthenticationSuccessState({
    required this.user,
  });
  @override
  List<Object> get props => [user];
}

class AuthenticationErrorState extends AuthenticationState {
  final String message;
   AuthenticationErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
