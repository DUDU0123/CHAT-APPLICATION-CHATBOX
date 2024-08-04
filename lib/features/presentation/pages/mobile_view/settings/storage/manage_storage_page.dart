import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class ManageStoragePage extends StatelessWidget {
  const ManageStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Manage storage"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dataLevelTextShowWidget(
                      data: "300",
                      isUsed: true,
                    ),
                    dataLevelTextShowWidget(
                      data: "1.8",
                      isUsed: false,
                    ),
                  ],
                ),
                kHeight10,
                Container(
                  width: screenWidth(context: context),
                  height: 15.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.sp),
                    color: buttonSmallTextColor,
                  ),
                ),
                kHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 10.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                          color: buttonSmallTextColor, shape: BoxShape.circle),
                    ),
                    kWidth10,
                    TextWidgetCommon(
                      text: "ChatBox (300 MB)",
                      textColor: iconGreyColor,
                    )
                  ],
                ),
                kHeight20,
                TextWidgetCommon(
                  text: "MEDIA",
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
              itemBuilder: (context, index) {
                return Container(
                  height: 150.h,
                  width: 150.w,
                  color: kBlack,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dataLevelTextShowWidget({
    required String data,
    required bool isUsed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          //color: buttonSmallTextColor,
          child: Stack(
            children: [
              TextWidgetCommon(
                text: data,
                fontWeight: FontWeight.w500,
                fontSize: 35.sp,
              ),
              Positioned(
                right: 0,
                bottom: 5.h,
                child: TextWidgetCommon(
                  text: "MB",
                  fontWeight: FontWeight.normal,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
        TextWidgetCommon(
          text: isUsed ? "Used" : "Free",
          textColor: iconGreyColor,
        ),
      ],
    );
  }
}
