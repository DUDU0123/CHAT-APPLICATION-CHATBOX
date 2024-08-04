import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget boldTextWidget({
  required String text,
}) {
  return TextWidgetCommon(
    text: text,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    textAlign: TextAlign.start,
    textColor: kWhite,
  );
}

Widget semiBoldTextWidget({
  required String text,
  TextAlign? textAlign,
}) {
  return TextWidgetCommon(
    text: text,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    textAlign: textAlign ?? TextAlign.start,
    textColor: kWhite,
  );
}

Widget normalTextWidget({
  required String text,
  TextAlign? textAlign,
}) {
  return TextWidgetCommon(
    text: text,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    textAlign: textAlign ?? TextAlign.start,
    textColor: kWhite,
  );
}
Widget buildBulletPoint(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding:  EdgeInsets.only(top: 10.h),
        child: Icon(Icons.circle, size: 6.w, color: kWhite),
      ), // Bullet point icon
      SizedBox(width: 8.w),
      Expanded(
        child: normalTextWidget(
          text: text,
        ),
      ),
    ],
  );
}
const introText =
    "Welcome to ChatBox! These Terms of Service govern your use of our chat application, including all functionalities such as one-to-one chat, group chat, media sharing, voice and video calls, status posting, and payment transactions. By using ChatBox, you agree to these terms in full.";
const useOfApplicationText =
    "ChatBox allows users to communicate through text messages, share media, make voice and video calls, and share locations. Users must ensure that their use of the application is legal and does not violate any applicable laws or regulations. Any misuse of the application may result in the termination of the user's account.";
const accountRegisterationText =
    "To use ChatBox, users must register using their phone number for authentication purposes. Users are responsible for maintaining the confidentiality of their account information and for all activities that occur under their account.";
const mediaContentSharingText =
    "Users can share photos, videos, contacts, locations, documents, and voice recordings through ChatBox. Users must ensure that they have the right to share the content and that it does not infringe on any third-party rights. ChatBox reserves the right to remove any content that violates our policies.";
const callsAndCommunicationText =
    "ChatBox provides voice and video call services, including group calls. Users must ensure that their communication through ChatBox adheres to legal standards and respects the rights and privacy of others.";
const locationSharingText =
    "Users can share their location with other ChatBox users. By using this feature, users consent to the sharing of their location data.";
const paymentTransactionsText =
    "ChatBox includes a payment section where users can send and receive money. Users must comply with all applicable laws and regulations regarding payment transactions. ChatBox is not responsible for any issues arising from payment transactions between users.";
const terminationText =
    "ChatBox reserves the right to terminate or suspend a user's account if they violate these terms or engage in any unlawful or harmful behavior.";
const changesToTermsText =
    "ChatBox may modify these Terms of Service at any time. Users will be notified of any changes, and continued use of the application signifies acceptance of the revised terms.";
const contactUsText =
    "For any questions or concerns regarding these Terms of Service, please contact us at sdu200115@gmail.com.";
const privacyPolicyIntro =
    "ChatBox is committed to protecting your privacy. This Privacy Policy outlines how we collect, use, and safeguard your information when you use our chat application.";
const privacyIncoWeCollectText = "";
const privacyHowUseInformationText = "";
const privacySharingInfoText =
    "We do not share your personal information with third parties except as necessary to provide our services, comply with legal obligations, or protect our rights.";
const privacyDataSecurityText =
    "We implement appropriate security measures to protect your information from unauthorized access, alteration, disclosure, or destruction. However, no security system is impenetrable, and we cannot guarantee the absolute security of your data.";
const privacyYourRightsText =
    "You have the right to access, update, and delete your personal information. You can exercise these rights by contacting us at sdu200115@gmail.com.";
const privacyChangesText =
    "ChatBox may update this Privacy Policy from time to time. We will notify you of any changes, and your continued use of the application constitutes acceptance of the revised policy.";
const privacyContactUsText =
    "If you have any questions or concerns about this Privacy Policy, please contact us at sdu200115@gmail.com.";
const lastText =
    "By using ChatBox, you agree to the terms outlined in this Terms of Service and Privacy Policy document. Thank you for choosing ChatBox!";

List<String> infoCollectList = [
  "Personal Information: We collect your phone number for authentication purposes.",
  "Usage Data: We collect data on how you use ChatBox, including the features you use and the actions you take",
  "Media and Content: We collect and store the media and content you share through the application",
  "Location Data: If you use the location-sharing feature, we collect and process your location data",
  "Payment Information: We collect information related to payment transactions made through ChatBox",
];

List<String> infoUseList = [
  "To provide and improve our services."
      "To authenticate your identity and manage your account.",
  "To facilitate communication and media sharing.",
  "To process payment transactions.",
  "To respond to user inquiries and provide customer support.",
  "To analyze usage data to improve our application.",
];

