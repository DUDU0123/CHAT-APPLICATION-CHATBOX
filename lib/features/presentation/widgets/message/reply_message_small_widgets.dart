
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:provider/provider.dart';
replyToMessage({required MessageModel message, required FocusNode focusNode,required BuildContext context}){
  focusNode.requestFocus();
  Provider.of<CommonProvider>(context, listen: false).setReplyMessage(replyMsg: message);
  // context.read<MessageBloc>().add(GetReplyMessageEvent(repliedToMessage: message));
}

cancelReply({required BuildContext context}){
  Provider.of<CommonProvider>(context, listen: false).cancelReply();
}
Widget replyMessageTypeWidget({required MessageModel message}) {
  switch (message.messageType) {
    case MessageType.text:
      return TextWidgetCommon(
        text: message.message ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        textColor: kWhite,
        textAlign: TextAlign.start,
      );
    case MessageType.audio:
      return fileWidgetShow(message: message);
    case MessageType.video:
      return imageContainReplyWidget(message: message);

    case MessageType.document:
      return fileWidgetShow(message: message);
    case MessageType.contact:
      return fileWidgetShow(message: message);
    case MessageType.location:
      return SvgPicture.asset(
        location,
        width: 30.w,
        height: 30.h,
      );
    case MessageType.photo:
      return imageContainReplyWidget(message: message);

    default:
      return zeroMeasureWidget;
  }
}

Widget imageContainReplyWidget({
  required MessageModel message,
}) {
  return Row(
    children: [
      Container(
        alignment: Alignment.center,
        width: 50.h,
        height: 50.h,
        decoration: BoxDecoration(
          color: buttonSmallTextColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10.sp),
          image: message.messageType != MessageType.video
              ? DecorationImage(
                  image: NetworkImage(message.message!),
                  fit: BoxFit.contain,
                )
              : null,
        ),
        child: message.messageType == MessageType.video
            ? Icon(
                Icons.play_arrow_rounded,
                color: kBlack,
                size: 30.sp,
              )
            : zeroMeasureWidget,
      ),
      kWidth10,
      Expanded(
        child: TextWidgetCommon(
          text: message.name ??
              (message.messageType == MessageType.contact
                  ? message.message
                  : null)??'',
          fontSize: 15.sp,
          overflow: TextOverflow.ellipsis,
        ),
      )
    ],
  );
}

Widget fileWidgetShow({required MessageModel message}) {
  return Row(
    children: [
      Icon(
        message.messageType == MessageType.audio
            ? Icons.headphones
            : message.messageType == MessageType.document
                ? Icons.file_copy
                : message.messageType == MessageType.contact
                    ? Icons.person_pin_rounded
                    : null,
        color: kBlack,
        size: 30.sp,
      ),
      kWidth5,
      Expanded(
        child: TextWidgetCommon(
          text: message.name ??
              (message.messageType == MessageType.contact
                  ? message.message
                  : null)??"",
          fontSize: 15.sp,
          overflow: TextOverflow.ellipsis,
        ),
      )
    ],
  );
}

Widget buildReplyWidget({
  required MessageModel message,
  void Function()? onCancelReply,
  required BuildContext context,
   double? width,
}) {
  return Container(
    height: message.messageType == MessageType.text ? 60.h : null,
    margin: EdgeInsets.only(
      left: 4.w,
    ),
    padding: EdgeInsets.only(left: 4.w, right: 15.w, top: 8.sp, bottom: 8.sp),
    width: width?? screenWidth(context: context) / 1.2,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 39, 52, 78),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.sp),
        topRight: Radius.circular(20.sp),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        dividerWidget(),
        kWidth10,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    //  width: 100.w,
                    child: StreamBuilder<UserModel?>(
                        stream: message.senderID != null
                            ? CommonDBFunctions
                                .getOneUserDataFromDataBaseAsStream(
                                    userId: message.senderID!)
                            : null,
                        builder: (context, snapshot) {
                          return TextWidgetCommon(
                            text: snapshot.data?.contactName ??
                                snapshot.data?.userName ??
                                snapshot.data?.phoneNumber ??
                                '',
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            textColor: kWhite,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            fontSize: 14.sp,
                          );
                        }),
                  ),
                  GestureDetector(
                    onTap: onCancelReply,
                    child: Icon(
                      Icons.close,
                      color: kBlack,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              message.message != null
                  ? replyMessageTypeWidget(message: message)
                  : zeroMeasureWidget,
            ],
          ),
        ),
      ],
    ),
  );
}

Container dividerWidget({double? height}) {
  return Container(
        width: 3.w,
        height: height?? 58.h,
        margin: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 15.w),
        decoration: BoxDecoration(
          color: buttonSmallTextColor,
        ),
      );
}
