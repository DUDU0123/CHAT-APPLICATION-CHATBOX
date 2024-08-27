import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'dart:developer';

import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/service/dialog_helper.dart';
class NetworkStatusMethods {


  static updateUserNetworkStatusInApp({required bool isOnline}) async {
    try {
      await fireStore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser?.uid)
          .update({
        userDbLastActiveTime: DateTime.now().millisecondsSinceEpoch.toString(),
        userDbNetworkStatus: isOnline,
      });
    } on SocketException catch (e) {
      log("Network error: ${e.message}");
    } on HttpException catch (e) {
      log("HTTP error: ${e.message}");
    } catch (e) {
      log("Unknown error: $e");
    }
  }


  static Future<bool> checkNetworkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
  static void initialize({required BuildContext context}) {
    // Initial status check
    checkNetworkStatus().then((isConnected) {
      updateUserNetworkStatusInApp(isOnline: isConnected);
      if (!isConnected) {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    });

    // Listen for connectivity changes
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool isConnected =
          results.isNotEmpty && results.first != ConnectivityResult.none;
      updateUserNetworkStatusInApp(isOnline: isConnected);
       // Show dialog if internet is turned off
      if (!isConnected) {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    });

    // Listen for app lifecycle changes
    SystemChannels.lifecycle.setMessageHandler((message) async {
      log(message.toString());
      if (message.toString().contains("resume")) {
        if (await checkNetworkStatus()) {
          updateUserNetworkStatusInApp(isOnline: true);
        }
      } else if (message.toString().contains("pause")) {
        updateUserNetworkStatusInApp(isOnline: false);
      }
      return Future.value(message);
    });
  }
}
