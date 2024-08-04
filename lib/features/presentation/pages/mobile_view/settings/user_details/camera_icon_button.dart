import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';

class CameraIconButton extends StatelessWidget {
  const CameraIconButton({
    super.key, required this.onPressed, this.icon,
  });
  final void Function() onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [
            darkLinearGradientColorTwo,
            darkLinearGradientColorOne,
          ])),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon:icon?? SvgPicture.asset(
            cameraIcon,
            height: 30.h,
            width: 30.w,
            colorFilter: ColorFilter.mode(
              kWhite,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
