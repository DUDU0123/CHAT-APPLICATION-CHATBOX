import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/service_keys/zego_fields.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/main.dart';
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
              log("Call error completed.");
            },
            user: ZegoCallUserEvents(
              onEnter: (ZegoUIKitUser event) {
                log("Call cleanup onEnter completed.");
              },
              onLeave: (ZegoUIKitUser event) {
                log("Call cleanup onLeave completed.");
              },
            ),
            room: ZegoCallRoomEvents(
              onStateChanged: (ZegoUIKitRoomState state) {
                log("Call cleanup completed. ${state.reason}");
                if (state.reason == ZegoRoomStateChangedReason.Logined) {
                  log("Call Accepted");
                  Provider.of<CallBloc>(context, listen: false).add(
                    const UpdateCallStatusEvent(
                      callStatus: 'accepted',
                    ),
                  );
                  // }
                } else if (state.reason == ZegoRoomStateChangedReason.Logout) {
                  log("Call Ended");
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
                log("Call accepted and ended by the receiver.");
              } else if (event.reason == ZegoCallEndReason.kickOut) {
                log("Call accepted and kikckout by the receiver.");
              } else if (event.reason == ZegoCallEndReason.abandoned) {
                log("Call accepted abandoned.");
              } else {
                log("Call ended for another reason: ${event.reason} by receiver");
              }
              defaultAction();
              log("Call cleanup completed.");
            },
          ));
    }
  }
}
