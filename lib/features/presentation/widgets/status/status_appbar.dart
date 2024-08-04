import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget statusAppBar(
    {required String userName,
    required String howHours,
    required String? statusUploaderImage,
    required BuildContext context,
    void Function()? shareMethod,
    void Function()? deleteMethod}) {
  return Padding(
    padding: EdgeInsets.only(top: 35.h, left: 10.w),
    child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.sp),
          color: kBlack.withOpacity(0.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
             statusUploaderImage!=null? CircleAvatar(
                radius: 24.sp,
                backgroundImage: NetworkImage(statusUploaderImage),
              ):nullImageReplaceWidget(containerRadius: 30, context: context),
              kWidth10,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgetCommon(
                    text: userName,
                    textColor: kWhite,
                    fontSize: 20.sp,
                  ),
                  TextWidgetCommon(
                    text: howHours,
                    textColor: iconGreyColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 10.sp,
                  ),
                ],
              ),
            ],
          ),
          PopupMenuButton(
            iconColor: iconGreyColor,
            itemBuilder: (context) => [
              commonPopUpMenuItem(
                context: context,
                menuText: "Share",
                onTap: shareMethod,
              ),
              commonPopUpMenuItem(
                context: context,
                menuText: "Delete",
                onTap: deleteMethod,
              ),
            ],
          )
        ],
      ),
    ),
  );
}
SvgPicture sendIconWidget() {
    return SvgPicture.asset(
      sendIcon,
      width: 30.w,
      height: 30.h,
      colorFilter: ColorFilter.mode(
        buttonSmallTextColor,
        BlendMode.srcIn,
      ),
    );
  }