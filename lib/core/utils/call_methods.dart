import 'package:firebase_auth/firebase_auth.dart';
import 'package:official_chatbox_application/config/imp_fields/zego_fields.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallMethods {
  static void onUserLogin({required User? currentUser}) {
    if (currentUser != null) {
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: ZegoFields.appId,
        appSign: ZegoFields.appSignIn,
        userID: currentUser.uid,
        userName: currentUser.phoneNumber ?? '',
        plugins: [ZegoUIKitSignalingPlugin()],
        // ringtoneConfig: ZegoCallRingtoneConfig(
        //   incomingCallPath: "assets/ringtone/incomingCallRingtone.mp3",
        //   outgoingCallPath: "assets/ringtone/outgoingCallRingtone.mp3",
        // ),
      );
    }
  }
}
