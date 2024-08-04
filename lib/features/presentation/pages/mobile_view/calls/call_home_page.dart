import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';

class CallHomePage extends StatelessWidget {
  const CallHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listTileCommonWidget(
            subTitleTileText: "Make a call to anyone",
            textColor: Theme.of(context).colorScheme.onPrimary,
            tileText: "Make a call",
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            leading: CircleAvatar(
              radius: 30.sp,
              backgroundColor: buttonSmallTextColor,
              child: Icon(
                Icons.call,
                color: kWhite,
                size: 30.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25.w,
              vertical: 5.h,
            ),
            child: smallGreyMediumBoldTextWidget(text: "Recent"),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return listTileCommonWidget(
                    subTitle: Row(
                      children: [
                        Transform.rotate(
                          angle: pi / 180 * -40,
                          child: Icon(
                            index % 2 == 0
                                ? Icons.arrow_forward_outlined
                                : Icons.arrow_back_outlined,
                            color: index % 2 == 0 ? kGreen : kRed,
                            size: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    tileText: "Anderson",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    leading: CircleAvatar(
                      radius: 30.sp,
                      backgroundColor: darkSwitchColor,
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        index % 2 == 0 ? call : videoCall,
                        width: 26.w,
                        height: 26.h,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ));
              },
              separatorBuilder: (context, index) => kHeight5,
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
