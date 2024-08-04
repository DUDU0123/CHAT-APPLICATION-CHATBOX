
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/chat_asset_send_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/divider_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget contactMessageWidget({
  required BuildContext context,
  required MessageModel message,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          commonProfileDefaultIconCircularCotainer(
            context: context,
            containerConstraint: 35,
          ),
          TextWidgetCommon(
            text: message.message ?? 'User',
            textColor: kBlack,
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ],
      ),
      kHeight10,
      CommonDivider(
        indent: 0,
        thickness: 1,
        color: kGrey.withOpacity(0.4),
      ),
      TextButton(
        onPressed: () {
          if (message.message != null) {
            addToContact(contactNumber: message.message!);
          }
        },
        child: TextWidgetCommon(
          text: "Add to contact",
          textColor: kWhite,
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
        ),
      ),
    ],
  );
}
