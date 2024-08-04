import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/privacy/blocked_contacts_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/radio_button_dialogbox_widget.dart';

class PrivacySettings extends StatelessWidget {
  const PrivacySettings({super.key});

  Widget selectionListTile({required BuildContext context, required String dialogTitle, required int groupValue, required String type}) {
    return commonListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return RadioButtonDialogBox(
              radioOneTitle: "Everyone",
              radioTwoTitle: "My contacts",
              radioThreeTitle: "Nobody",
              dialogBoxTitle: dialogTitle,
              groupValue: groupValue,
              radioOneOnChanged: (value) {
                //types => last-seen, profile-photo, about, status
              },
              radioTwoOnChanged: (value) {},
              radioThreeOnChanged: (value) {},
            );
          },
        );
      },
      title: "Last seen and online",
      subtitle: "Everyone",
      isSmallTitle: true,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Privacy",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            commonListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return RadioButtonDialogBox(
                      radioOneTitle: "Everyone",
                      radioTwoTitle: "My contacts",
                      radioThreeTitle: "Nobody",
                      dialogBoxTitle: "Last seen and Online",
                      groupValue: 1,
                      radioOneOnChanged: (value) {},
                      radioTwoOnChanged: (value) {},
                      radioThreeOnChanged: (value) {},
                    );
                  },
                );
              },
              title: "Last seen and online",
              subtitle: "Everyone",
              isSmallTitle: true,
              context: context,
            ),
            kHeight10,
            commonListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return RadioButtonDialogBox(
                      radioOneTitle: "Everyone",
                      radioTwoTitle: "My contacts",
                      radioThreeTitle: "Nobody",
                      dialogBoxTitle: "Profile photo",
                      groupValue: 1,
                      radioOneOnChanged: (value) {},
                      radioTwoOnChanged: (value) {},
                      radioThreeOnChanged: (value) {},
                    );
                  },
                );
              },
              title: "Profile photo",
              subtitle: "Everyone",
              isSmallTitle: true,
              context: context,
            ),
            kHeight10,
            commonListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return RadioButtonDialogBox(
                      radioOneTitle: "Everyone",
                      radioTwoTitle: "My contacts",
                      radioThreeTitle: "Nobody",
                      dialogBoxTitle: "About",
                      groupValue: 1,
                      radioOneOnChanged: (value) {},
                      radioTwoOnChanged: (value) {},
                      radioThreeOnChanged: (value) {},
                    );
                  },
                );
              },
              title: "About",
              subtitle: "Everyone",
              isSmallTitle: true,
              context: context,
            ),
            kHeight10,
            commonListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return RadioButtonDialogBox(
                      radioOneTitle: "Everyone",
                      radioTwoTitle: "My contacts",
                      radioThreeTitle: "Nobody",
                      dialogBoxTitle: "Status",
                      groupValue: 1,
                      radioOneOnChanged: (value) {},
                      radioTwoOnChanged: (value) {},
                      radioThreeOnChanged: (value) {},
                    );
                  },
                );
              },
              title: "Status",
              subtitle: "Everyone",
              isSmallTitle: true,
              context: context,
            ),
            kHeight10,
            commonListTile(
              onTap: () {},
              title: "Read reciepts",
              subtitle:
                  "If turned off, you can’t know whether the message is seen or not.",
              isSmallTitle: false,
              context: context,
              isSwitchTile: true,
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            kHeight10,
            commonListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BlockedContactsPage(),
                  ),
                );
              },
              title: "Blocked contact",
              subtitle: "0",
              isSmallTitle: false,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
