import 'dart:io';
import 'package:flutter/services.dart';

class AppMethods {
  // app close method
  static Future<void> pop({bool? animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
    exit(0);
  }
}
