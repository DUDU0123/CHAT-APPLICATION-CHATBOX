import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AppMethods {
  static const platform = MethodChannel('toastshowerchannel');
  // app close method
  static Future<void> pop({bool? animated}) async {
    showToast(
        message: "Sorry, you can't use our app because you are disabled.");
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
    exit(0);
  }

  // Method to call the showToast function in Android
  static Future<void> showToast({
    required String message,
  }) async {
    try {
      await platform.invokeMethod('showToast', {'message': message});
    } on PlatformException catch (e) {
    }
  }

  static void openAppToneChangeSettings() {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'android.settings.SOUND_SETTINGS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch();
    } else {}
  }

  static void openRingtoneChangeSettings() {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action:
            'android.intent.action.RINGTONE_PICKER', // Opens ringtone picker directly
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch();
    } else {}
  }

  static Future<String> getCurrentRingtone() async {
  const ringtoneChannel = MethodChannel('ringtonegiver');
  final deviceRingtoneName =
      await ringtoneChannel.invokeMethod('getDeviceRingtoneName');
  return deviceRingtoneName;
}

static Future<String> getCurrentNotificationTone() async {
  const notificationChannel = MethodChannel('notificationtonegiver');
  final deviceNotificationToneName =
      await notificationChannel.invokeMethod('getDeviceNotificationToneName');
  return deviceNotificationToneName;
}
// contacts permission request
static Future<PermissionStatus> requestContactsPermission() async {
  var status = await Permission.contacts.status;
  if (!status.isGranted) {
    await Permission.contacts.request();
  }
  return status;
}

}
