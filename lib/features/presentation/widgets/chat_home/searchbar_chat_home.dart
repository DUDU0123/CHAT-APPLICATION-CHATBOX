
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/config/theme/theme_constants.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';

class SearchBarChatHome extends StatelessWidget {
  const SearchBarChatHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/search_page");
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.w, right: 10.w),
        margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 30.h),
        height: 50.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(100.sp),
        ),
        width: screenWidth(context: context),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              SvgPicture.asset(
                search,
                width: 17.w,
                height: 17.h,
                colorFilter: ColorFilter.mode(
                  iconGreyColor,
                  BlendMode.srcIn,
                ),
              ),
              kWidth10,
              Text(
                "Search chat...",
                style: fieldStyle(context: context).copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.sp,
                  color: kGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
