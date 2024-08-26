import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget iconContainerWidgetGradientColor({
  required String subtitle,
  required IconData icon,
  required void Function()? onTap,
  double? size,
}) {
  return SizedBox(
    height: 130.h,
    child: Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size?.w ?? 100.w,
            height: size?.h ?? 100.w,
            decoration: gradientButtonDecoration(),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 30.sp,
                    color: kWhite,
                  ),
                  gradientButtonText(subtitle: subtitle),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

BoxDecoration gradientButtonDecoration() {
  return BoxDecoration(
            borderRadius: BorderRadius.circular(14.sp),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                darkLinearGradientColorOne,
                darkLinearGradientColorTwo,
              ],
            ),
          );
}

Widget gradientButtonText({
  required String subtitle,
}) {
  return TextWidgetCommon(
    text: subtitle,
    fontSize: 16.sp,
    textColor: kWhite,
    fontWeight: FontWeight.w500,
  );
}
