import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/help/help_small_widgets.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkScaffoldColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kWhite,
        ),
        title: TextWidgetCommon(
          text: "Help Center",
          textColor: kWhite,
        ),
        backgroundColor: darkScaffoldColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kHeight15,
            boldTextWidget(
              text: "Welcome to ChatBox Help Center",
              textAlign: TextAlign.center,
            ),
            kHeight20,
            semiBoldTextWidget(text: "How to create account in ChatBox?"),
            kHeight10,
            normalTextWidget(
              text: accountCreateAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(text: "How to set up username and about?"),
            kHeight10,
            normalTextWidget(
              text: setUpUserNameAndAboutAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(text: "How to delete your ChatBox account?"),
            kHeight10,
            normalTextWidget(
              text: deleteChatBoxAccountAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(text: "How to create a group in ChatBox?"),
            kHeight10,
            normalTextWidget(
              text: createGroupAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(
                text: "How to make one to one chat other users?"),
            kHeight10,
            normalTextWidget(
              text: makeOneToOneChatAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(text: "How to change theme of the application?"),
            kHeight10,
            normalTextWidget(
              text: makeOneToOneChatAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(
                text: "How to manage storage of the application?"),
            kHeight10,
            normalTextWidget(
              text: manageStorageAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(text: "How to change wallpaper?"),
            kHeight10,
            normalTextWidget(
              text: changeWallpaperAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(text: "How to block and unblock a user?"),
            kHeight10,
            normalTextWidget(
              text: blockAndUnblockUserAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(text: "How to repot a user or group?"),
            kHeight10,
            normalTextWidget(
              text: reportUserAnswer,
            ),
            kHeight15,
            semiBoldTextWidget(text: "How to exit from group?"),
            kHeight10,
            normalTextWidget(
              text: exitFromGroupAnswer,
            ),
            kHeight10,
            normalTextWidget(
              text: quriesContactUsText,
              fontStyle: FontStyle.italic,
            ),
            kHeight30,
            semiBoldTextWidget(
              text: lastText,
              textAlign: TextAlign.center,
            ),
            kHeight15,
          ],
        ),
      ),
    );
  }
}
