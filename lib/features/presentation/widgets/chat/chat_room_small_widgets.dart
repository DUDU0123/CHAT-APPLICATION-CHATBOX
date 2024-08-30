import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/emoji_select.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/chatbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/message/reply_message_small_widgets.dart';
import 'package:provider/provider.dart';

Widget chatMessageBar({
  required FocusNode focusNode,
  required FlutterSoundRecorder recorder,
  required TextEditingController messageController,
  required bool isGroup,
  required BuildContext context,
  GroupModel? groupModel,
  String? receiverContactName,
  required ScrollController scrollController,
  ChatModel? chatModel,
}) {
  return Column(
    children: [
      ChatBarWidget(
        replyMessage: Provider.of<CommonProvider>(context).replyMessage,
        onCancelReply: () {
          cancelReply(context: context);
        },
        focusNode: focusNode,
        isGroup: isGroup,
        groupModel: groupModel,
        receiverContactName: receiverContactName,
        recorder: recorder,
        scrollController: scrollController,
        chatModel: chatModel,
        isImojiButtonClicked: false,
        messageController: messageController,
      ),
      Provider.of<CommonProvider>(context).isEmojiPickerOpened
          ? emojiSelect(
              textEditingController: messageController,
            )
          : zeroMeasureWidget,
    ],
  );
}

  Widget messageSendRestrictingWidget({
    required BuildContext context,
    required String text,
  }) {
    return Container(
      width: screenWidth(context: context),
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
      ),
      color: darkSwitchColor.withOpacity(0.3),
      child: TextWidgetCommon(
        text: text,
        textColor: buttonSmallTextColor,
        textAlign: TextAlign.center,
        fontSize: 14.sp,
      ),
    );
  }


