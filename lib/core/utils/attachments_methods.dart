import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/core/constants/app_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/image_picker_method.dart';
import 'package:official_chatbox_application/core/utils/video_photo_from_camera_source_method.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/file_show_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

attachMentsMethod({
  required BuildContext context,
  required GroupModel? groupModel,
  required BuildContext rootContext,
  required AttachmentModel attachmentIcon,
  required bool isGroup,
  required String? receiverContactName,
  required ChatModel? chatModel,
}) async {
  context.read<MessageBloc>().add(AttachmentIconClickedEvent());

  switch (attachmentIcon.mediaType) {
    case MediaType.camera:
      await videoOrPhotoTakeFromCameraSourceMethod(
        isGroup: isGroup,
        groupModel: groupModel,
        receiverContactName: receiverContactName,
        rootContext: rootContext,
        chatModel: chatModel,
      );
      break;
    case MediaType.gallery:
      final file = await pickImage(imageSource: ImageSource.gallery);
      Navigator.push(
          rootContext,
          MaterialPageRoute(
            builder: (context) => FileShowPage(
              rootContext: rootContext,
              fileType: FileType.image,
              fileToShow: file,
              pageType: PageTypeEnum.messagingPage,
              chatModel: chatModel,
              groupModel: groupModel,
              isGroup: isGroup,
              receiverContactName: receiverContactName,
            ),
          ));

      break;
    case MediaType.document:
      context.read<MessageBloc>().add(
            OpenDeviceFileAndSaveToDbEvent(
              context: rootContext,
              isGroup: isGroup,
              groupModel: groupModel,
              receiverID: chatModel?.receiverID ?? '',
              receiverContactName: receiverContactName ?? '',
              messageType: MessageType.document,
              chatModel: chatModel,
            ),
          );

      break;
    case MediaType.contact:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return SelectContactPage(
            rootContext: rootContext,
            isGroup: isGroup,
            groupModel: groupModel,
            pageType: PageTypeEnum.sendContactSelectPage,
            receiverContactName: receiverContactName,
            chatModel: chatModel,
          );
        }),
      );
      break;
    case MediaType.location:
      normalDialogBoxWidget(
        context: context,
        title: "Share location",
        subtitle: "Do you want to share your location",
        onPressed: () {
          rootContext.read<MessageBloc>().add(
                LocationPickEvent(
                  context: rootContext,
                  chatModel: chatModel,
                  isGroup: isGroup,
                  receiverContactName: receiverContactName,
                  receiverID: chatModel?.receiverID,
                  groupModel: groupModel,
                ),
              );
          Navigator.pop(rootContext);
        },
        actionButtonName: "Share location",
      );
      break;
    case MediaType.audio:
      context.read<MessageBloc>().add(
            OpenDeviceFileAndSaveToDbEvent(
              context: rootContext,
              isGroup: isGroup,
              groupModel: groupModel,
              receiverID: chatModel?.receiverID ?? '',
              receiverContactName: receiverContactName ?? '',
              messageType: MessageType.audio,
              chatModel: chatModel,
            ),
          );
      break;
    default:
  }
}