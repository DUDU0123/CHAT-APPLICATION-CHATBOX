import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/service_keys/zego_fields.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallMethods {
  getCurrentUserRingtone() {}
  static void onUserLogin({
    required User? currentUser,
    required BuildContext context,
  }) {
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
            },
            user: ZegoCallUserEvents(
              onEnter: (ZegoUIKitUser event) {
              },
              onLeave: (ZegoUIKitUser event) {
              },
            ),
            room: ZegoCallRoomEvents(
              onStateChanged: (ZegoUIKitRoomState state) {
                if (state.reason == ZegoRoomStateChangedReason.Logined) {
                  Provider.of<CallBloc>(context, listen: false).add(
                    const UpdateCallStatusEvent(
                      callStatus: 'accepted',
                    ),
                  );
                  // }
                } else if (state.reason == ZegoRoomStateChangedReason.Logout) {
                  Provider.of<CallBloc>(
                    context,
                    listen: false,
                  ).add(
                    const UpdateCallStatusEvent(
                      callStatus: 'ended',
                    ),
                  );
                  // }
                }
              },
            ),
            onCallEnd: (event, defaultAction) {
              // Determine call status based on the event
              if (event.reason == ZegoCallEndReason.remoteHangUp) {
                // log("Call accepted and ended by the receiver.");
              } else if (event.reason == ZegoCallEndReason.kickOut) {
                // log("Call accepted and kikckout by the receiver.");
              } else if (event.reason == ZegoCallEndReason.abandoned) {
                // log("Call accepted abandoned.");
              } else {
                // log("Call ended for another reason: ${event.reason} by receiver");
              }
              defaultAction();
              // log("Call cleanup completed.");
            },
          ));
    }
  }
}
