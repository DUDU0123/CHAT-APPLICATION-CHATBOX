
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/photo_view_section.dart';

Future<void> userProfileShowDialog(
    {required String? userProfileImage, required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.sp),
      ),
      backgroundColor: kTransparent,
      content: GestureDetector(
        onTap: () {
          userProfileImage != null
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PhotoViewSection(imageToShow: userProfileImage),
                  ),
                )
              : null;
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.sp)),
          height: 200.h,
          // width: 200.w,
          child: userProfileImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.sp),
                  child: Image.network(
                    userProfileImage,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 40.sp,
                ),
        ),
      ),
      actions: [
        Container(
          color: kBlack,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              commonSvgIconButton(
                iconName: chatsIcon,
              ),
              commonSvgIconButton(
                iconName: info,
              ),
              commonSvgIconButton(
                iconName: call,
              ),
              commonSvgIconButton(
                iconName: videoCall,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

IconButton commonSvgIconButton({
  required String iconName,
  Color? iconColor,
}) {
  return IconButton(
    onPressed: () {},
    icon: SvgPicture.asset(
      iconName,
      width: 30.w,
      height: 30.w,
      colorFilter: ColorFilter.mode(
        iconColor ?? buttonSmallTextColor,
        BlendMode.srcIn,
      ),
    ),
  );
}
