import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/core/utils/user_methods.dart';
part 'privacy_event.dart';
part 'privacy_state.dart';


class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  PrivacyBloc() : super(PrivacyInitial()) {
    on<LastSeenPrivacyChangeEvent>(lastSeenPrivacyChangeEvent);
    on<ProfilePhotoPrivacyChangeEvent>(profilePhotoPrivacyChangeEvent);
    on<AboutPrivacyChangeEvent>(aboutPrivacyChangeEvent);
    on<GetAllBlockedContactsEvent>(getAllBlockedContactsEvent);
  }

  Future<FutureOr<void>> lastSeenPrivacyChangeEvent(
      LastSeenPrivacyChangeEvent event, Emitter<PrivacyState> emit) async {
    try {
      await UserMethods.updatePrivacySettings(
        lastSeenGroupValue: event.currentValue,
        profilePhotoGroupValue: state.profilePhotoPrivacyGroupValue,
        aboutGroupValue: state.aboutPrivacyGroupValue,
      );

      emit(state.copyWith(
        lastSeenPrivacyGroupValue: event.currentValue,
        profilePhotoPrivacyGroupValue: state.profilePhotoPrivacyGroupValue,
        aboutPrivacyGroupValue: state.aboutPrivacyGroupValue,
      ));
      // here I want to hide the last seen and online status for all users other than the current user and the users in the contacts of the user, if the current user selected my contacts,
      // here I don't want to hide the last seen and online status for any users, if the current user selected eveyone
      // here I want to hide the last seen and online status for all users other than the current user, if the current user selected nobody
    } catch (e) {
      emit(PrivacyErrorState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> profilePhotoPrivacyChangeEvent(
      ProfilePhotoPrivacyChangeEvent event, Emitter<PrivacyState> emit) async {
    try {
      await UserMethods.updatePrivacySettings(
        lastSeenGroupValue: state.lastSeenPrivacyGroupValue,
        profilePhotoGroupValue: event.currentValue,
        aboutGroupValue: state.aboutPrivacyGroupValue,
      );
      emit(state.copyWith(
        profilePhotoPrivacyGroupValue: event.currentValue,
        aboutPrivacyGroupValue: state.aboutPrivacyGroupValue,
        lastSeenPrivacyGroupValue: state.lastSeenPrivacyGroupValue,
      ));
      // here I want to hide the profile photo of the current user for all users other than the current user and the users in the contacts of the user, if the current user selected my contacts,
      // here I don't want to hide the profile photo of the current user for any users, if the current user selected eveyone
      // here I want to hide the profile photo of the current user for all users other than the current user, if the current user selected nobody
    } catch (e) {
      emit(PrivacyErrorState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> aboutPrivacyChangeEvent(
      AboutPrivacyChangeEvent event, Emitter<PrivacyState> emit) async {
    try {
      await UserMethods.updatePrivacySettings(
        lastSeenGroupValue: state.lastSeenPrivacyGroupValue,
        profilePhotoGroupValue: state.profilePhotoPrivacyGroupValue,
        aboutGroupValue: event.currentValue,
      );
      emit(state.copyWith(
        aboutPrivacyGroupValue: event.currentValue,
        lastSeenPrivacyGroupValue: state.lastSeenPrivacyGroupValue,
        profilePhotoPrivacyGroupValue: state.profilePhotoPrivacyGroupValue,
      ));
      // here I want to hide the about of current user for all users other than the current user and the users in the contacts of the user, if the current user selected my contacts,
      // here I don't want to hide the labout of current user for any users, if the current user selected eveyone
      // here I want to hide the about of current user for all users other than the current user, if the current user selected nobody
    } catch (e) {
      emit(PrivacyErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getAllBlockedContactsEvent(
      GetAllBlockedContactsEvent event, Emitter<PrivacyState> emit) {
    try {} catch (e) {
      emit(PrivacyErrorState(errorMessage: e.toString()));
    }
  }
}
