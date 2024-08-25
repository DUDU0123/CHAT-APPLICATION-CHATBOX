import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class DialogHelper {
  static showDialogMethod({
    required String title,
    required String contentText,
  }) {
    Get.dialog(
      AlertDialog(
        title: TextWidgetCommon(
          text: title,
        ),
        content: TextWidgetCommon(
          text: contentText,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const TextWidgetCommon(
              text: "Cancel",
            ),
          ),
        ],
      ),
    );
  }

  static showSnackBar({
    required String title,
    required String contentText,
  }) {
    Get.snackbar(
      title,
      contentText,
    );
  }
}
