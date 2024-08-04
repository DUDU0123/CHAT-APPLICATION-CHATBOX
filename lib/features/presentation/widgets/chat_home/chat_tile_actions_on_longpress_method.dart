
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Future<dynamic> chatTileActionsOnLongPressMethod({
  required BuildContext context,
  required ChatModel? chatModel,
  required bool isGroup,
  required GroupModel? groupModel,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: TextWidgetCommon(
          text: "Actions",
          fontSize: 18.sp,
        ),
        actions: [
          if (isGroup)
            groupModel != null
                ? !groupModel.groupMembers!
                        .contains(firebaseAuth.currentUser?.uid)
                    ? deleteChatMethodCommon(
                        context: context,
                        isGroup: isGroup,
                        chatModel: chatModel,
                        groupModel: groupModel,
                      )
                    : zeroMeasureWidget
                : zeroMeasureWidget,
          if (!isGroup)
            deleteChatMethodCommon(
              context: context,
              isGroup: isGroup,
              chatModel: chatModel,
              groupModel: groupModel,
            ),
          commonTextButton(
            context: context,
            onPressed: () {
              // clear chat method
              if (isGroup) {
                if (groupModel != null) {
                  context
                      .read<GroupBloc>()
                      .add(ClearGroupChatEvent(groupID: groupModel.groupID!));
                  Navigator.pop(context);
                }
              } else {
                if (chatModel != null) {
                  context
                      .read<ChatBloc>()
                      .add(ClearChatEvent(chatId: chatModel.chatID!));
                  Navigator.pop(context);
                }
              }
            },
            buttonName: "Clear chat",
          ),
          commonTextButton(
            context: context,
            onPressed: () {
              Navigator.pop(context);
            },
            buttonName: "Cancel",
          ),
        ],
      );
    },
  );
}

Widget deleteChatMethodCommon({
  required BuildContext context,
  required bool isGroup,
  required ChatModel? chatModel,
  required GroupModel? groupModel,
}) {
  return commonTextButton(
    context: context,
    onPressed: () {
      if (!isGroup) {
        context.read<ChatBloc>().add(
              DeletAChatEvent(chatModel: chatModel),
            );
        Navigator.pop(context);
      } else {
        groupModel != null
            ? groupModel.groupID != null
                ? context
                    .read<GroupBloc>()
                    .add(DeleteGroupEvent(groupID: groupModel.groupID!))
                : null
            : null;
        Navigator.pop(context);
      }
    },
    buttonName: "Delete chat",
  );
}

Widget commonTextButton({
  required BuildContext context,
  required void Function()? onPressed,
  required String buttonName,
}) {
  return TextButton(
    onPressed: onPressed,
    child: TextWidgetCommon(
      text: buttonName,
      textColor: buttonSmallTextColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),
  );
}
