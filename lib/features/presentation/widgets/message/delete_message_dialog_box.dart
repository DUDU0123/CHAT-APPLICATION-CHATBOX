
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:provider/provider.dart';


class DeleteMessage extends StatelessWidget {
  const DeleteMessage({super.key, required this.selectedMessagesId, this.messageModel, required this.isGroup, this.chatModel, this.groupModel});
  final Set<String> selectedMessagesId;
  final MessageModel? messageModel;
  final bool isGroup;
  final ChatModel? chatModel;
  final GroupModel? groupModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const TextWidgetCommon(text: "Delete Message"),
        actions: [
          messageModel?.senderID == firebaseAuth.currentUser?.uid
              ? selectedMessagesId.length <= 1
                  ? commonTextButton(
                      onPressed: () {
                        context.read<MessageBloc>().add(UnSelectEvent(messageId: selectedMessagesId.first));
                        Provider.of<MessageBloc>(context, listen: false).add(
                          MessageDeleteForEveryOneEvent(
                            context: context,
                            isGroup: isGroup,
                            messageID: selectedMessagesId.first,
                            chatModel: chatModel,
                            groupModel: groupModel,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      text: "Delete for Everyone",
                    )
                  : zeroMeasureWidget
              : zeroMeasureWidget,
          messageModel != null
              ? messageModel?.senderID != null
                  ? commonTextButton(
                      onPressed: () {
                        for (var messageId in selectedMessagesId) {
                          context.read<MessageBloc>().add(UnSelectEvent(messageId: messageId));
                        }
                        Provider.of<MessageBloc>(context, listen: false).add(
                          MessageDeleteForOne(
                            context: context,
                            userID: messageModel!.senderID!,
                            isGroup: isGroup,
                            messageIdList: selectedMessagesId.toList(),
                            groupModel: groupModel,
                            chatModel: chatModel,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      text: "Delete for me",
                    )
                  : zeroMeasureWidget
              : zeroMeasureWidget,
          commonTextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "Cancel",
          ),
        ],
      );
  }
}


Widget commonTextButton({
  required String text,
  required void Function()? onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    child: TextWidgetCommon(
      text: text,
      textColor: buttonSmallTextColor,
    ),
  );
}
