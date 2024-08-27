import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/app_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/account_owner_profile_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/divider_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/common_blue_gradient_container_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                    onTap: () async {},
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

