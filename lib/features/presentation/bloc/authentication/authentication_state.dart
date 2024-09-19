part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final Country? country;
  final bool isUserSignedIn;
  final String? message;
  final bool? isLoading;
  final UserModel? user;
  final bool? isUserCreated;
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
  AuthenticationState({
    this.message,
    this.isUserCreated,
    this.user,
    this.isLoading,
    this.country,
    this.isUserSignedIn = false,
  });
  AuthenticationState copyWith({
    Country? country,
    bool? isUserSignedIn,
    bool? isUserCreated,
    String? message,
    UserModel? user,
    bool? isLoading,
  }) {
    return AuthenticationState(
      user: user ?? this.user,
      isUserCreated: isUserCreated ?? this.isUserCreated,
      country: country ?? this.country,
      isUserSignedIn: isUserSignedIn ?? this.isUserSignedIn,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [
        country ?? selectedCountry,
        isUserSignedIn,
        isLoading ?? false,
        isUserCreated ?? false,
        message ?? '',
        user ?? const UserModel(),
      ];
}

class AuthenticationInitial extends AuthenticationState {
  final bool isUserSignedIn;
  AuthenticationInitial({
    required this.isUserSignedIn,
  });
  @override
  List<Object> get props => [
        isUserSignedIn,
      ];
}
