import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_actions_on_longpress_method.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});
  static const notificationChannel = MethodChannel('notificationtonegiver');
  static const ringtoneChannel = MethodChannel('ringtonegiver');

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
        child: StreamBuilder<UserModel?>(
            stream: firebaseAuth.currentUser != null
                ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                    userId: firebaseAuth.currentUser!.uid)
                : null,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return zeroMeasureWidget;
              }
              return Column(
                children: [
                  commonListTile(
                    onTap: () async {
                      List<dynamic> result = await NotificationSettings
                          .notificationChannel
                          .invokeMethod('getAllNotificationTones');

                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const TextWidgetCommon(
                                  text: "Select notification tone"),
                              actions: [
                                commonTextButton(
                                    context: context,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    buttonName: "Done"),
                              ],
                              content: ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                itemBuilder: (context, index) {
                                  final notficationTone = result[index];
                                  return ListTile(
                                    onTap: () async {
                                      final notficationToneFile =
                                          "/system/media/audio/notifications/$notficationTone.ogg";
                                      final File soundFile =
                                          File(notficationToneFile);
                                      await player.setFilePath(
                                        notficationToneFile,
                                      );
                                      if (player.playing) {
                                        player.pause();
                                      } else {
                                        player.play();
                                      }
                                      if (mounted) {
                                        context.read<UserBloc>().add(
                                              SetNoficationSoundEvent(
                                                notificationName: notficationTone,
                                                notficationSoundFile: soundFile,
                                              ),
                                            );
                                      }
                                    },
                                    title:
                                        TextWidgetCommon(text: notficationTone),
                                  );
                                },
                                separatorBuilder: (context, index) => kHeight10,
                                itemCount: result.length,
                              ),
                            );
                          },
                        );
                      }
                    },
                    title: "Notification tone",
                    isSmallTitle: false,
                    context: context,
                    subtitle: snapshot.data?.notificationName ?? 'Default',
                  ),
                  kHeight10,
                  commonListTile(
                    onTap: () async {
                      List<dynamic> ringtones = await NotificationSettings
                          .ringtoneChannel
                          .invokeMethod('getAllRingtones');
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const TextWidgetCommon(
                                  text: "Select ringtone"),
                              content: ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                itemBuilder: (context, index) {
                                  final ringTone = ringtones[index];
                                  return ListTile(
                                    onTap: () async {
                                      final ringtoneFile =
                                          "/system/media/audio/ringtones/$ringTone.ogg";
                                      final File soundFile = File(ringtoneFile);
                                      await player.setFilePath(ringtoneFile);
                                      if (player.playing) {
                                        player.pause();
                                      } else {
                                        player.play();
                                      }
                                      if (mounted) {
                                        context.read<UserBloc>().add(
                                              SetRingtoneSoundEvent(
                                                ringtoneSoundFile: soundFile,
                                                ringtoneName: ringTone,
                                              ),
                                            );
                                      }
                                    },
                                    title: TextWidgetCommon(text: ringTone),
                                  );
                                },
                                separatorBuilder: (context, index) => kHeight10,
                                itemCount: ringtones.length,
                              ),
                              actions: [
                                commonTextButton(
                                    context: context,
                                    onPressed: () {
                                      if (player.playing) {
                                        player.pause();
                                      }
                                      Navigator.pop(context);
                                    },
                                    buttonName: "Done"),
                              ],
                            );
                          },
                        );
                      }
                    },
                    title: "Ringtone",
                    isSmallTitle: false,
                    context: context,
                    subtitle: snapshot.data?.ringtoneName ?? 'Default',
                  ),
                ],
              );
            }),
      ),
    );
  }
}
