import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/media_methods.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:provider/provider.dart';

Widget dataLevelTextShowWidget({
  required String data,
  required bool isUsed,required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        // width: 90.w,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: data.split(' ')[0], // Numeric part
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 35.sp,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              TextSpan(
                text: " ${data.split(' ')[1]}", // Unit part (MB, GB, etc.)
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.sp,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
      TextWidgetCommon(
        text: isUsed ? "Used" : "Free",
        textColor: iconGreyColor,
      ),
    ],
  );
}

Widget smallDotWidget({
  required BuildContext context,
}) {
  return Container(
    width: screenWidth(context: context),
    height: 15.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.sp),
      color: buttonSmallTextColor.withOpacity(0.2), // Background color
    ),
  );
}

Widget dataLevelRow({
  required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      dataLevelTextShowWidget(
        context: context,
        data: MediaMethods.formatStorageSize(
            double.parse(Provider.of<CommonProvider>(context).appStorage)),
        isUsed: true,
      ),
      dataLevelTextShowWidget(
        context: context,
        data: MediaMethods.formatStorageSize(
            Provider.of<CommonProvider>(context).deviceFreeStorage),
        isUsed: false,
      ),
    ],
  );
}
