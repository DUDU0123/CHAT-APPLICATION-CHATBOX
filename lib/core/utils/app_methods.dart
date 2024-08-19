import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';

class AppMethods {
  static const platform = MethodChannel('toastshowerchannel');
  // app close method
  static Future<void> pop({bool? animated}) async {
    showToast(
      message: "Sorry, you can't use our app because you are disabled."
    );
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
    exit(0);
  }
  

  // Method to call the showToast function in Android
  static Future<void> showToast({required String message,}) async {
    try {
      await platform.invokeMethod('showToast', {'message': message});
    } on PlatformException catch (e) {
      log("Failed to show toast: '${e.message}'.");
    }
  }
}
