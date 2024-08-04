
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_butttons_common.dart';
class RadioButtonDialogBox extends StatelessWidget {
  const RadioButtonDialogBox({
    super.key,
    this.groupValue,
    this.radioOneOnChanged,
    this.radioTwoOnChanged,
    required this.radioOneTitle,
    required this.radioTwoTitle,
    required this.radioThreeTitle,
    this.radioThreeOnChanged,
    required this.dialogBoxTitle,
  });
  final int? groupValue;
  final void Function(int?)? radioOneOnChanged;
  final void Function(int?)? radioTwoOnChanged;
  final String radioOneTitle;
  final String radioTwoTitle;
  final String radioThreeTitle;
  final void Function(int?)? radioThreeOnChanged;
  final String dialogBoxTitle;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        dialogBoxTitle,
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      contentPadding: const EdgeInsets.only(top: 18),
      content: SizedBox(
        height: screenHeight(context: context) / 3.3,
        width: screenWidth(context: context) / 2,
        child: Column(
          children: [
            RadioListTile(
              title: Text(radioOneTitle),
              value: 1,
              groupValue: groupValue,
              onChanged: radioOneOnChanged,
            ),
            RadioListTile(
              title: Text(radioTwoTitle),
              value: 2,
              groupValue: groupValue,
              onChanged: radioTwoOnChanged,
            ),
            RadioListTile(
              title: Text(radioThreeTitle),
              value: 3,
              groupValue: groupValue,
              onChanged: radioThreeOnChanged,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButtonsCommon(
                buttonName: "Ok",
                onPressed: () {
                  if (dialogBoxTitle == "Change Theme") {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
