import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:country_picker/country_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/app_methods.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/authentication_repo/authentication_repo.dart';
import 'package:official_chatbox_application/features/domain/repositories/user_repo/user_repository.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/wrapper/wrapper_page.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepo authenticationRepo;
  final UserRepository userRepository;
  final FirebaseAuth firebaseAuth;
  AuthenticationBloc({
    required this.authenticationRepo,
    required this.userRepository,
    required this.firebaseAuth,
  }) : super(AuthenticationInitial(isUserSignedIn: false)) {
    on<OtpSentEvent>(otpSentEvent);
    on<CreateUserEvent>(verifyOtpAndcreateUserEvent);
    on<CheckUserLoggedInEvent>(checkUserLoggedInEvent);
    on<CountrySelectedEvent>(countrySelectedEvent);
    on<ResendOtpEvent>(resendOtpEvent);
    on<UserPermanentDeleteEvent>(userPermanentDeleteEvent);
    add(CheckUserLoggedInEvent());
  }

  Future<FutureOr<void>> userPermanentDeleteEvent(
      UserPermanentDeleteEvent event, Emitter<AuthenticationState> emit) async {
    try {
      UserModel? currentUser = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);
      if (currentUser != null) {
        if (event.phoneNumberWithCountryCode.toString().replaceAll(' ', '') ==
            currentUser.phoneNumber) {
          emit(AuthenticationLoadingState());
          if (event.mounted) {
            await userRepository.deleteUserInDataBase(
              userId: currentUser.id!,
              fullPathToFile: "$usersProfileImageFolder${currentUser.id}",
              context: event.context,
              phoneNumber: event.phoneNumberWithCountryCode,
            );
          }
          final bool userAuthStatus =
              await authenticationRepo.getUserAthStatus();
          log("Auth status after deletion: $userAuthStatus");
          if (event.mounted) {
            Navigator.pushAndRemoveUntil(
              event.context,
              MaterialPageRoute(
                builder: (context) => const WrapperPage(),
              ),
              (route) => false,
            );
          }
          emit(state.copyWith(isUserSignedIn: userAuthStatus));
        } else {
          emit(AuthenticationErrorState(
              message: "Entered phone number is not correct"));
        }
      } else {
        log("User is null");
        emit(AuthenticationErrorState(message: "User is null"));
      }
    } catch (e) {
      emit(
        AuthenticationErrorState(
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> otpSentEvent(
      OtpSentEvent event, Emitter<AuthenticationState> emit) {
    try {
      log(event.phoneNumberWithCountryCode.toString());
      RegExp phoneRegExp =
          RegExp(r'^\+?(\d{1,3})?[-. ]?(\(?\d{3}\)?)[-. ]?\d{3}[-. ]?\d{4}$');
      if ((event.phoneNumberWithCountryCode != null &&
          phoneRegExp.hasMatch(event.phoneNumberWithCountryCode!))) {
        log("IF COndition inside try");
        log("Has Match");
        authenticationRepo.createAccountInChatBoxUsingPhoneNumber(
            context: event.context,
            phoneNumber: event.phoneNumberWithCountryCode!);
        emit(OtpSentState());
      } else {
        log("Else COndition inside try");
        emit(AuthenticationErrorState(message: "Enter valid phone number"));
      }
    } catch (e) {
      log("Catch error");
      emit(AuthenticationErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> verifyOtpAndcreateUserEvent(
      CreateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoadingState());
    try {
      if (event.otpCode.length == 6) {
        final userCredential = await authenticationRepo.verifyOtp(
          context: event.context,
          verificationId: event.verificationId,
          otpCode: event.otpCode,
          onSuccess: () {},
        );
        final userData = await CommonDBFunctions.getOneUserDataFromDBFuture(
            userId: userCredential.user?.uid);
        if (userData != null) {
          if (userData.isDisabled != null) {
            if (userData.isDisabled!) {
              AppMethods.pop();
            }
          }
        }
        UserModel userModel = UserModel(
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            id: userCredential.user?.uid,
            phoneNumber: userCredential.user?.phoneNumber,
            lastActiveTime: "Online",
            isDisabled: userData?.isDisabled,
            privacySettings: const {
              userDbLastSeenOnline: 'Everyone',
              userDbProfilePhotoPrivacy: 'Everyone',
              userDbAboutPrivacy: 'Everyone',
              userDbStatusPrivacy: "Everyone",
            });
        userRepository.saveUserDataToDataBase(userModel: userModel);
        emit(AuthenticationSuccessState(user: UserModel()));
        debugPrint("Hi From Bloc Verify Otp: ${userCredential.user?.uid}");
      } else {
        emit(AuthenticationErrorState(message: "Enter correct Otp"));
      }
    } catch (e) {
      emit(AuthenticationErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> checkUserLoggedInEvent(
      CheckUserLoggedInEvent event, Emitter<AuthenticationState> emit) async {
    try {
      final bool userAuthStatus = await authenticationRepo.getUserAthStatus();
      // emit(AuthenticationInitial(isUserSignedIn: userAuthStatus));
      emit(AuthenticationState(isUserSignedIn: userAuthStatus));

    } catch (e) {
      emit(AuthenticationErrorState(message: e.toString()));
    }
  }

  FutureOr<void> countrySelectedEvent(
      CountrySelectedEvent event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationState(country: event.selectedCountry));
  }

  FutureOr<void> resendOtpEvent(
      ResendOtpEvent event, Emitter<AuthenticationState> emit) {
    try {
      RegExp phoneRegExp =
          RegExp(r'^\+?(\d{1,3})?[-. ]?(\(?\d{3}\)?)[-. ]?\d{3}[-. ]?\d{4}$');
      if ((event.phoneNumberWithCountryCode != null &&
          phoneRegExp.hasMatch(event.phoneNumberWithCountryCode!))) {

        authenticationRepo.resentOtp(
          context: event.context,
          phoneNumber: event.phoneNumberWithCountryCode!,
          forceResendingToken: event.forceResendingToken,
        );
        emit(OtpReSentState());
      } else {
        emit(AuthenticationErrorState(message: "Enter valid phone number"));
      }
    } catch (e) {
      emit(AuthenticationErrorState(message: e.toString()));
    }
  }
}
