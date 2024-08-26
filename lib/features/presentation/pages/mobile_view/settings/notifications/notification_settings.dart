import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/app_methods.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';

Future<String> getCurrentRingtone() async {
  const ringtoneChannel = MethodChannel('ringtonegiver');
  final deviceRingtoneName =
      await ringtoneChannel.invokeMethod('getDeviceRingtoneName');
  return deviceRingtoneName;
}

Future<String> getCurrentNotificationTone() async {
  const notificationChannel = MethodChannel('notificationtonegiver');
  final deviceNotificationToneName =
      await notificationChannel.invokeMethod('getDeviceNotificationToneName');
  return deviceNotificationToneName;
}

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  AudioPlayer player = AudioPlayer();
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
        child: Column(
          children: [
            FutureBuilder<String>(
                future: getCurrentNotificationTone(),
                builder: (context, snapshot) {
                  return commonListTile(
                    onTap: () {
                      AppMethods.openAppNotificationToneChangeSettings();
                    },
                    title: "Notification tone",
                    isSmallTitle: false,
                    context: context,
                    subtitle: snapshot.data ?? 'Default',
                  );
                }),
            kHeight10,
            FutureBuilder<String>(
                future: getCurrentRingtone(),
                builder: (context, snapshot) {
                  return commonListTile(
                    onTap: () {
                      AppMethods.openRingtoneChangeSettings();
                    },
                    title: "Ringtone",
                    isSmallTitle: false,
                    context: context,
                    subtitle: snapshot.data ?? 'Default',
                  );
                }),
          ],
        ),
      ),
    );
  }
}
