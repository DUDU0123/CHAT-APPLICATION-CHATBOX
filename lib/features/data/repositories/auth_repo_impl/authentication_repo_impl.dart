import 'package:official_chatbox_application/features/data/data_sources/auth_data/auth_data.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/authentication_repo/authentication_repo.dart';
const userAuthStatusKey = "is_user_signedIn";
class AuthenticationRepoImpl extends AuthenticationRepo {
  final AuthData authData;
  AuthenticationRepoImpl({
    required this.authData,
  });
  @override
  Future<bool> createAccountInChatBoxUsingEmailAndPassword(
      {required UserModel newUser}) async {
    return authData.createAccountInChatBoxUsingEmailAndPassword(
        newUser: newUser);
  }

  @override
  Future<bool> getUserAthStatus() async {
    return authData.getUserAthStatus();
  }

  @override
  Future<void> setUserAuthStatus({required bool isSignedIn}) async {
    return authData.setUserAuthStatus(isSignedIn: isSignedIn);
  }

  @override
  Future<bool> deleteUserInDataBase({
    required String userId,
    String? fullPathToFile,
  }) async {
  return  await authData.deleteUserAuthInDB(
      userId: userId,
      fullPathToFile: fullPathToFile,
    );
  }
}

