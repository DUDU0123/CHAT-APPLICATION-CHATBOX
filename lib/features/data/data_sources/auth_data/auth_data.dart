import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/app_methods.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/data/repositories/auth_repo_impl/authentication_repo_impl.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthData {
  final FirebaseAuth firebaseAuth;
  AuthData({
    required this.firebaseAuth,
  });
  Future<bool> createAccountInChatBoxUsingEmailAndPassword({
    required UserModel newUser,
  }) async {
    try {
      final userCred = await firebaseAuth.createUserWithEmailAndPassword(
        email: newUser.userEmailId!,
        password: newUser.password!,
      );

      final userData = await CommonDBFunctions.getOneUserDataFromDBFuture(
          userId: userCred.user?.uid);
      if (userData != null) {
        if (userData.isDisabled != null) {
          if (userData.isDisabled!) {
            AppMethods.pop();
          }
        }
      }

      final UserModel updatedUserData = newUser.copyWith(
        id: userCred.user?.uid,
        isDisabled: userData?.isDisabled,
      );

      final isSuccess =
          await CommonDBFunctions.saveUserDataToDB(userData: updatedUserData);
      if (isSuccess) {
        await setUserAuthStatus(isSignedIn: true);
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  String? getCurrentUserId(String? uid) {
    return firebaseAuth.currentUser?.uid;
  }

  Future<bool> getUserAthStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(userAuthStatusKey) ?? false;
  }

  Future<void> setUserAuthStatus({required bool isSignedIn}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(userAuthStatusKey, isSignedIn);
  }

  // Method to delete user in DB
  Future<void> deleteUserInFireStoreDB({required String userId}) async {
    try {
      await fireStore.collection(usersCollection).doc(userId).delete();
      final userDoc = fireStore.collection(usersCollection).doc(userId);
      final userChats = userDoc.collection(chatsCollection);
      final userChatDocs = await userChats.get();
      for (final chatDocument in userChatDocs.docs) {
        if (chatDocument.exists) {
          await chatDocument.reference.delete();
        }
      }
      await userDoc.delete();
      final allUsers = await fireStore.collection(usersCollection).get();
      for (final user in allUsers.docs) {
        if (user.id != userId) {
          final otherUserChats = fireStore
              .collection(usersCollection)
              .doc(user.id)
              .collection(chatsCollection)
              .where(
                receiverId,
                isEqualTo: userId,
              ); // Assuming 'receiverID' is the field to identify the chat with the deleting user

          final otherUserChatDocs = await otherUserChats.get();
          for (final chatDoc in otherUserChatDocs.docs) {
            if (chatDoc.exists) {
              await chatDoc.reference
                  .delete(); // Delete the chat with the deleting user
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      throw Exception("Error while deleting user data: $e");
    } catch (e) {
      throw Exception("Error while deleting user data: $e");
    }
  }

  Future<void> deleteUserFilesInDB({required String fullPathToFile}) async {
    try {
      Reference fileReference = firebaseStorage.ref(fullPathToFile);
      // Check if the file exists by attempting to get its metadata
      await fileReference.getMetadata();
      // If the file exists, proceed to delete it
      await fileReference.delete();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<bool> deleteUserAuthInDB({
    required String userId,
    String? fullPathToFile,
  }) async {
    try {
      if (firebaseAuth.currentUser != null) {
        await deleteUserInFireStoreDB(userId: userId);
        if (fullPathToFile != null) {
          await deleteUserFilesInDB(fullPathToFile: fullPathToFile);
        }
        await firebaseAuth.currentUser?.delete();
        await setUserAuthStatus(isSignedIn: false);
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        final isAuthenticated = await reauthenticateUser();
        if (isAuthenticated) {
          await deleteUserInFireStoreDB(userId: userId);
          if (fullPathToFile != null) {
            await deleteUserFilesInDB(fullPathToFile: fullPathToFile);
          }
          await firebaseAuth.currentUser?.delete();
          await setUserAuthStatus(isSignedIn: false);
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      log("Error while deleting user from auth: $e");
      return false;
    }
  }

  Future<bool> reauthenticateUser() async {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return await showDialog<bool>(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Reauthenticate'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldCommon(
                    labelText: 'Enter email',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    textAlign: TextAlign.center,
                  ),
                  TextFieldCommon(
                    labelText: 'Enter password',
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    User? user = firebaseAuth.currentUser;
                    if (user != null) {
                      try {
                        AuthCredential credential =
                            EmailAuthProvider.credential(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        await user.reauthenticateWithCredential(credential);
                        Navigator.of(context).pop(true); // Reauthentication was successful
                      } on FirebaseAuthException catch (e) {
                        log('Reauthentication failed: ${e.message}');
                        if (e.code == 'wrong-password') {
                          log('Incorrect password.');
                        } else if (e.code == 'user-not-found') {
                          log('No user found with this email.');
                        }
                        Navigator.of(context).pop(false);
                      } catch (e) {
                        log('Error during reauthentication: ${e.toString()}');
                        Navigator.of(context).pop(false);
                      }
                    } else {
                      log('No user is currently signed in.');
                      Navigator.of(context).pop(false);
                    }
                  },
                  child: const Text('Reauthenticate'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
