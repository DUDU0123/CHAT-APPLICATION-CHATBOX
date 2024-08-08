import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

StreamBuilder<GroupModel?> groupMuteMenu({
  required GroupModel? groupModel,
}) {
  return StreamBuilder<GroupModel?>(
    stream: firebaseAuth.currentUser != null
        ? groupModel != null
            ? groupModel.groupID != null
                ? CommonDBFunctions.getOneGroupDataByStream(
                    userID: firebaseAuth.currentUser!.uid,
                    groupID: groupModel.groupID!,
                  )
                : null
            : null
        : null,
    builder: (context, snapshot) {
      final group = snapshot.data;
      return TextWidgetCommon(
        text: group?.isMuted != null
            ? group!.isMuted!
                ? "Unmute notifications"
                : "Mute notifications"
            : "Mute notifications",
      );
    },
  );
}

StreamBuilder<ChatModel?> chatMuteMenu({
  required ChatModel? chatModel,
}) {
  return StreamBuilder<ChatModel?>(
    stream: CommonDBFunctions.getChatModelByChatIDAsStream(
        chatModelId: chatModel?.chatID),
    builder: (context, snapshot) {
      final chat = snapshot.data;
      return TextWidgetCommon(
        text: chat?.isMuted != null
            ? chat!.isMuted!
                ? "Unmute notifications"
                : "Mute notifications"
            : "Mute notifications",
      );
    },
  );
}

StreamBuilder<GroupModel?> groupMuteIconWidget(
    {required GroupModel groupModel, required Icon muteIcon}) {
  return StreamBuilder<GroupModel?>(
      stream: firebaseAuth.currentUser != null
          ? groupModel.groupID != null
              ? CommonDBFunctions.getOneGroupDataByStream(
                  userID: firebaseAuth.currentUser!.uid,
                  groupID: groupModel.groupID!,
                )
              : null
          : null,
      builder: (context, snapshot) {
        final group = snapshot.data;
        if (group == null) {
          return zeroMeasureWidget;
        }
        if (group.isMuted != null) {
          if (group.isMuted!) {
            return muteIcon;
          } else {
            return zeroMeasureWidget;
          }
        } else {
          return zeroMeasureWidget;
        }
      });
}

StreamBuilder<ChatModel?> chatMuteIconWidget(
    {required ChatModel chatModel, required Icon muteIcon}) {
  return StreamBuilder<ChatModel?>(
      stream: CommonDBFunctions.getChatModelByChatIDAsStream(
          chatModelId: chatModel.chatID),
      builder: (context, snapshot) {
        final chatModel = snapshot.data;
        if (chatModel == null) {
          return zeroMeasureWidget;
        }
        if (chatModel.isMuted != null) {
          if (chatModel.isMuted!) {
            return muteIcon;
          } else {
            return zeroMeasureWidget;
          }
        } else {
          return zeroMeasureWidget;
        }
      });
}

Future<dynamic> chatNotficationMuteUnMuteMethod({
  required BuildContext context,
  required ChatModel? chatModel,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return StreamBuilder<ChatModel?>(
          stream: CommonDBFunctions.getChatModelByChatIDAsStream(
              chatModelId: chatModel?.chatID),
          builder: (context, snapshot) {
            final chat = snapshot.data;
            return alertDialog(
              context: context,
              title: chat?.isMuted != null
                  ? chat!.isMuted!
                      ? "Unmute notifications"
                      : "Mute notifications"
                  : "Mute notifications",
              content: TextWidgetCommon(
                text:
                    "Do you want to ${chat?.isMuted != null ? chat!.isMuted! ? "unmute" : "mute" : "mute"} notifications from this chat?",
                fontSize: 16.sp,
              ),
              onPressed: () async {
                if (chat != null) {
                  final isMuted = chat.isMuted != null
                      ? chat.isMuted!
                          ? false
                          : true
                      : false;
                  final updatedChatModel = chat.copyWith(isMuted: isMuted);
                  context
                      .read<ChatBloc>()
                      .add(ChatUpdateEvent(chatModel: updatedChatModel));
                }
                Navigator.pop(context);
              },
              actionButtonName: chat?.isMuted != null
                  ? chat!.isMuted!
                      ? "Unmute"
                      : "Mute"
                  : "Mute",
            );
          });
    },
  );
}

Future<dynamic> groupNotficationMuteUnMuteMethod({
  required BuildContext context,
  required GroupModel? groupModel,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return StreamBuilder<GroupModel?>(
          stream: firebaseAuth.currentUser != null
              ? groupModel != null
                  ? groupModel.groupID != null
                      ? CommonDBFunctions.getOneGroupDataByStream(
                          userID: firebaseAuth.currentUser!.uid,
                          groupID: groupModel.groupID!,
                        )
                      : null
                  : null
              : null,
          builder: (context, snapshot) {
            final group = snapshot.data;
            return alertDialog(
              context: context,
              title: group?.isMuted != null
                  ? group!.isMuted!
                      ? "Unmute notifications"
                      : "Mute notifications"
                  : "Mute notifications",
              content: TextWidgetCommon(
                text:
                    "Do you want to ${group?.isMuted != null ? group!.isMuted! ? "unmute" : "mute" : "mute"} notifications from this group?",
                fontSize: 16.sp,
              ),
              onPressed: () async {
                if (group != null) {
                  final isMuted = group.isMuted != null
                      ? group.isMuted!
                          ? false
                          : true
                      : false;
                  final updatedGroupModel = group.copyWith(isMuted: isMuted);
                  context.read<GroupBloc>().add(UpdateGroupEvent(
                        updatedGroupData: updatedGroupModel,
                      ));
                }
                Navigator.pop(context);
              },
              actionButtonName: group?.isMuted != null
                  ? group!.isMuted!
                      ? "Unmute"
                      : "Mute"
                  : "Mute",
            );
          });
    },
  );
}
