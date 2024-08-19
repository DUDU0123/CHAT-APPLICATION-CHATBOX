import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/privacy_methods.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/radio_button_dialogbox_widget.dart';

Widget aboutPrivacyListTile({
  required BuildContext context,
  required Map<String, dynamic>? privacySettingMap,
}) {
  return commonListTile(
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
                ? PrivacyMethods.typeIntGiver(
                    groupValueString: privacySettingMap[userDbAboutPrivacy],
                  )
                : 1,
            radioOneOnChanged: (value) {
              context.read<UserBloc>().add(
                    AboutPrivacyChangeEvent(
                      currentValue: value,
                    ),
                  );
              Navigator.pop(context);
            },
            radioTwoOnChanged: (value) {
              context.read<UserBloc>().add(
                    AboutPrivacyChangeEvent(
                      currentValue: value,
                    ),
                  );
              Navigator.pop(context);
            },
            radioThreeOnChanged: (value) {
              context.read<UserBloc>().add(
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
  );
}
