import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/authentication_repo/authentication_repo.dart';

class UserData {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth fireBaseAuth;
  final AuthenticationRepo authenticationRepo;
  UserData({
    required this.firestore,
    required this.firebaseStorage,
    required this.fireBaseAuth,
    required this.authenticationRepo,
  });

  // Method to get all users
  Future<List<UserModel>> getAllUsersFromDataBase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> allUsersQuerySnapshot =
          await firestore.collection(usersCollection).get();
      return allUsersQuerySnapshot.docs
          .map(
            (doc) => UserModel.fromJson(
              map: doc.data(),
            ),
          )
          .toList();
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while fetching all user: $e");
    } catch (e) {
      throw Exception("Error while fetching all users: $e");
    }
  }

  static Stream<UserModel?> getOneUserDataFromDataBaseAsStream(
      {required String userId}) {
    try {
      return fireStore.collection(usersCollection).doc(userId).snapshots().map(
            (event) => UserModel.fromJson(
              map: event.data() ?? {},
            ),
          );
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while fetching user data: $e");
    } catch (e) {
      throw Exception("Error while fetching user data: $e");
    }
  }

  // Method to get one user by ID
  Future<UserModel?> getOneUserDataFromDataBase(
      {required String userId}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection(usersCollection).doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromJson(map: documentSnapshot.data()!);
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while fetching user data: $e");
    } catch (e) {
      throw Exception("Error while fetching user data: $e");
    }
  }

  // Method to save user data to DB
  Future<void> saveUserDataToDB(
      {required UserModel userData, File? profileImage}) async {
    try {
      if (profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
            ref: "profile_images/${userData.id}", file: profileImage);
        userData = userData.copyWith(userProfileImage: userProfileImage);
      }
      await firestore
          .collection(usersCollection)
          .doc(userData.id)
          .set(userData.toJson());
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while saving user data: $e");
    } catch (e) {
      throw Exception("Error while saving user data: $e");
    }
  }

  // Method to update user in DB
  Future<void> updateUserInDB({
    required UserModel userData,
    File? profileImage,
  }) async {
    try {
      if (profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
            ref: "profile_images/${userData.id}", file: profileImage);
        userData = userData.copyWith(userProfileImage: userProfileImage);
      }

      // Update user profile in users collection
      await firestore
          .collection(usersCollection)
          .doc(userData.id)
          .update(userData.toJson());

      // Update chat details where this user is a receiver
      await updateChatsWithNewReceiverInfo(userData);
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while updating user data: $e");
    } catch (e) {
      throw Exception("Error while updating user data: $e");
    }
  }

  // Method to update chat details with new receiver info
  Future<void> updateChatsWithNewReceiverInfo(UserModel updatedUser) async {
    try {
      // Fetch all users
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await firestore.collection(usersCollection).get();

      for (var userDoc in usersSnapshot.docs) {
        // Fetch chats for each user where the updatedUser is the receiver
        QuerySnapshot<Map<String, dynamic>> chatSnapshots = await firestore
            .collection(usersCollection)
            .doc(userDoc.id)
            .collection(chatsCollection)
            .where(receiverId, isEqualTo: updatedUser.id)
            .get();

        // Update each chat document with the new receiver info
        for (var chatDoc in chatSnapshots.docs) {
          await chatDoc.reference.update({
            receiverProfilePhoto: updatedUser.userProfileImage,
          });
        }
      }
    } catch (e) {
      throw Exception("Error while updating chats with new receiver info: $e");
    }
  }

  // Method to save user file to database storage
  Future<String> saveUserFileToDataBaseStorage({
    required String ref,
    required File file,
  }) async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while saving file to storage: $e");
    } catch (e) {
      throw Exception("Error while saving file to storage: $e");
    }
  }

  // Method to save current user profile image to DB
  Future<void> saveUserProfileImageToDatabase({
    required File? profileImage,
    required UserModel currentUser,
  }) async {
    try {
      if (currentUser != null && profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
          ref: "$usersProfileImageFolder${currentUser.id}",
          file: profileImage,
        );
        await firestore.collection(usersCollection).doc(currentUser.id).update({
          'profileImage': userProfileImage,
        });
        await updateChatsWithNewReceiverInfo(currentUser);
      } else {}
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while saving profile image to database: $e");
    } catch (e) {
      throw Exception("Error while saving profile image to database: $e");
    }
  }

  Future<bool?> blockAUser({
    required BlockedUserModel blockedUserModel,
    required String? chatId,
  }) async {
    try {
      final currentUser = fireBaseAuth.currentUser;
      DocumentReference<Map<String, dynamic>> blockedUserDoc = await firestore
          .collection(usersCollection)
          .doc(currentUser?.uid)
          .collection(blockedUsersCollection)
          .add(blockedUserModel.toJson());
      final blockedUserDocId = blockedUserDoc.id;
      final updatedBlockedUser = blockedUserModel.copyWith(
        id: blockedUserDocId,
      );
      await firestore
          .collection(usersCollection)
          .doc(currentUser?.uid)
          .collection(blockedUsersCollection)
          .doc(blockedUserDocId)
          .update(
            updatedBlockedUser.toJson(),
          );

      return true;
    } on FirebaseException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool?> removeFromBlockedUser({
    required String blockedUserId,
  }) async {
    try {
      final currentUser = fireBaseAuth.currentUser;

      await firestore
          .collection(usersCollection)
          .doc(currentUser?.uid)
          .collection(blockedUsersCollection)
          .doc(blockedUserId)
          .delete();
      return true;
    } on FirebaseException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  Stream<List<BlockedUserModel>>? getAllBlockedUsers() {
    try {
      final currentUser = fireBaseAuth.currentUser;
      return firestore
          .collection(usersCollection)
          .doc(currentUser?.uid)
          .collection(blockedUsersCollection)
          .snapshots()
          .map((blockedUserSnapshot) {
        return blockedUserSnapshot.docs
            .map(
              (blockedUserDoc) => BlockedUserModel.fromJson(
                map: blockedUserDoc.data(),
              ),
            )
            .toList();
      });
    } on FirebaseException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateTFAPin({
    required String tfaPin,
  }) async {
    try {
      await fireStore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser?.uid)
          .update({
        userDbTFAPin: tfaPin,
      });
      return true;
    } on FirebaseException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }
}
