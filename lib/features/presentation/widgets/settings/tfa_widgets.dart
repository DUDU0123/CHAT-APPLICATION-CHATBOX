import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_butttons_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget tfaPINCreatePage({
  required BuildContext context,
  required TextEditingController twoStepVerificationPinController,
}) {
  return Column(
    children: [
      TextWidgetCommon(
        text: "Create a 6-digit PIN that you can remember",
        textColor: iconGreyColor,
        fontSize: 16.sp,
        textAlign: TextAlign.center,
      ),
      kHeight20,
      SizedBox(
        width: screenWidth(context: context) / 1.5,
        child: TextFieldCommon(
          style: TextStyle(
            fontSize: 20.sp,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: buttonSmallTextColor),
          ),
          hintText: "Enter 6 digit PIN",
          controller: twoStepVerificationPinController,
          textAlign: TextAlign.center,
        ),
      ),
      kHeight40,
      CommonButtonContainer(
        horizontalMarginOfButton: 40,
        text: "Save",
        onTap: () {},
      ),
    ],
  );
}

Widget changePinOrTurnOffWidget({required BuildContext context}) {
  return Column(
    children: [
      twoStepListTileWidget(
        icon: Icons.close_rounded,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  height: 80.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextWidgetCommon(
                        text: " Turn off two-step verfication",
                        textColor: iconGreyColor,
                        fontSize: 16.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: TextButtonsCommon(
                          buttonName: "Turn Off",
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        title: "Turn Off",
      ),
      twoStepListTileWidget(
        icon: Icons.password,
        onTap: () {},
        title: "Change PIN",
      ),
    ],
  );
}

ListTile twoStepListTileWidget({
  required void Function()? onTap,
  required IconData icon,
  required String title,
}) {
  return ListTile(
    onTap: onTap,
    leading: Icon(
      icon,
      color: iconGreyColor,
    ),
    title: TextWidgetCommon(
      text: title,
      fontSize: 18.sp,
    ),
  );
}

Stack twoStepVerificationTopImageStaticWidget() {
  return Stack(
    children: [
      Align(
        alignment: Alignment.center,
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: buttonSmallTextColor.withOpacity(0.3),
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        top: 25.h,
        bottom: 25.h,
        child: SvgPicture.asset(
          tfaPin,
          width: 40.w,
          height: 40.h,
        ),
      ),
    ],
  );
}
