
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';


Widget mediaSelectionWidgetCommon({
  required BuildContext context,
  required String mediaName,
  required IconData icon,
  required void Function()? onPressed,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 80.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.sp),
          color: boxColorDark,
        ),
        child: Center(
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 40.sp,
              color: kWhite,
            ),
          ),
        ),
      ),
      kHeight2,
      TextWidgetCommon(
        text: mediaName,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        textColor: Theme.of(context).colorScheme.onPrimary,
      ),
    ],
  );
}
