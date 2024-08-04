import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class ResendOtpWidget extends StatelessWidget {
  const ResendOtpWidget({
    super.key, this.onTap,
  });
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidgetCommon(
          text: "Didn't recieve any code?",
          textColor: iconGreyColor,
        ),
        GestureDetector(
          onTap: onTap,
          child: TextWidgetCommon(
            text: "Resend",
            textColor: buttonSmallTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
