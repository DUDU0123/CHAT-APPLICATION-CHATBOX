import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/help_methods.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/help/inner_pages/help_center_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/help/inner_pages/terms_and_privacy_policy_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/divider_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/help/help_small_widgets.dart';

class HelpSettings extends StatelessWidget {
  const HelpSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Help",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: TextWidgetCommon(
                textAlign: TextAlign.start,
                text: "Contact Us",
                textColor: Theme.of(context).colorScheme.onPrimary,
                fontSize: 25.sp,
              ),
            ),
            TextWidgetCommon(
              textAlign: TextAlign.start,
              text: "We would like to know your thoughts about\nthis app.",
              textColor: iconGreyColor,
            ),
            kHeight10,
            linkText(
              text: "Contact Us",
              onTap: () {
                HelpMethods.contactUsBottomSheet(
                  context: context,
                );
              },
            ),
            const CommonDivider(),
            kHeight15,
            linkText(
              text: "Help Center",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpCenterPage(),
                    ));
              },
            ),
            kHeight15,
            linkText(
              text: "Terms and privacy policy",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndPrivacyPolicyPage(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
