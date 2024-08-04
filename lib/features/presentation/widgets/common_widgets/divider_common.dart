
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';

class CommonDivider extends StatelessWidget {
  const CommonDivider({
    super.key, this.indent, this.thickness, this.color,
  });
  final double? indent;
  final double? thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness??1,
      color: color??iconGreyColor.withOpacity(0.2),
      endIndent: indent??10,
      indent: indent??10,
    );
  }
}