import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/app_methods.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  void initState() {
    context.read<UserBloc>().add(RingToneNotificationToneGetEvent());
    super.initState();
  }
  // await player
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Notifications",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return Column(
              children: [
                commonListTile(
                  onTap: () {
                    Navigator.pop(context);
                    AppMethods.openAppToneChangeSettings();
                  },
                  title: "Notification tone",
                  isSmallTitle: false,
                  context: context,
                  subtitle: state.notificationTone ?? 'Default',
                ),
                kHeight10,
                commonListTile(
                  onTap: () {
                    Navigator.pop(context);
                    AppMethods.openAppToneChangeSettings();
                  },
                  title: "Ringtone",
                  isSmallTitle: false,
                  context: context,
                  subtitle: state.ringtone ?? 'Default',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
