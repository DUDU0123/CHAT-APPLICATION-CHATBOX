import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/privacy/privacy_settings.dart';

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
        userDbLastSeenOnline: typeGiver(groupValue: lastSeenGroupValue),
        userDbProfilePhotoPrivacy:
            typeGiver(groupValue: profilePhotoGroupValue),
        userDbAboutPrivacy: typeGiver(groupValue: aboutGroupValue),
        userDbStatusPrivacy: typeGiver(groupValue: statusGroupValue)
      }
    });
  }
}
