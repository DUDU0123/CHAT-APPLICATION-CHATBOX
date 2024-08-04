import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';

class CommonGradientTileWidget extends StatelessWidget {
  const CommonGradientTileWidget({
    super.key,
    required this.title,
    this.onTap,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.isSmallTitle,
    required this.rootContext,
    this.isSwitchTile,
    this.color,
  });
  final String title;
  final void Function()? onTap;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool isSmallTitle;
  final BuildContext rootContext;
  final bool? isSwitchTile;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.sp),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkLinearGradientColorOne,
            darkLinearGradientColorTwo,
          ],
        ),
      ),
      child: commonListTile(
        color: kWhite,
        onTap: onTap,
        title: title,
        isSmallTitle: isSmallTitle,
        context: rootContext,
        trailing:trailing,
        isSwitchTile: isSwitchTile
      ),
    );
  }
}
