
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/image_picker_method.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/icon_container_widget_gradient_color.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/file_show_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Future<dynamic> videoOrPhotoTakeFromCameraSourceMethod({
  required BuildContext context,
  ChatModel? chatModel,
  GroupModel? groupModel,
  required String? receiverContactName,
  required bool isGroup,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const TextWidgetCommon(
        text: "Take",
        textAlign: TextAlign.center,
      ),
      backgroundColor: kBlack,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          iconContainerWidgetGradientColor(
            subtitle: "Video",
            icon: Icons.video_call,
            onTap: () async {
              final file =
                  await takeVideoAsset(imageSource: ImageSource.camera);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FileShowPage(
                    fileType: FileType.video,
                    fileToShow: file,
                    pageType: PageTypeEnum.messagingPage,
                    chatModel: chatModel,
                    groupModel: groupModel,
                    isGroup: isGroup,
                    receiverContactName: receiverContactName,
                  ),
                ),
              );
            },
          ),
          iconContainerWidgetGradientColor(
            subtitle: "Photo",
            icon: Icons.camera,
            onTap: () async {
              final file = await pickImage(imageSource: ImageSource.camera);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FileShowPage(
                    fileType: FileType.image,
                    fileToShow: file,
                    pageType: PageTypeEnum.messagingPage,
                    chatModel: chatModel,
                    groupModel: groupModel,
                    isGroup: isGroup,
                    receiverContactName: receiverContactName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
