
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/theme/theme_constants.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class CommonButtonContainer extends StatelessWidget {
  const CommonButtonContainer({
    super.key,
    required this.horizontalMarginOfButton,
    required this.text,
    this.child,
    this.onTap,
  });
  final double horizontalMarginOfButton;
  final String text;
  final void Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMarginOfButton.w),
        height: 50.h,
        width: screenWidth(context: context),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 1,
              spreadRadius: 0,
              color: theme.shadowColor,
            ),
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 1,
              spreadRadius: 0,
              color: theme.shadowColor,
            )
          ],
          borderRadius: BorderRadius.circular(15.sp),
          gradient: LinearGradient(
            colors: [
              lightLinearGradientColorOne,
              lightLinearGradientColorTwo,
            ],
          ),
        ),
        child: child?? Center(
          child: TextWidgetCommon(
            text: text,
            fontSize: theme.textTheme.labelSmall?.fontSize,
            textColor: theme.textTheme.labelSmall?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
