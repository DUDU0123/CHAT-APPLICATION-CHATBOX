import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/app_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/invite_app_function.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/account/account_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/chat/chat_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/help/help_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/notifications/notification_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/privacy/privacy_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/storage/storage_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/account_owner_profile_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/divider_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/common_blue_gradient_container_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Settings",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AccountOwnerProfileTile(),
            kHeight10,
            const CommonDivider(),
            kHeight20,
            Expanded(
              child: GridView.builder(
                itemCount: settingsButtonsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final settings = settingsButtonsList[index];
                  return GestureDetector(
                    onTap: () async {
                      switch (settings.pageType) {
                        case PageTypeEnum.accountSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.privacySetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacySettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.chatSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.notificationsSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.storageSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StorageSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.helpSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.inviteButton:
                          await inviteToChatBoxApp();
                          break;
                        default:
                      }
                    },
                    child: CommonBlueGradientContainerWidget(
                      icon: settings.icon,
                      pageType: PageTypeEnum.settingsPage,
                      subTitle: settings.subtitle,
                      title: settings.title,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
