import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:official_chatbox_application/config/service_keys/zego_fields.dart';
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
          events: ZegoUIKitPrebuiltCallEvents(
            onError: (p0) {
              log("Call error completed.");
            },
            user: ZegoCallUserEvents(
              onEnter: (ZegoUIKitUser event) {
                log("Call cleanup completed.");
              },
              onLeave: (ZegoUIKitUser event) {
                log("Call cleanup completed.");
              },
            ),
            room: ZegoCallRoomEvents(
              onStateChanged: (ZegoUIKitRoomState state) {
                log("Call cleanup completed.");
              },
            ),
            onCallEnd: (event, defaultAction) {
              // Determine call status based on the event
              if (event.reason == ZegoCallEndReason.remoteHangUp) {
                log("Call accepted and ended by the receiver.");
              } else if (event.reason == ZegoCallEndReason.kickOut) {
              } else if (event.reason == ZegoCallEndReason.abandoned) {
              } else {
                log("Call ended for another reason: ${event.reason}");
              }
              defaultAction();
              log("Call cleanup completed.");
            },
          ));
    }
  }
}
