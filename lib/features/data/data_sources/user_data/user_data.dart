import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/authentication_repo/authentication_repo.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

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
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching all user: $e");
    } catch (e, stackTrace) {
      log('Error while fetching all users: $e', stackTrace: stackTrace);
      throw Exception("Error while fetching all users: $e");
    }
  }

  static Stream<UserModel?> getOneUserDataFromDataBaseAsStream(
      {required String userId}) {
    try {
      return fireStore.collection(usersCollection).doc(userId).snapshots().map(
            (event) => UserModel.fromJson(
              map: event.data()??{},
            ),
          );
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching user data: $e");
    } catch (e, stackTrace) {
      log('Error while fetching user data: $e', stackTrace: stackTrace);
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
        log('User not found with ID: $userId');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching user data: $e");
    } catch (e, stackTrace) {
      log('Error while fetching user data: $e', stackTrace: stackTrace);
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
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while saving user data: $e");
    } catch (e, stackTrace) {
      log('Error while saving user data: $e', stackTrace: stackTrace);
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
      log("User data updating...");

      // Update user profile in users collection
      await firestore
          .collection(usersCollection)
          .doc(userData.id)
          .update(userData.toJson());

      // Update chat details where this user is a receiver
      await updateChatsWithNewReceiverInfo(userData);

      log("User data updated");
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while updating user data: $e");
    } catch (e, stackTrace) {
      log('Error while updating user data: $e', stackTrace: stackTrace);
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
    } catch (e, stackTrace) {
      log('Error while updating chats with new receiver info: $e',
          stackTrace: stackTrace);
      throw Exception("Error while updating chats with new receiver info: $e");
    }
  }

  // Method to delete user in DB
  Future<void> deleteUserInFireStoreDB({required String userId}) async {
    try {
      await firestore.collection(usersCollection).doc(userId).delete();
      final userDoc = firestore.collection(usersCollection).doc(userId);
      final userChats = userDoc.collection(chatsCollection);
      final userChatDocs = await userChats.get();
      for (final chatDocument in userChatDocs.docs) {
        if (chatDocument.exists) {
          await chatDocument.reference.delete();
        }
      }
      await userDoc.delete();
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while deleting user data: $e");
    } catch (e, stackTrace) {
      log('Error while deleting user data: $e', stackTrace: stackTrace);
      throw Exception("Error while deleting user data: $e");
    }
  }




  Future<void> deleteUserFilesInDB({required String fullPathToFile}) async {
    log(name: "FilePath", fullPathToFile);
    try {
      Reference fileReference = firebaseStorage.ref(fullPathToFile);
      // Check if the file exists by attempting to get its metadata
      await fileReference.getMetadata();

      // If the file exists, proceed to delete it
      await fileReference.delete();
      log('File deleted successfully');
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        log('File does not exist at path: $fullPathToFile');
        return;
      } else {
        log('Firebase exception: $e');
        throw Exception("Error while deleting user data: $e");
      }
    } catch (e) {
      log('Error while deleting user file: $e');
      throw Exception("Error while deleting user data: $e");
    }
  }

  Future<void> deleteUserAuthInDB({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      if (firebaseAuth.currentUser != null) {
        await firebaseAuth.currentUser?.delete();
        await authenticationRepo.setUserAuthStatus(isSignedIn: false);
      } else {
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        log('The user must reauthenticate before this operation can be executed.');
        await reAuthenticateUser(
          phoneNumber: phoneNumber,
          context: context,
        );
        await firebaseAuth.currentUser?.delete();
        await authenticationRepo.setUserAuthStatus(isSignedIn: false);
      }
    } catch (e) {
      log(
        'Error while deleting user from auth: $e',
      );
      throw Exception("Error while deleting user from auth: $e");
    }
  }

  Future<void> reAuthenticateUser({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    User? user = fireBaseAuth.currentUser;

    try {
      PhoneAuthCredential credential = await getPhoneAuthCredential(
        context: context,
        phoneNumber: phoneNumber,
      );
      log("User reauthicate 203 file: userdata: ${credential.verificationId}");
      await user?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      log('Reauthentication error: $e');
      throw Exception('Reauthentication error: $e');
    } catch (e) {
      log('No user is currently signed in');
      throw Exception('No user is currently signed in');
    }
  }

  Future<PhoneAuthCredential> getPhoneAuthCredential({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    TextEditingController smsController = TextEditingController();
    Completer<PhoneAuthCredential> completer = Completer();

    await fireBaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        completer.complete(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Prompt the user to enter the OTP
        // String smsCode;
        showDialog(
          context: context,
          builder: (context) => alertDialog(
            context: context,
            title: "Delete account confirmation",
            content: TextFieldCommon(
              keyboardType: TextInputType.number,
              controller: smsController,
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: smsController.text,
              );
              completer.complete(credential);
              Navigator.pop(context);
            },
            actionButtonName: "Submit",
          ),
        ); // Implement this function to get the OTP from the user
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return completer.future;
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
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while saving file to storage: $e");
    } catch (e, stackTrace) {
      log('Error while saving file to storage: $e', stackTrace: stackTrace);
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
      } else {
        log('Current user or profile image is null');
      }
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while saving profile image to database: $e");
    } catch (e, stackTrace) {
      log('Error while saving profile image to database: $e',
          stackTrace: stackTrace);
      throw Exception("Error while saving profile image to database: $e");
    }
  }
}
