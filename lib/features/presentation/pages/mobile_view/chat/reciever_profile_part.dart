import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class RecieverProfilePart extends StatelessWidget {
  const RecieverProfilePart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [

              ],
            ),
            Row(
              children: [

              ],
            ),
            Column(
              children: [
                TextWidgetCommon(text: "About"),
              ],
            ),
            ListTile(),
            
          ],
        ),
      ),
    );
  }
}