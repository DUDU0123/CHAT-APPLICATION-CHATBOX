import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

void commonSnackBarWidget({
  required BuildContext context,
  required String contentText,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.sp)),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(
        seconds: 1,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      content: TextWidgetCommon(
        text: contentText,
        textColor: Theme.of(context).colorScheme.onTertiary,
      ),
    ),
  );
}
