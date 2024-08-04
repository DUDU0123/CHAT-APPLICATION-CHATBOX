import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';

class MessagePageDateShowWidget extends StatelessWidget {
  const MessagePageDateShowWidget({
    super.key, required this.date,
  });

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: iconGreyColor.withAlpha(150),
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: Text(date),
    );
  }
}