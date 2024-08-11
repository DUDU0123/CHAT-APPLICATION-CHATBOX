
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/account_owner_profile_details_grid_view.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/settings_profile_image_avatar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';

class AccountOwnerProfilePage extends StatelessWidget {
  AccountOwnerProfilePage({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

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
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is LoadCurrentUserData) {
            return commonAnimationWidget(
              context: context,
              isTextNeeded: false,
              lottie: settingsLottie,
            );
          }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SettingsProfileImageAvatarWidget(
                  userProfileImage: state.currentUserData?.userProfileImage,
                ),
                // next
                kHeight60,
                Expanded(
                  child: AccountOwnerProfileDetailsGridView(
                    nameController: nameController,
                    aboutController: aboutController,
                  ),
                ),
              ],
            );
        },
      ),
    );
  }
}
