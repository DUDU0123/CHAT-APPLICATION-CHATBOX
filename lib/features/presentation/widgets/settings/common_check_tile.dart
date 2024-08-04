import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';

Widget commonCheckTile({
  required BuildContext context,
  required String title,
  bool? boxValue,
  required void Function(bool?)? onChanged,
}) {
  return commonListTile(
    onTap: () {},
    title: title,
    isSmallTitle: false,
    context: context,
    leading: Checkbox(
      checkColor: kWhite,
      activeColor: buttonSmallTextColor,
      fillColor: WidgetStateProperty.all(
        boxValue != null
            ? boxValue
                ? buttonSmallTextColor
                : kTransparent
            : kTransparent,
      ),
      value: boxValue,
      onChanged: (value) {},
    ),
  );
}
