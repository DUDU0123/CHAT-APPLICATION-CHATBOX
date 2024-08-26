
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget commonListTile({
  void Function()? onTap,
  required String title,
  String? subtitle,
  Widget? leading,
  Widget? trailing,
  required bool isSmallTitle,
  required BuildContext context,
  bool? isSwitchTile,
  Color? color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: 55.h,
      //color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading ?? zeroMeasureWidget,
              kWidth10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidgetCommon(
                    text: title,
                    fontSize: isSmallTitle ? 16.sp : 18.sp,
                    textColor: color != null
                        ? color
                        : isSmallTitle
                            ? iconGreyColor
                            : Theme.of(context).colorScheme.onPrimary,
                  ),
                  subtitle != null
                      ? SizedBox(
                          width: 200.w,
                          child: TextWidgetCommon(
                            overflow: TextOverflow.ellipsis,
                            text: subtitle,
                            fontSize: isSmallTitle
                                ? 16.sp
                                : isSwitchTile != null
                                    ? !isSwitchTile
                                        ? 16.sp
                                        : 10.sp
                                    : 16.sp,
                            textColor: isSmallTitle
                                ? Theme.of(context).colorScheme.onPrimary
                                : iconGreyColor,
                          ),
                        )
                      : zeroMeasureWidget,
                ],
              ),
            ],
          ),
          trailing ?? zeroMeasureWidget,
        ],
      ),
    ),
  );
}
