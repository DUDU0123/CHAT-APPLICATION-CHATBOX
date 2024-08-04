import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/tfa_widgets.dart';

class TwoStepVerificationPage extends StatelessWidget {
  TwoStepVerificationPage({super.key});
  TextEditingController twoStepVerificationPinController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Two Step Verification",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              twoStepVerificationTopImageStaticWidget(),
              kHeight25,
              twoStepListTileWidget(
                icon: Icons.password,
                onTap: () {},
                title: "Create Pin",
              ),
              changePinOrTurnOffWidget(context: context),
              tfaPINCreatePage(
                context: context,
                twoStepVerificationPinController:
                    twoStepVerificationPinController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
