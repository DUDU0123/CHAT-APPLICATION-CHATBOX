import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget boldTextWidget({
  required String text,
  TextAlign? textAlign,
}) {
  return TextWidgetCommon(
    text: text,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    textAlign: textAlign?? TextAlign.start,
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
  TextAlign? textAlign,FontStyle? fontStyle,
}) {
  return TextWidgetCommon(
    text: text,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    textAlign: textAlign ?? TextAlign.start,
    textColor: kWhite,
    fontStyle: fontStyle,
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

Widget linkText({required String text, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: TextWidgetCommon(
        textAlign: TextAlign.start,
        text: text,
        textColor: buttonSmallTextColor,
        fontSize: 18.sp,
      ),
    );
  }

  Widget commonCheckTile({
    required BuildContext context,
    required String title,
    bool? boxValue,
    required void Function(bool?)? onChanged,
  }) {
    return commonListTile(
      onTap: () {},
      title: title,
      isSmallTitle: false,
      context: context,
      leading: Checkbox(
        checkColor: kWhite,
        activeColor: buttonSmallTextColor,
        fillColor: WidgetStateProperty.all(boxValue != null
            ? boxValue
                ? buttonSmallTextColor
                : kTransparent
            : kTransparent),
        value: boxValue,
        onChanged: (value) {},
      ),
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
const accountCreateAnswer =
    "To create an account in ChatBox, after installation of the application, you can open it. Then there will come a page for entering your phone number with country code, after entering it you will get an 6 digit otp in the entered phone number. Enter that otp in the otp enter page. After doing these properly, you can successfully create an account in ChatBox.";
const setUpUserNameAndAboutAnswer =
    "To set up username and about for your ChatBox account, first you need to navigate to the setting page, then let's click on the profile tile, after that you will redirect to profile edit page. There you can edit or create username and about for your ChatBox account.";
const deleteChatBoxAccountAnswer =
    "To delete your ChatBox Account, first you need to navigate to the settings page. Then you can see the Account section blue button there. Let's click on that and you will redirect to the account section. There you can see the delete account option. Let's click on that and if you clicked on that, you will redirect to a page where you need to enter your ChatBox account phone number to delete. Then it will reauthenticate you , for that we will send an otp to that number, let's enter it. After verifying the otp, your account will be deleted from our database.";
const createGroupAnswer =
    "To create a group, you need to click on the 3 dot menu button in chat home page, there will come option 'New group' to create a new group. Let's click on that and you will redirect to a page where you can select members to add to the new group and also you can modify or edit the group permission and can provide group name and profile photo. And after all these let's click on the tick button in the bottom. When you click on that you can successfully create a new group.";
const makeOneToOneChatAnswer =
    "To make one to one chat, let's click on the circular plus chat icon button in the appbar of the chat home page. When you click on that you will redirect to a page where you can find the your contacts with and without ChatBox account. Then you can select ChatBox account user from that and can make chats. And also there is another option to send an invitation to other contacts who don't have a ChatBox account.";
const changeThemeAnswer =
    "To change theme of the application, you can navigate to the settings page and there you can see the blue button for chats, by clicking on that you will redirect to a page where you can change theme of the application from light to dark mode nad dark to light mode  and also you can select system default theme.";

const manageStorageAnswer =
    "To manage storage of the application, you can navigate to the settings page and there you can see the blue button for storage, by clicking on that you will redirect to manage storage page, where you can delete media files (audio, video, photo, document) and can manage the storage.";

const changeWallpaperAnswer =
    "To change wallpaper of the application for all chats globally, you can navigate to the settings page and there you can see the blue button for chats, by clicking on that you will redirect to a page where you can change wallpaper of the application's chats. And if you only want to change the wallpaper of a particular chat, you can just go to the chat, then there is a menu option, there you can see wallpaper option, by clicking on that you will redirect to change wallpaper page, from there you can change the wallpaper for the particular chat and also there is an option to change wallpaper to all chats.";

const blockAndUnblockUserAnswer =
    "To block a particular user, you can just go the chat of the user, there you can find the 3 dot menu option, when click on there you can see block option, when click on that there will come a block confirmation dialog. By clicking on block option in that dialog box, you can successfully blcok that particular user. And if you want to remove that user from the blocked users list, you need to navigate to settings page, from there you can find the privacy blue button, when click on that you will redirect to privacy page. From there you can see blocked contacts navigate tile, let's click on that, then you will redirect to blocked contacts list page. From there you can select any user and unblock them. If you blocked a user they can't message or call you and also can't see you online status and posts until you unblock them.";

const quriesContactUsText =
    "For any questions or concerns regarding anything related to the application, please contact us at sdu200115@gmail.com.";
const reportUserAnswer = "To report a user, you can just come to the chat of that user, there you can find the 3 dot menu option, from there you can see report option, when you click on that, there will come a alert box for confirmation, there you can click on repot button to report the user. Like this in a group, if you want to repot it, you can come to particular group's info page, in there you can see report group option, by click on that you can report the group.";
const exitFromGroupAnswer = "To exit from a group, you need to come to the particular group and in the group info section of that group, you can see exit group option. By clicking on that option you can exit from the group. After you exit the group , you can't send messages to it and also and you will not receive any messages from the group because you are not a member in that group after exit from the group.";



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

