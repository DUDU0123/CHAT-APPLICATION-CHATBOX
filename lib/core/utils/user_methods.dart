import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/privacy/privacy_settings.dart';

class UserMethods {
  static Future<void> updatePrivacySettings({
    required int? lastSeenGroupValue,
    required int? profilePhotoGroupValue,
    required int? aboutGroupValue,
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
      }
    });
  }

  static Future<void> hideLastSeenForNonContacts() async {
    // Logic to hide last seen for non-contacts
  }

  static Future<void> hideLastSeenForEveryone() async {
    // Logic to hide last seen for everyone
  }

  static Future<void> showLastSeenToEveryone() async {
    // Logic to show last seen to everyone
  }

  static Future<void> hideProfilePhotoForNonContacts() async {
    // Logic to hide profile photo for non-contacts
  }

  static Future<void> hideProfilePhotoForEveryone() async {
    // Logic to hide profile photo for everyone
  }

  static Future<void> showProfilePhotoToEveryone() async {
    // Logic to show profile photo to everyone
  }

  static Future<void> hideAboutForNonContacts() async {
    // Logic to hide about info for non-contacts
  }

  static Future<void> hideAboutForEveryone() async {
    // Logic to hide about info for everyone
  }

  static Future<void> showAboutToEveryone() async {
    // Logic to show about info to everyone
  }
}
