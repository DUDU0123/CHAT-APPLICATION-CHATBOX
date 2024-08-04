import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonIconButtonWidget extends StatelessWidget {
  const CommonIconButtonWidget({
    super.key,
    required this.iconImage,
    this.onPressed,
    required this.width,
    required this.height, required this.theme,
  });
  final String iconImage;
  final void Function()? onPressed;
  final double width;
  final double height;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          iconImage,
          width: width.w,
          height: height.h,
          colorFilter: ColorFilter.mode(
             theme.colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
        ));
  }
}
