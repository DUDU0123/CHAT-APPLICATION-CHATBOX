import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/contact_methods.dart';
import 'package:official_chatbox_application/core/utils/group_methods.dart';
import 'package:official_chatbox_application/core/utils/message_methods.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/uploaded_status_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';

class FloatingDoneNavigateButton extends StatefulWidget {
  const FloatingDoneNavigateButton({
    super.key,
    this.chatModel,
    this.selectedContactList,
    this.receiverContactName,
    required this.pageType,
    this.icon,
    this.groupName,
    this.pickedGroupImageFile,
    this.groupModel,
    required this.isGroup,
    this.uploadedStatusModel,
    this.statusModel,
    this.uploadedStatusModelID,
    required this.isStatus,
    this.messageType,
    this.messageContent,
    this.rootContext,
  });

  final ChatModel? chatModel;
  final List<ContactModel>? selectedContactList;
  final String? receiverContactName;
  final PageTypeEnum pageType;
  final IconData? icon;
  final String? groupName;
  final File? pickedGroupImageFile;
  final GroupModel? groupModel;
  final bool isGroup;
  final UploadedStatusModel? uploadedStatusModel;
  final StatusModel? statusModel;
  final bool isStatus;
  final String? uploadedStatusModelID;
  final MessageType? messageType;
  final String? messageContent;
  final BuildContext? rootContext;

  @override
  State<FloatingDoneNavigateButton> createState() =>
      _FloatingDoneNavigateButtonState();
}

class _FloatingDoneNavigateButtonState
    extends State<FloatingDoneNavigateButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final messageBloc = context.read<MessageBloc>();

        switch (widget.pageType) {
          case PageTypeEnum.sendContactSelectPage:
            if (widget.rootContext != null) {
              ContactMethods.sendSelectedContactMessage(
                selectedContactList: widget.selectedContactList,
                receiverContactName: widget.receiverContactName,
                context: widget.rootContext!,
                isGroup: widget.isGroup,
                groupModel: widget.groupModel,
                chatModel: widget.chatModel,
              );
            }

            break;
          case PageTypeEnum.groupMemberSelectPage:
            GroupMethods
                .selectGroupMembersOnCreationAndSendToDetailsAddPageMethod(
              selectedContactList: widget.selectedContactList,
              context: context,
            );
            break;

          case PageTypeEnum.groupInfoPage:
            GroupMethods.updateGroupMembersAfterCreationMethod(
              selectedContactList: widget.selectedContactList,
              groupModel: widget.groupModel,
              context: context,
            );
            break;

          case PageTypeEnum.toSendPage:
            if (widget.isStatus) {
              final val = await fireStore
                  .collection(usersCollection)
                  .doc(firebaseAuth.currentUser?.uid)
                  .collection(statusCollection)
                  .doc(widget.statusModel?.statusId)
                  .get();
              final statusMOdell = StatusModel.fromJson(map: val.data()!);
              final sendingStatus = statusMOdell.statusList?.firstWhere(
                  (status) =>
                      status.uploadedStatusId == widget.uploadedStatusModelID);

              if (mounted) {
                MessageMethods.shareMessage(
                  selectedContactList: widget.selectedContactList,
                  messageBloc: messageBloc,
                  messageType: sendingStatus?.statusType == StatusType.video
                      ? MessageType.video
                      : sendingStatus?.statusType == StatusType.image
                          ? MessageType.photo
                          : MessageType.text,
                  messageContent: sendingStatus?.statusContent,
                  context: context,
                );
              }
            } else {
              if (widget.messageContent != null && widget.messageType != null) {
                MessageMethods.shareMessage(
                  context: widget.rootContext!,
                  selectedContactList: widget.selectedContactList,
                  messageBloc: messageBloc,
                  messageType: widget.messageType,
                  messageContent: widget.messageContent,
                );
              }
            }
            if (mounted) {
              Navigator.pop(context);
            }
            break;
          case PageTypeEnum.groupDetailsAddPage:
            GroupMethods.groupDetailsAddOnCreationMethod(
              context: context,
              selectedContactList: widget.selectedContactList,
              groupName: widget.groupName,
              pickedGroupImageFile: widget.pickedGroupImageFile,
            );
            break;
          default:
        }
      },
      child: Container(
        height: 50.h,
        width: 60.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            darkLinearGradientColorOne,
            darkLinearGradientColorTwo,
          ]),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        child: Center(
          child: Icon(
            widget.icon ?? Icons.arrow_forward_rounded,
            size: 30.sp,
            color: kWhite,
          ),
        ),
      ),
    );
  }
}
