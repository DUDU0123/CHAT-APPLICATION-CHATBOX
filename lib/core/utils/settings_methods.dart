import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/app_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/invite_app_function.dart';
import 'package:official_chatbox_application/core/utils/storage_methods.dart';
import 'package:official_chatbox_application/features/presentation/bloc/media/media_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/account/account_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/chat/chat_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/help/help_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/notifications/notification_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/privacy/privacy_settings.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/storage/storage_settings.dart';
import 'package:provider/provider.dart';

settingsInnerPageNavigationMethod({
  required BuildContext context,
  required bool mounted,
  required SettingsHomeButtonModel settings,
}) async {
  final commonProvider = Provider.of<CommonProvider>(context, listen: false);
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
          builder: (context) => const NotificationSettings(),
        ),
      );
      break;
    case PageTypeEnum.storageSetting:
      int usage = await StorageMethods.calculateAppStorageUsage();
      const diskChannel = MethodChannel('freediskspacegiver');
      double value = await diskChannel.invokeMethod('getFreeDiskSpace');
      commonProvider.setDeviceFreeStorage(deviceFreeSpace: value);
      commonProvider.setStorage(storage: usage);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StorageSettings(),
          ),
        );
        context.read<MediaBloc>().add(GetAllMediaFiles());
        context.read<MediaBloc>().add(MediaResetEvent());
      }
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
}
