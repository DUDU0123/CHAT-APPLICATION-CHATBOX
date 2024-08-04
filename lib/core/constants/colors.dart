import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/theme/theme_constants.dart';

Color kWhite = Colors.white;
Color kRed = Colors.red;
Color kGreen = Colors.green;
Color kBlack = Colors.black;
Color kTransparent = Colors.transparent;
Color iconGreyColor = const Color.fromARGB(255, 127, 126, 126);
Color kGrey = const Color.fromARGB(255, 108, 108, 108);
Color darkScaffoldColor = const Color.fromARGB(255, 22, 23, 28);
Color darkSmallTextColor = const Color.fromARGB(255, 5, 118, 251);
Color bottomNavIconBgColor = const Color.fromARGB(255, 0, 87, 255);
Color darkSwitchColor = const Color.fromARGB(255, 97, 111, 142);
Color voiceRecorderContainer = const Color.fromARGB(255, 89, 95, 255);
Color darkLinearGradientColorOne = const Color.fromARGB(255, 0, 47, 147);
Color darkLinearGradientColorTwo = const Color.fromARGB(255, 0, 14, 45);
Color lightLinearGradientColorOne =
    const Color.fromARGB(255, 0, 79, 249); //chat also
Color lightLinearGradientColorTwo =
    const Color.fromARGB(255, 0, 47, 147); //2nd chat also
Color buttonSmallTextColor = const Color.fromARGB(255, 0, 79, 249);
Color onSecondaryColorDark = const Color.fromARGB(255, 45, 45, 45);
Color onSecondaryColorLight = const Color.fromARGB(255, 228, 228, 228);
Color boxColorDark = const Color.fromARGB(255, 34, 35, 42);
Color boxColorWhite = const Color.fromARGB(255, 237, 237, 237);
Color messageSeenColor = const Color.fromARGB(255, 23, 199, 255);
Color darkGreyColor = const Color.fromARGB(255, 29, 31, 35);

// attachments color
Color documentColorOne = const Color.fromARGB(255, 61, 49, 197);
Color documentColorTwo = const Color.fromARGB(255, 73, 24, 111);
Color cameraColorOne = const Color.fromARGB(255, 205, 0, 111);
Color cameraColorTwo = const Color.fromARGB(255, 103, 0, 56);
Color galleryColorOne = const Color.fromARGB(255, 224, 68, 237);
Color galleryColorTwo = const Color.fromARGB(255, 128, 39, 135);
Color audioColorOne = const Color.fromARGB(255, 244, 110, 53);
Color audioColorTwo = const Color.fromARGB(255, 142, 64, 31);
Color locationColorOne = const Color.fromARGB(255, 26, 176, 95);
Color locationColorTwo = const Color.fromARGB(255, 11, 74, 40);
Color contactColorOne = const Color.fromARGB(255, 30, 81, 92);
Color contactColorTwo = const Color.fromARGB(255, 33, 197, 233);
Color greyBlackColor = const Color.fromARGB(255, 32, 43, 67);

// assets
const doubleTick = "assets/double_tick.svg";
const appLogo = "assets/appLogo.png";
const keyIcon = "assets/key.svg";
const indiaFlag = "assets/india_flag.png";
const privacyIcon = "assets/privacy.svg";
const chatsIcon = "assets/chat.svg";
const notificationIcon = "assets/notifyIcon.svg";
const storageIcon = "assets/storage.svg";
const helpIcon = "assets/help.svg";
const inviteIcon = "assets/invite.svg";
const singleTick = "assets/one_tick.svg";
const bgImageDark = "assets/backgroundImage.png";
const bgImageLight = "assets/bgLightWallpaper.png";
const cameraIcon = "assets/camera.svg";
const gallery = "assets/photos.svg";
const search = "assets/search.svg";
const info = "assets/info.svg";
const headphone = "assets/headphone.svg";
const location = "assets/location.svg";
const mute = "assets/mute.png";
const qrcode = "assets/qrcode.svg";
const contact = "assets/contact.svg";
const wallpaper = "assets/wallpaper.svg";
const timer = "assets/timer.svg";
const document = "assets/document.svg";
const videoCall = "assets/call_video.svg";
const call = "assets/call.svg";
const sendIcon = "assets/send_svg.svg";
const smileIcon = "assets/emoji_chat.svg";
const microphoneFilled = "assets/microphone_filled.svg";
const changeNumberIcon = "assets/changeNumber.svg";
const tfaPin = "assets/tfaIcon.svg";
const deleteIcon = "assets/delete.svg";
const deleteIcon2 = "assets/deleteIcon.svg";
const theme = "assets/theme.svg";
const clearIcon = "assets/clearIcon.svg";
const bgImage = "assets/chatBoxBg.png";
const settingsLottie = "https://lottie.host/13f9dae6-a998-4e91-82d1-a505b5aacd64/mI4P96e8ll.json";
const noChatText = "No Chats\nStart a chat by selecting a contact by click on above chat icon";

// styles
TextStyle fieldStyle({required BuildContext context}) => TextStyle(
      fontSize:
          ThemeConstants.theme(context: context).textTheme.labelSmall?.fontSize,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onPrimary,
    );

TextStyle labelStyle({required BuildContext context}) => const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
