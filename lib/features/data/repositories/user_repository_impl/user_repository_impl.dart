import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:official_chatbox_application/features/data/data_sources/user_data/user_data.dart';
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
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

  @override
  Future<bool?> blockUser({
    required BlockedUserModel blockedUserModel,
    required String? chatId,
  }) async {
    return await userData.blockAUser(
      blockedUserModel: blockedUserModel,
      chatId: chatId,
    );
  }

  @override
  Future<bool?> removeBlockedUser({required String blockedUserId}) async {
    return await userData.removeFromBlockedUser(blockedUserId: blockedUserId);
  }

  @override
  Stream<List<BlockedUserModel>>? getAllBlockedUsersFromDB() {
    return userData.getAllBlockedUsers();
  }

  @override
  Future<bool> updateTfaPinInDB({required String tfaPin}) {
    return userData.updateTFAPin(tfaPin: tfaPin);
  }
}
