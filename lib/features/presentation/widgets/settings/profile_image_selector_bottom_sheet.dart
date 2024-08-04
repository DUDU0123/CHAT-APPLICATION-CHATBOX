import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/image_selection_media_widget_common.dart';

Future<dynamic> assetSelectorBottomSheet({
  required BuildContext context,
  required String firstButtonName,
  required String secondButtonName,
  required IconData firstButtonIcon,
  required IconData secondButtonIcon,
  required void Function()? firstButtonAction,
  required void Function()? secondButtonAction,
}) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50.sp),
        topRight: Radius.circular(50.sp),
      ),
    ),
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(top: 20.h),
        height: screenHeight(context: context) / 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.sp),
            topRight: Radius.circular(50.sp),
          ),
          color: Theme.of(context).popupMenuTheme.color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mediaSelectionWidgetCommon(
              onPressed: firstButtonAction,
              context: context,
              mediaName: firstButtonName,
              icon: firstButtonIcon,
            ),
            kWidth15,
            mediaSelectionWidgetCommon(
              onPressed: secondButtonAction,
              context: context,
              mediaName: secondButtonName,
              icon: secondButtonIcon,
            ),
          ],
        ),
      );
    },
  );
}
