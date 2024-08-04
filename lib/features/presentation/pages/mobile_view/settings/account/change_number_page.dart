import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/phone_number_recieve_field.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class ChangeNumberPage extends StatelessWidget {
  ChangeNumberPage({super.key});
  TextEditingController oldNumberController = TextEditingController();
  TextEditingController newNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Change number",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextWidgetCommon(
                text: "Enter your old phone number with country code:",
                fontSize: 16.sp,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
              kHeight15,
              PhoneNumberRecieveField(
                phoneNumberController: oldNumberController,
              ),
              kHeight20,
              TextWidgetCommon(
                text: "Enter your new phone number with country code:",
                fontSize: 16.sp,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
              kHeight15,
              PhoneNumberRecieveField(
                phoneNumberController: newNumberController,
              ),
              kHeight20,
              CommonButtonContainer(
                horizontalMarginOfButton: 40,
                text: "Change number",
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
