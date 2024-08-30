import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/account/delete_account_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/account/two_step_verification_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Account",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
        child: Column(
          children: [
            commonListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TwoStepVerificationPage(),
                    ),
                  );
                },
                title: "Two step verification",
                leading: SvgPicture.asset(
                  tfaPin,
                  width: 25.w,
                  height: 20.h,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                ),
                isSmallTitle: false,
                context: context,
                trailing: TextWidgetCommon(
                  text: 'Upcoming',
                  textColor: iconGreyColor,
                  fontSize: 13.sp,
                )),
            kHeight5,
            commonListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleteAccountPage(),
                  ),
                );
              },
              title: "Delete account",
              leading: SvgPicture.asset(
                deleteIcon,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
              ),
              isSmallTitle: false,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
