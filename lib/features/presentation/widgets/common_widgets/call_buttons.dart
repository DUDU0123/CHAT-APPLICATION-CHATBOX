import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

Widget callButtonsMethods({
  required ChatModel? chatModel,
  required GroupModel? groupModel,
  required bool isVideoCall,
  required String receiverTitle,
  required String? receiverImage,
  required CallBloc callBloc,
  required ThemeData theme,
  required BuildContext context,
  Color? buttonIconColor,
}) {
  if (chatModel != null) {
    log("Chatmodel not null");
    return ZegoSendCallInvitationButton(
      onPressed: (code, message, p2) {
        CallModel callModel = CallModel(
          isGroupCall: false,
          callStartTime: DateTime.now().toString(),
          callType: isVideoCall ? CallType.video : CallType.audio,
          callerId: firebaseAuth.currentUser?.uid,
          chatModelId: chatModel.chatID,
          callrecieversId: [chatModel.receiverID!],
          callStatus: 'not_accepted',
          receiverName: receiverTitle,
          receiverImage: receiverImage,
        );
        callBloc.add(CallInfoSaveEvent(
          callModel: callModel,
          context: context,
        ));
      },
      callID: chatModel.chatID,
      icon: ButtonIcon(
        icon: SvgPicture.asset(
          isVideoCall ? videoCall : call,
          width: isVideoCall ? 37.w : 30.w,
          height: isVideoCall ? 37.h : 30.w,
          colorFilter: ColorFilter.mode(
            buttonIconColor ?? theme.colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
        ),
        backgroundColor: kTransparent,
      ),
      buttonSize: Size(isVideoCall ? 37.w : 30.w, isVideoCall ? 37.w : 30.w),
      iconSize: Size(isVideoCall ? 37.w : 30.w, isVideoCall ? 37.w : 30.w),
      isVideoCall: isVideoCall ? true : false,
      resourceID: "zegouikit_call",
      invitees: [
        ZegoUIKitUser(
          id: chatModel.receiverID!,
          name: chatModel.receiverName!,
        ),
      ],
    );
  } else if (groupModel != null) {
    log("GroupModel not null");
    final groupMembers = groupModel.groupMembers
        ?.where(
          (memberId) => memberId != firebaseAuth.currentUser?.uid,
        )
        .toList();
    return ZegoSendCallInvitationButton(
      onPressed: (code, message, p2) {
        CallModel callModel = CallModel(
          groupModelId: groupModel.groupID,
          isGroupCall: true,
          callStartTime: DateTime.now().toString(),
          callType: isVideoCall ? CallType.video : CallType.audio,
          callerId: firebaseAuth.currentUser?.uid,
          chatModelId: groupModel.groupID,
          callrecieversId: groupModel.groupMembers,
          callStatus: 'not_accepted',
          receiverImage: receiverImage,
          receiverName: receiverTitle,
        );
        callBloc.add(CallInfoSaveEvent(
          callModel: callModel,
          context: context,
        ));
      },
      callID: groupModel.groupID,
      icon: ButtonIcon(
        icon: SvgPicture.asset(
          isVideoCall ? videoCall : call,
          width: isVideoCall ? 37.w : 30.w,
          height: isVideoCall ? 37.h : 30.w,
          colorFilter: ColorFilter.mode(
            buttonIconColor ?? theme.colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
        ),
        backgroundColor: kTransparent,
      ),
      buttonSize: Size(isVideoCall ? 37.w : 30.w, isVideoCall ? 37.w : 30.w),
      iconSize: Size(isVideoCall ? 37.w : 30.w, isVideoCall ? 37.w : 30.w),
      isVideoCall: isVideoCall ? true : false,
      resourceID: "zegouikit_call",
      invitees: groupMembers != null
          ? groupMembers
              .map((member) => ZegoUIKitUser(
                    id: member,
                    name: groupModel.groupName ?? 'Group',
                  ))
              .toList()
          : [],
    );
  } else {
    return zeroMeasureWidget;
  }
}
