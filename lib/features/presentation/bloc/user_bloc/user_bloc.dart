import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/image_picker_method.dart';
import 'package:official_chatbox_application/core/utils/user_methods.dart';
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/user_repo/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth firebaseAuth;
  final UserRepository userRepository;
  UserBloc({
    required this.firebaseAuth,
    required this.userRepository,
  }) : super(UserInitial()) {
    on<GetCurrentUserData>(getCurrentUserData);
    on<EditCurrentUserData>(editCurrentUserData);
    on<PickProfileImageFromDevice>(pickProfileImageFromDevice);
    on<BlockUserEvent>(blockUserEvent);
    on<GetBlockedUserEvent>(getBlockedUserEvent);
    on<RemoveBlockedUserEvent>(removeBlockedUserEvent);
    on<UpdateTFAPinEvent>(updateTFAPinEvent);
    on<SetNoficationSoundEvent>(setNoficationSoundEvent);
    on<SetRingtoneSoundEvent>(setRingtoneSoundEvent);
    on<LastSeenPrivacyChangeEvent>(lastSeenPrivacyChangeEvent);
    on<ProfilePhotoPrivacyChangeEvent>(profilePhotoPrivacyChangeEvent);
    on<AboutPrivacyChangeEvent>(aboutPrivacyChangeEvent);
  }

  Future<FutureOr<void>> getCurrentUserData(
      GetCurrentUserData event, Emitter<UserState> emit) async {
    try {
      log("Current User: userbloc: ${firebaseAuth.currentUser?.uid}");
      UserModel? currentUser = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);
      if (currentUser != null) {
        emit(UserState(currentUserData: currentUser));
      } else {
        log("User model is null error");
      }
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> editCurrentUserData(
      EditCurrentUserData event, Emitter<UserState> emit) async {
    try {
      UserModel? currentUser = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);

      if (currentUser != null) {
        UserModel updatedUser = currentUser.copyWith(
          userName: event.userModel.userName ?? currentUser.userName,
          userAbout: event.userModel.userAbout ?? currentUser.userAbout,
          userProfileImage: currentUser.userProfileImage,
        );
        await userRepository.updateUserInDataBase(
          userModel: updatedUser,
        );
        // emit(CurrentUserLoadedState(currentUserData: updatedUser));
        emit(state.copyWith(currentUserData: updatedUser));
      } else {
        emit(const CurrentUserErrorState(message: "User is null"));
      }
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> pickProfileImageFromDevice(
      PickProfileImageFromDevice event, Emitter<UserState> emit) async {
    emit(LoadCurrentUserData());
    try {
      final pickedImage = await pickImage(imageSource: event.imageSource);
      UserModel? currentUser = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);
      if (pickedImage != null && currentUser != null) {
        String? userProfileImageUrl =
            await userRepository.saveUserFileToDBStorage(
          ref: "$usersProfileImageFolder${currentUser.id}",
          file: pickedImage,
        );
        UserModel updatedUser = currentUser.copyWith(
          userProfileImage: userProfileImageUrl,
        );
        await userRepository.updateUserInDataBase(
          userModel: updatedUser,
        );
        log("User Profie image: $userProfileImageUrl");

        emit(state.copyWith(currentUserData: updatedUser));

        // },);
      } else {
        log("Picked Image is null");
        UserModel nonEditedUser = currentUser!.copyWith(
          createdAt: currentUser.createdAt,
          isBlockedUser: currentUser.isBlockedUser,
          id: currentUser.id,
          phoneNumber: currentUser.phoneNumber,
          tfaPin: currentUser.tfaPin,
          userAbout: currentUser.userAbout,
          userEmailId: currentUser.userEmailId,
          userGroupIdList: currentUser.userGroupIdList,
          userName: currentUser.userName,
          userNetworkStatus: currentUser.userNetworkStatus,
          userProfileImage: currentUser.userProfileImage,
        );
        emit(state.copyWith(currentUserData: nonEditedUser));
      }
    } catch (e) {
      emit(ImagePickErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> blockUserEvent(
      BlockUserEvent event, Emitter<UserState> emit) async {
    try {
      final bool? value = await userRepository.blockUser(
        blockedUserModel: event.blockedUserModel,
        chatId: event.chatId,
      );
      log(name: "Is Blocked", value.toString());
      if (value != null) {
        if (value) {
          add(GetBlockedUserEvent());
        } else {
          emit(
              const BlockUserErrorState(errorMessage: "Unable to remove user"));
        }
      } else {
        emit(const BlockUserErrorState(errorMessage: "Unable to remove user"));
      }
    } catch (e) {
      emit(BlockUserErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> removeBlockedUserEvent(
      RemoveBlockedUserEvent event, Emitter<UserState> emit) async {
    try {
      final bool? value = await userRepository.removeBlockedUser(
          blockedUserId: event.blockedUserId);

      log(name: "Is Removed", value.toString());

      if (value != null) {
        if (value) {
          add(GetBlockedUserEvent());
        } else {
          emit(
              const BlockUserErrorState(errorMessage: "Unable to remove user"));
        }
      } else {
        emit(const BlockUserErrorState(errorMessage: "Unable to remove user"));
      }
    } catch (e) {
      emit(BlockUserErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getBlockedUserEvent(
      GetBlockedUserEvent event, Emitter<UserState> emit) {
    try {
      final blockedUsersList = userRepository.getAllBlockedUsersFromDB();
      emit(state.copyWith(
        blockedUsersList: blockedUsersList,
        currentUserData: state.currentUserData,
      ));
    } catch (e) {
      emit(BlockUserErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> updateTFAPinEvent(
      UpdateTFAPinEvent event, Emitter<UserState> emit) async {
    try {
      final value = await userRepository.updateTfaPinInDB(tfaPin: event.tfAPin);
      if (value) {
        emit(
          state.copyWith(
            blockedUsersList: state.blockedUsersList,
            currentUserData: state.currentUserData,
          ),
        );
      } else {
        emit(const CurrentUserErrorState(message: "Unable to change pin"));
      }
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  FutureOr<void> setNoficationSoundEvent(
      SetNoficationSoundEvent event, Emitter<UserState> emit) async {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      final soundFileString =
          await CommonDBFunctions.saveUserFileToDataBaseStorage(
              ref: 'notificationTones/$currentUserId',
              file: event.notficationSoundFile);
      await fireStore.collection(usersCollection).doc(currentUserId).update({
        userDbNotificationTone: soundFileString,
        userDBNotificationName: event.notificationName,
      });
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  FutureOr<void> setRingtoneSoundEvent(
      SetRingtoneSoundEvent event, Emitter<UserState> emit) async {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      final soundFileString =
          await CommonDBFunctions.saveUserFileToDataBaseStorage(
              ref: 'ringtones/$currentUserId', file: event.ringtoneSoundFile);
      await fireStore.collection(usersCollection).doc(currentUserId).update({
        userDbRingTone: soundFileString,
        userDBRingtoneName: event.ringtoneName,
      });
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> lastSeenPrivacyChangeEvent(
      LastSeenPrivacyChangeEvent event, Emitter<UserState> emit) async {
    try {
      await UserMethods.updatePrivacySettings(
        lastSeenGroupValue: event.currentValue,
        profilePhotoGroupValue: state.profilePhotoPrivacyGroupValue,
        aboutGroupValue: state.aboutPrivacyGroupValue,
      );

      emit(state.copyWith(
        blockedUsersList: state.blockedUsersList,
        currentUserData: state.currentUserData,
        lastSeenPrivacyGroupValue: event.currentValue,
        profilePhotoPrivacyGroupValue: state.profilePhotoPrivacyGroupValue,
        aboutPrivacyGroupValue: state.aboutPrivacyGroupValue,
      ));
      // here I want to hide the last seen and online status for all users other than the current user and the users in the contacts of the user, if the current user selected my contacts,
      // here I don't want to hide the last seen and online status for any users, if the current user selected eveyone
      // here I want to hide the last seen and online status for all users other than the current user, if the current user selected nobody
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> profilePhotoPrivacyChangeEvent(
      ProfilePhotoPrivacyChangeEvent event, Emitter<UserState> emit) async {
    try {
      await UserMethods.updatePrivacySettings(
        lastSeenGroupValue: state.lastSeenPrivacyGroupValue,
        profilePhotoGroupValue: event.currentValue,
        aboutGroupValue: state.aboutPrivacyGroupValue,
      );
      emit(state.copyWith(
        blockedUsersList: state.blockedUsersList,
        currentUserData: state.currentUserData,
        profilePhotoPrivacyGroupValue: event.currentValue,
        aboutPrivacyGroupValue: state.aboutPrivacyGroupValue,
        lastSeenPrivacyGroupValue: state.lastSeenPrivacyGroupValue,
      ));
      // here I want to hide the profile photo of the current user for all users other than the current user and the users in the contacts of the user, if the current user selected my contacts,
      // here I don't want to hide the profile photo of the current user for any users, if the current user selected eveyone
      // here I want to hide the profile photo of the current user for all users other than the current user, if the current user selected nobody
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> aboutPrivacyChangeEvent(
      AboutPrivacyChangeEvent event, Emitter<UserState> emit) async {
    try {
      await UserMethods.updatePrivacySettings(
        lastSeenGroupValue: state.lastSeenPrivacyGroupValue,
        profilePhotoGroupValue: state.profilePhotoPrivacyGroupValue,
        aboutGroupValue: event.currentValue,
      );
      emit(state.copyWith(
        blockedUsersList: state.blockedUsersList,
        currentUserData: state.currentUserData,
        aboutPrivacyGroupValue: event.currentValue,
        lastSeenPrivacyGroupValue: state.lastSeenPrivacyGroupValue,
        profilePhotoPrivacyGroupValue: state.profilePhotoPrivacyGroupValue,
      ));
      // here I want to hide the about of current user for all users other than the current user and the users in the contacts of the user, if the current user selected my contacts,
      // here I don't want to hide the labout of current user for any users, if the current user selected eveyone
      // here I want to hide the about of current user for all users other than the current user, if the current user selected nobody
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }
}
