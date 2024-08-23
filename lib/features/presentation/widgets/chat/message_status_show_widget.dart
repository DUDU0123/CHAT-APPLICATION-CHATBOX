
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget messageStatusShowWidget({
  required MessageModel message,
  required bool isCurrentUserMessage,
}) {
  return Positioned(
    bottom: 6.h,
    right: 8.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        message.isEditedMessage != null
            ? message.isEditedMessage!
                ? TextWidgetCommon(
                    text: "Edited",
                    fontSize: 10.sp,
                    textColor: iconGreyColor,
                  )
                : zeroMeasureWidget
            : zeroMeasureWidget,
        kWidth2,
        TextWidgetCommon(
          text: DateProvider.take12HourTimeFromTimeStamp(
            timeStamp: message.messageTime.toString(),
          ),
          fontSize: 10.sp,
          textColor: iconGreyColor,
        ),
        kWidth2,
        isCurrentUserMessage
            ? message.messageStatus == MessageStatus.sent
                ? Icon(
                    Icons.done,
                    color: iconGreyColor,
                    size: 12.sp,
                  )
                : message.messageStatus == MessageStatus.read
                    ? Icon(
                        Icons.done_all,
                        color: buttonSmallTextColor,
                        size: 12.sp,
                      )
                    : message.messageStatus == MessageStatus.delivered
                        ? Icon(
                            Icons.done_all,
                            color: iconGreyColor,
                            size: 12.sp,
                          )
                        : Icon(
                            Icons.update,
                            color: iconGreyColor,
                            size: 12.sp,
                          )
            : zeroMeasureWidget,
        kWidth2,
      ],
    ),
  );
}
