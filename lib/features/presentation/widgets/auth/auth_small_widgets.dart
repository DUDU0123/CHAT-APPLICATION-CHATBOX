import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';

Widget commonAuthTextField({
  required TextEditingController controller,
  required String? hintText,
  required String? labelText,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20.w),
    child: TextFieldCommon(
      labelText: labelText,
      textAlign: TextAlign.start,
      controller: controller,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.sp),
      ),
    ),
  );
}
