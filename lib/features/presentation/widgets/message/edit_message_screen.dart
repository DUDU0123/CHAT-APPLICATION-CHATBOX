import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

import '../../../../core/constants/colors.dart';

class EditMessageScreen extends StatefulWidget {
  const EditMessageScreen(
      {super.key,
      required this.message,
      required this.isGroup,
      this.groupModel,
      this.chatModel});
  final MessageModel message;
  final bool isGroup;
  final GroupModel? groupModel;
  final ChatModel? chatModel;

  @override
  State<EditMessageScreen> createState() => _EditMessageScreenState();
}

class _EditMessageScreenState extends State<EditMessageScreen> {
  TextEditingController editMessageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    editMessageController = TextEditingController(text: widget.message.message);
  }

  @override
  void dispose() {
    editMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: 30.h, right: 20.w, left: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidgetCommon(
                textAlign: TextAlign.start,
                text: "Edit",
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
              TextFieldCommon(
                maxLines: 2000,
                cursorColor: buttonSmallTextColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: buttonSmallTextColor,
                  ),
                ),
                controller: editMessageController,
                textAlign: TextAlign.start,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonSmallTextColor,
                ),
                label: TextWidgetCommon(
                  text: "Edit",
                  textColor: kWhite,
                  fontSize: 20.sp,
                ),
                onPressed: () {
                  final updatedMessage = widget.message.copyWith(
                    message: editMessageController.text,
                    isEditedMessage: true,
                  );
                  log(updatedMessage.toString());
                  context.read<MessageBloc>().add(
                        MessageEditEvent(
                          isGroup: widget.isGroup,
                          messageID: widget.message.messageId!,
                          updatedMessage: updatedMessage,
                          chatModel: widget.chatModel,
                          groupModel: widget.groupModel,
                        ),
                      );
                  context.read<MessageBloc>().add(UnSelectEvent(messageId: widget.message.messageId));
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.done,
                  color: kWhite,
                  size: 28.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
