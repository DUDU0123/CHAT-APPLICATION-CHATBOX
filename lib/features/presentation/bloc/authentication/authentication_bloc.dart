import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:country_picker/country_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
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
    on<CreateUserEvent>(createUserEvent);
    on<CheckUserLoggedInEvent>(checkUserLoggedInEvent);
    on<CountrySelectedEvent>(countrySelectedEvent);
    on<UserPermanentDeleteEvent>(userPermanentDeleteEvent);
    add(CheckUserLoggedInEvent());
  }

  Future<FutureOr<void>> createUserEvent(
      CreateUserEvent event, Emitter<AuthenticationState> emit) async {
    try {
      RegExp phoneRegExp =
          RegExp(r'^\+?(\d{1,3})?[-. ]?(\(?\d{3}\)?)[-. ]?\d{3}[-. ]?\d{4}$');
      RegExp emailRegExp =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      RegExp passwordRegExp = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

      if (event.email.isNotEmpty &&
          emailRegExp.hasMatch(event.email) &&
          event.password.isNotEmpty &&
          phoneRegExp.hasMatch(event.phoneNumberWithCountryCode)) {
        final isNumberAlreadyExist =
            await CommonDBFunctions.isPhoneNumberAlreadyExists(
                phoneNumber: event.phoneNumberWithCountryCode);
        if (!isNumberAlreadyExist) {
          if (event.password.length >= 8 &&
              passwordRegExp.hasMatch(event.password)) {
            emit(state.copyWith(isLoading: true));
            UserModel newUser = UserModel(
                createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                phoneNumber: event.phoneNumberWithCountryCode,
                password: event.password,
                userEmailId: event.email,
                lastActiveTime: "Online",
                privacySettings: const {
                  userDbLastSeenOnline: 'Everyone',
                  userDbProfilePhotoPrivacy: 'Everyone',
                  userDbAboutPrivacy: 'Everyone',
                  userDbStatusPrivacy: "Everyone",
                });
            final isCreated = await authenticationRepo
                .createAccountInChatBoxUsingEmailAndPassword(newUser: newUser);
            if (isCreated) {
              emit(
                state.copyWith(
                  user: newUser,
                  isUserCreated: isCreated,
                  isLoading: false,
                  message: null,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  message: 'Entered credentials are not valid',
                  isUserCreated: isCreated,
                ),
              );
            }
          } else {
            emit(
              state.copyWith(
                message:
                    'Password must be at least 8 characters long and include one uppercase letter, one lowercase letter, one number, and one special character',
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              message: 'Number already exists',
            ),
          );
        }
      } else {
        emit(state.copyWith(message: 'Enter valid data'));
      }
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  Future<FutureOr<void>> userPermanentDeleteEvent(
      UserPermanentDeleteEvent event, Emitter<AuthenticationState> emit) async {
    try {
      UserModel? currentUser = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);
      if (currentUser != null) {
        emit(state.copyWith(isLoading: true));
        final isDeleted = await authenticationRepo.deleteUserInDataBase(
            userId: currentUser.id!);
        if (isDeleted) {
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
          emit(
              state.copyWith(isUserSignedIn: userAuthStatus, isLoading: false));
        } else {
          emit(state.copyWith(message: "Unable to delete account"));
        }
      } else {
        log("User is null");
        emit(state.copyWith(message: "User is null"));
      }
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
        ),
      );
    }
  }

  Future<FutureOr<void>> checkUserLoggedInEvent(
      CheckUserLoggedInEvent event, Emitter<AuthenticationState> emit) async {
    try {
      final bool userAuthStatus = await authenticationRepo.getUserAthStatus();
      // emit(AuthenticationInitial(isUserSignedIn: userAuthStatus));
      emit(AuthenticationState(isUserSignedIn: userAuthStatus));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  FutureOr<void> countrySelectedEvent(
      CountrySelectedEvent event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationState(country: event.selectedCountry));
  }
}
