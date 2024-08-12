import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/privacy/privacy_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/privacy/blocked_contacts_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/radio_button_dialogbox_widget.dart';

String typeGiver({required int? groupValue}) {
  switch (groupValue) {
    case 1:
      return "Everyone";
    case 2:
      return "My contacts";
    case 3:
      return "Nobody";
    default:
      return "Everyone";
  }
}

int typeIntGiver({required String? groupValueString}) {
  switch (groupValueString) {
    case 'Everyone':
      return 1;
    case 'My contacts':
      return 2;
    case 'Nobody':
      return 3;
    default:
      return 1;
  }
}

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
                            groupValue: privacySettingMap != null
                                ? typeIntGiver(
                                    groupValueString:
                                        privacySettingMap[userDbLastSeenOnline],
                                  )
                                : 1,
                            radioOneOnChanged: (value) {
                              context.read<PrivacyBloc>().add(
                                  LastSeenPrivacyChangeEvent(
                                      currentValue: value));

                              Navigator.pop(context);
                            },
                            radioTwoOnChanged: (value) {
                              context.read<PrivacyBloc>().add(
                                  LastSeenPrivacyChangeEvent(
                                      currentValue: value));

                              Navigator.pop(context);
                            },
                            radioThreeOnChanged: (value) {
                              context.read<PrivacyBloc>().add(
                                    LastSeenPrivacyChangeEvent(
                                      currentValue: value,
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    title: "Last seen and online",
                    subtitle: privacySettingMap != null
                        ? privacySettingMap[userDbLastSeenOnline]
                        : "Everyone",
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
                            groupValue: privacySettingMap != null
                                ? typeIntGiver(
                                    groupValueString: privacySettingMap[
                                        userDbProfilePhotoPrivacy],
                                  )
                                : 1,
                            radioOneOnChanged: (value) {
                              context.read<PrivacyBloc>().add(
                                    ProfilePhotoPrivacyChangeEvent(
                                      currentValue: value,
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                            radioTwoOnChanged: (value) {
                              context.read<PrivacyBloc>().add(
                                    ProfilePhotoPrivacyChangeEvent(
                                      currentValue: value,
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                            radioThreeOnChanged: (value) {
                              context.read<PrivacyBloc>().add(
                                    ProfilePhotoPrivacyChangeEvent(
                                      currentValue: value,
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    title: "Profile photo",
                    subtitle: privacySettingMap != null
                        ? privacySettingMap[userDbProfilePhotoPrivacy]
                        : "Everyone",
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
                            groupValue: privacySettingMap != null
                                ? typeIntGiver(
                                    groupValueString:
                                        privacySettingMap[userDbAboutPrivacy],
                                  )
                                : 1,
                            radioOneOnChanged: (value) {
                              context.read<PrivacyBloc>().add(
                                    AboutPrivacyChangeEvent(
                                      currentValue: value,
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                            radioTwoOnChanged: (value) {
                              context.read<PrivacyBloc>().add(
                                    AboutPrivacyChangeEvent(
                                      currentValue: value,
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                            radioThreeOnChanged: (value) {
                              context.read<PrivacyBloc>().add(
                                    AboutPrivacyChangeEvent(
                                      currentValue: value,
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    title: "About",
                    subtitle: privacySettingMap != null
                        ? privacySettingMap[userDbAboutPrivacy]
                        : "Everyone",
                    isSmallTitle: true,
                    context: context,
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
