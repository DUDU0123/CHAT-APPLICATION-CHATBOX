import 'dart:io';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';

abstract class UserRepository {
  Future<void> saveUserDataToDataBase({
    required UserModel userModel,
    File? profileImage,
  });
  Future<void> updateUserInDataBase({
    required UserModel userModel,
    File? profileImage,
  });
  Future<List<UserModel>> getAllUsersFromDB();
  Future<UserModel?> getOneUserDataFromDB({
    required String userId,
  });
  Future<void> deleteUserInDataBase({
    required String userId,
    String? fullPathToFile,
    required BuildContext context,
    required String phoneNumber,
  });
  Future<String> saveUserFileToDBStorage({
    required String ref,
    required File file,
  });
  Future<void> saveUserProfileImageToDatabase({
    required File? profileImage,
    required UserModel currentUser,
  });
  Future<bool?> blockUser({
    required BlockedUserModel blockedUserModel,
    required String? chatId,
  });
  Future<bool?> removeBlockedUser({
    required String blockedUserId,
  });
  Stream<List<BlockedUserModel>>? getAllBlockedUsersFromDB();
  // void userChangeNumber();
  // void reportUser();
}
