import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Payment History"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemCount: 10,
        separatorBuilder: (context, index) => kHeight10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: buildProfileImage(
              userProfileImage: null,
              context: context,
            ),
            title: const TextWidgetCommon(
              text: "Name",
            ),
            trailing: TextWidgetCommon(
              text: "\u20B9100",
              textColor: iconGreyColor,
              fontSize: 16.sp,
            ),
          );
        },
      ),
    );
  }
}
