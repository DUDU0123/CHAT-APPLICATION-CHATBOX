
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpMethods{
static  Future<void> launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Feedback&body=I would like to...',
    );

    if (await canLaunchUrl(Uri.parse(emailLaunchUri.toString()))) {
      await launchUrl(Uri.parse(emailLaunchUri.toString()));
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }
  static Future<dynamic> contactUsBottomSheet({required BuildContext context}) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.sp),
        topRight: Radius.circular(25.sp),
      )),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.sp),
              topRight: Radius.circular(25.sp),
            )),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        width: screenWidth(context: context),
        height: 100.h,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: GestureDetector(
              onTap: () {
                HelpMethods.launchEmail("sdu200115@gmail.com");
              },
              child: TextFieldCommon(
                style: TextStyle(color: buttonSmallTextColor),
                textAlign: TextAlign.start,
                labelText: "Reach us:",
                controller: TextEditingController(
                  text: "sdu200115@gmail.com",
                ),
                enabled: false,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary,),),
              ),
            ),
          ),
        ),
      ),
    );
  }

}