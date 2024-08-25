import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/core/constants/app_constants.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/image_picker_method.dart';
import 'package:official_chatbox_application/core/utils/video_photo_from_camera_source_method.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/file_show_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

class AttachmentListContainerVertical extends StatelessWidget {
  const AttachmentListContainerVertical({
    super.key,
    this.chatModel,
    this.receiverContactName,
    this.groupModel,
    required this.isGroup,
    required this.rootContext,
  });
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final String? receiverContactName;
  final bool isGroup;
  final BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: screenHeight(context: context) / 3.h,
      width: 50.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiary,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.sp),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          itemCount: attachmentIcons.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    attachmentIcons[index].colorOne,
                    attachmentIcons[index].colorTwo,
                  ],
                ),
              ),
              child: IconButton(
                onPressed: () async {
                  context.read<MessageBloc>().add(AttachmentIconClickedEvent());

                  switch (attachmentIcons[index].mediaType) {
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
                      final file =
                          await pickImage(imageSource: ImageSource.gallery);
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
                },
                icon: SvgPicture.asset(
                  attachmentIcons[index].icon,
                  height: 24.h,
                  width: 24.h,
                  colorFilter: ColorFilter.mode(
                    kBlack,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => kHeight5,
        ),
      ),
    );
  }
}
