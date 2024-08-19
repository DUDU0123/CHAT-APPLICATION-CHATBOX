import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/privacy/blocked_contacts_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/privacy_widgets/about_privacy_listtile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/privacy_widgets/last_seen_online_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/privacy_widgets/profile_photo_privacy_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/privacy_widgets/status_privacy_listtile.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
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
        child: StreamBuilder<UserModel?>(
            stream: firebaseAuth.currentUser != null
                ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                    userId: firebaseAuth.currentUser!.uid)
                : null,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return zeroMeasureWidget;
              }
              final userModel = snapshot.data;
              final privacySettingMap = userModel?.privacySettings;
              return Column(
                children: [
                  lastSeenOnlinePrivacyListTile(
                    context: context,
                    privacySettingMap: privacySettingMap,
                  ),
                  kHeight10,
                  profilePhotoPrivacyListTile(
                    context: context,
                    privacySettingMap: privacySettingMap,
                  ),
                  kHeight10,
                  aboutPrivacyListTile(
                    context: context,
                    privacySettingMap: privacySettingMap,
                  ),
                  kHeight10,
                  statusPrivacyListTile(
                    context: context,
                    privacySettingMap: privacySettingMap,
                  ),
                  kHeight10,
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return StreamBuilder<List<BlockedUserModel>>(
                          stream: state.blockedUsersList,
                          builder: (context, snapshot) {
                            return commonListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BlockedContactsPage(),
                                  ),
                                );
                              },
                              title: "Blocked contacts",
                              subtitle: snapshot.data?.length.toString(),
                              isSmallTitle: false,
                              context: context,
                            );
                          });
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }
}
