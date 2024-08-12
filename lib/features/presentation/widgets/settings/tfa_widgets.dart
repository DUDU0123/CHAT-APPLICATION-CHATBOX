import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_butttons_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

// Widget tfaPINCreatePage({
//   required BuildContext context,
//   required TextEditingController twoStepVerificationPinController,
// }) {
//   return
// }
class TFAPinCreatePage extends StatelessWidget {
  const TFAPinCreatePage({
    super.key,
    required this.context,
    required this.twoStepVerificationPinController,
  });
  final BuildContext context;
  final TextEditingController twoStepVerificationPinController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              keyboardType: TextInputType.number,
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
            onTap: () {
              if (twoStepVerificationPinController.text.isNotEmpty &&
                  twoStepVerificationPinController.text.length == 6) {
                context.read<UserBloc>().add(
                      UpdateTFAPinEvent(
                          tfAPin: twoStepVerificationPinController.text),
                    );
                twoStepVerificationPinController.text = '';
                Navigator.pop(context);
              } else {
                commonSnackBarWidget(
                    context: context, contentText: "Enter 6 digit pin");
              }
            },
          ),
        ],
      ),
    );
  }
}

Widget turnOffWidget({required BuildContext context}) {
  return Column(
    children: [
      twoStepListTileWidget(
        icon: Icons.close_rounded,
        onTap: () {
          simpleDialogBox(
              context: context,
              title: " Turn off two-step verfication",
              buttonText: "Turn Off",
              onPressed: () {
                context.read<UserBloc>().add(
                      const UpdateTFAPinEvent(tfAPin: ""),
                    );
                Navigator.pop(context);
              });
        },
        title: "Turn Off",
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
