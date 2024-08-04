
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_butttons_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Future<dynamic> dataEditDialogBox({
  required BuildContext context,
  required String fieldTitle,
  required String hintText,
  TextEditingController? controller,
  GroupModel? groupData,
  required void Function()? onPressed,
  required int? maxLines,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.sp,
          ),
        ),
        backgroundColor: darkGreyColor,
        child: Container(
          padding:
              EdgeInsets.only(top: 20.h, left: 30.w, right: 20.w, bottom: 10.h),
          height: screenHeight(context: context) / 4,
          decoration: BoxDecoration(
            color: darkGreyColor,
            borderRadius: BorderRadius.circular(
              20.sp,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidgetCommon(
                textColor: kWhite,
                text: fieldTitle,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
              if (controller != null)
                SizedBox(
                  height: 50.h,
                  child: TextFieldCommon(
                    minLines: 1,
                    maxLines: maxLines,
                    style: TextStyle(
                      color: kWhite,
                    ),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: buttonSmallTextColor,
                    )),
                    cursorColor: buttonSmallTextColor,
                    hintText: hintText,
                    controller: controller,
                    textAlign: TextAlign.start,
                  ),
                ),
              const Spacer(),
              TextButtonsCommon(
                onPressed: onPressed,
                buttonName: "Save",
              )
            ],
          ),
        ),
      );
    },
  );
}
