import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget wallpaperButtonWidget({
  required String buttonName,
  required void Function()? onPressed,
}) {
  return TextButton(
    style: TextButton.styleFrom(
        backgroundColor: buttonSmallTextColor.withOpacity(0.3)),
    onPressed: onPressed,
    child: TextWidgetCommon(
      textColor: kBlack,
      text: buttonName,
      fontSize: 18.sp,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w500,
    ),
  );
}
  Widget pickedWalpaperShowWidget({
    required BuildContext context,
  }) {
    return Container(
      height: screenHeight(context: context) / 1.8,
      width: screenWidth(context: context) / 1.8,
      decoration: BoxDecoration(
        color: darkScaffoldColor,
        borderRadius: BorderRadius.circular(15.sp),
        border: Border.all(
          color: kWhite,
        ),
      ),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15.sp),
            child: state.pickedFile != null
                ? Image.file(
                    state.pickedFile!,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    bgImage,
                    fit: BoxFit.cover,
                  ),
          );
        },
      ),
    );
  }