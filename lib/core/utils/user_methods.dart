import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/privacy_methods.dart';
class UserMethods {
  static Future<void> updatePrivacySettings({
    required int? lastSeenGroupValue,
    required int? profilePhotoGroupValue,
    required int? aboutGroupValue,
    required int? statusGroupValue,
  }) async {
    await fireStore
        .collection(usersCollection)
        .doc(firebaseAuth.currentUser?.uid)
        .update({
      userDbPrivacySettings: {
        userDbLastSeenOnline: PrivacyMethods.typeGiver(groupValue: lastSeenGroupValue),
        userDbProfilePhotoPrivacy:
            PrivacyMethods.typeGiver(groupValue: profilePhotoGroupValue),
        userDbAboutPrivacy: PrivacyMethods.typeGiver(groupValue: aboutGroupValue),
        userDbStatusPrivacy: PrivacyMethods.typeGiver(groupValue: statusGroupValue)
      }
    });
  }
}
