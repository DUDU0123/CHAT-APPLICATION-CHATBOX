import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/image_picker_method.dart';
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
  }

  Future<FutureOr<void>> getCurrentUserData(
      GetCurrentUserData event, Emitter<UserState> emit) async {
    try {
      log("Current User: userbloc: ${firebaseAuth.currentUser?.uid}");
      UserModel? currentUser = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);
      if (currentUser != null) {
      
        emit(CurrentUserLoadedState(currentUserData: currentUser));
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
        emit(CurrentUserLoadedState(currentUserData: updatedUser));
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
        //await Future.delayed(const Duration(seconds: 1), () {
        emit(CurrentUserLoadedState(currentUserData: updatedUser));
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
        emit(CurrentUserLoadedState(currentUserData: nonEditedUser));
      }
    } catch (e) {
      emit(ImagePickErrorState(message: e.toString()));
    }
  }
}
