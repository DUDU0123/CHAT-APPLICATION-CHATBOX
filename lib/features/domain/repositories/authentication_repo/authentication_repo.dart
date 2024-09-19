import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
abstract class AuthenticationRepo {
  Future<bool> createAccountInChatBoxUsingEmailAndPassword({
    required UserModel newUser,
  });
  Future<bool> deleteUserInDataBase({
    required String userId,
    String? fullPathToFile,
  });
  Future<void> setUserAuthStatus({required bool isSignedIn});
  Future<bool> getUserAthStatus();
}