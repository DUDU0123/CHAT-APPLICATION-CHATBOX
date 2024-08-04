import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/data/data_sources/user_data/user_data.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/user_repo/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final UserData userData;
  UserRepositoryImpl({
    required this.userData,
  });
  // method to get all users
  @override
  Future<List<UserModel>> getAllUsersFromDB() async {
    return userData.getAllUsersFromDataBase();
  }

  // method to get one user by id
  @override
  Future<UserModel?> getOneUserDataFromDB({required String userId}) async {
    return userData.getOneUserDataFromDataBase(userId: userId);
  }

  @override
  Future<void> saveUserDataToDataBase(
      {required UserModel userModel, File? profileImage}) async {
    userData.saveUserDataToDB(userData: userModel);
  }

  @override
  Future<void> updateUserInDataBase(
      {required UserModel userModel, File? profileImage}) async {
    userData.updateUserInDB(userData: userModel, profileImage: profileImage);
  }

  @override
  Future<void> deleteUserInDataBase({
    required String userId,
    String? fullPathToFile,
    required BuildContext context,
    required String phoneNumber,
  }) async {
    await userData.deleteUserInFireStoreDB(userId: userId);
    if (fullPathToFile != null) {
      await userData.deleteUserFilesInDB(fullPathToFile: fullPathToFile);
    }
    await userData.deleteUserAuthInDB(
      context: context,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<String> saveUserFileToDBStorage({
    required String ref,
    required File file,
  }) async {
    return await userData.saveUserFileToDataBaseStorage(ref: ref, file: file);
  }

  @override
  Future<void> saveUserProfileImageToDatabase(
      {required File? profileImage, required UserModel currentUser}) {
    return userData.saveUserProfileImageToDatabase(
        profileImage: profileImage, currentUser: currentUser);
  }

  // @override
  // Future<void> deleteUserFilesInDB({required String fullPathToFile}) {
  //   return userData.deleteUserFilesInDB(fullPathToFile: fullPathToFile);
  // }
}
