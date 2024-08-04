import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomIconWidget extends StatelessWidget {
  const BottomIconWidget({
    super.key,
    required this.scale,
    required this.iconName, required this.color, required this.iconColor,
  });
  final double scale;
  final String iconName;
  final Color color;
  final Color? iconColor;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 35.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: color,
      ),
      child: Image.asset(
        iconName,
        scale: scale.sp,
        color: iconColor,
      ),
    );
  }
}