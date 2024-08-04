
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';

Widget circleImageShowPreventErrorWidget({
  required String image,
  required double containerSize,
}) {
  return Container(
    width: containerSize,
    height: containerSize,
    decoration: const BoxDecoration(shape: BoxShape.circle),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50.sp),
      child: Image.network(
        fit: BoxFit.cover,
        image,
        errorBuilder: (context, error, stackTrace) {
          return nullImageReplaceWidget(
            containerRadius: 50,
            context: context,
          );
        },
      ),
    ),
  );
}