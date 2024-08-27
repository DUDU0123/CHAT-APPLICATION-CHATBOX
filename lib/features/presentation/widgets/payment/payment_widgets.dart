import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';

import '../common_widgets/text_field_common.dart';

Widget textFieldSendMoney({
  bool? enabled = true,
  required BuildContext context,
  required TextEditingController controller,
  TextInputType? keyboardType,
  String? hintText,
}) {
  return TextFieldCommon(
    enabled: enabled ?? true,
    hintText: hintText,
    keyboardType: keyboardType ?? TextInputType.text,
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
    ),
    textAlign: TextAlign.center,
    controller: controller,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.sp),
      borderSide: BorderSide(
        color: buttonSmallTextColor,
      ),
    ),
  );
}
