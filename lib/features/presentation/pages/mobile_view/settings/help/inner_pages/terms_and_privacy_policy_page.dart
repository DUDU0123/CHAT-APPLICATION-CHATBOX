import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/help/help_small_widgets.dart';

class TermsAndPrivacyPolicyPage extends StatelessWidget {
  const TermsAndPrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkScaffoldColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kWhite,
        ),
        backgroundColor: darkScaffoldColor,
        title: TextWidgetCommon(
          textColor: kWhite,
          text: "Terms And Privacy Policy",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldTextWidget(text: "Terms of Services"),
              kHeight15,
              semiBoldTextWidget(text: "Introduction"),
              kHeight5,
              normalTextWidget(text: introText),
              kHeight10,
              semiBoldTextWidget(text: "Use of the Application"),
              kHeight5,
              normalTextWidget(text: useOfApplicationText),
              kHeight10,
              semiBoldTextWidget(text: "Account Registration and Security"),
              kHeight5,
              normalTextWidget(text: accountRegisterationText),
              kHeight10,
              semiBoldTextWidget(text: "Media and Content Sharing"),
              kHeight5,
              normalTextWidget(text: mediaContentSharingText),
              kHeight10,
              semiBoldTextWidget(text: "Calls and Communication"),
              kHeight5,
              normalTextWidget(text: callsAndCommunicationText),
              kHeight10,
              semiBoldTextWidget(text: "Location Sharing"),
              kHeight5,
              normalTextWidget(text: locationSharingText),
              kHeight10,
              semiBoldTextWidget(text: "Payment Transactions"),
              kHeight5,
              normalTextWidget(text: paymentTransactionsText),
              kHeight10,
              semiBoldTextWidget(text: "Termination"),
              kHeight5,
              normalTextWidget(text: terminationText),
              kHeight10,
              semiBoldTextWidget(text: "Changes to Terms"),
              kHeight5,
              normalTextWidget(text: changesToTermsText),
              kHeight10,
              semiBoldTextWidget(text: "Contact Us"),
              kHeight5,
              normalTextWidget(text: contactUsText),
              kHeight30,
              boldTextWidget(text: "Privacy Policy"),
              kHeight15,
              normalTextWidget(text: privacyPolicyIntro),
              kHeight15,
              semiBoldTextWidget(text: "Information We Collect"),
              kHeight5,
              ...infoCollectList
                  .map((infoCollect) => buildBulletPoint(infoCollect)),
              kHeight10,
              semiBoldTextWidget(text: "How We Use Your Information"),
              kHeight5,
              ...infoUseList.map((infoUse) => buildBulletPoint(infoUse)),
              kHeight10,
              semiBoldTextWidget(text: "Sharing Your Information"),
              kHeight5,
              normalTextWidget(text: privacySharingInfoText),
              kHeight10,
              semiBoldTextWidget(text: "Data Security"),
              kHeight5,
              normalTextWidget(text: privacyDataSecurityText),
              kHeight10,
              semiBoldTextWidget(text: "Your Rights"),
              kHeight5,
              normalTextWidget(text: privacyYourRightsText),
              kHeight10,
              semiBoldTextWidget(text: "Changes to Privacy Policy"),
              kHeight5,
              normalTextWidget(text: privacyChangesText),
              kHeight10,
              semiBoldTextWidget(text: "Contact Us"),
              kHeight5,
              normalTextWidget(text: privacyContactUsText),
              kHeight35,
              semiBoldTextWidget(
                text: lastText,
                textAlign: TextAlign.center,
              ),
              kHeight35,
            ],
          ),
        ),
      ),
    );
  }
}

