import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/uploaded_status_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/selected_contacts_show_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/contact_single_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/floating_done_navigation_button.dart';

class SelectContactPage extends StatefulWidget {
  const SelectContactPage({
    super.key,
    this.chatModel,
    this.receiverContactName,
    required this.pageType,
    this.groupModel,
    required this.isGroup,
    this.uploadedStatusModel,
    this.statusModel,
    this.uploadedStatusModelID,
  });
  final ChatModel? chatModel;
  final String? receiverContactName;
  final PageTypeEnum pageType;
  final GroupModel? groupModel;
  final UploadedStatusModel? uploadedStatusModel;
  final StatusModel? statusModel;
  final String? uploadedStatusModelID;
  final bool isGroup;
  @override
  State<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  @override
  void initState() {
    super.initState();
    // Clear the selected contacts when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactBloc>().add(ClearListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    log(widget.pageType.toString());
    log("${context.watch<ContactBloc>().state.contactList?.length}Length");
    if (context.watch<ContactBloc>().state.contactList?.length == 0 ||
        context.watch<ContactBloc>().state.contactList?.length == null) {
      context.read<ContactBloc>().add(GetContactsEvent());
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgetCommon(
                text: widget.pageType == PageTypeEnum.sendContactSelectPage
                    ? "Selected Contacts"
                    : widget.pageType == PageTypeEnum.groupMemberSelectPage
                        ? "New Group"
                        : widget.pageType == PageTypeEnum.groupInfoPage
                            ? "Add members"
                            : widget.pageType == PageTypeEnum.toSendPage
                                ? "Select contact to send"
                                : "New Broadcast"),
            widget.pageType == PageTypeEnum.sendContactSelectPage
                ? BlocBuilder<ContactBloc, ContactState>(
                    builder: (context, state) {
                      return TextWidgetCommon(
                        text: "${state.selectedContactList?.length} contacts",
                        fontSize: 12.sp,
                      );
                    },
                  )
                : zeroMeasureWidget,
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.watch<ContactBloc>().state.selectedContactList!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: smallGreyMediumBoldTextWidget(
                      text:
                          widget.pageType != PageTypeEnum.sendContactSelectPage
                              ? "Added members"
                              : "Selected contacts"),
                )
              : zeroMeasureWidget,
          const SelectedContactShowWidget(),
          context.watch<ContactBloc>().state.contactList!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: smallGreyMediumBoldTextWidget(
                      text:
                          widget.pageType != PageTypeEnum.sendContactSelectPage
                              ? "Add members"
                              : "Select contacts"),
                )
              : zeroMeasureWidget,
          Expanded(
            child: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                if (state is ContactsErrorState) {
                  log(state.message);
                  return commonErrorWidget(message: "Unable to load contacts");
                }
                if (state is ContactsLoadingState) {
                  return commonAnimationWidget(
                      context: context, isTextNeeded: true, text: "Loading");
                }
                if (state.contactList == null) {
                  return zeroMeasureWidget;
                }
                List<ContactModel> chatBoxUsersList = [];
                for (var contact in state.contactList!) {
                  if (contact.isChatBoxUser ?? false) {
                    chatBoxUsersList.add(contact);
                  }
                }
                chatBoxUsersList.removeWhere((chatBoxUser) =>
                    chatBoxUser.chatBoxUserId == firebaseAuth.currentUser?.uid);
                if (widget.pageType != PageTypeEnum.sendContactSelectPage) {
                  if (widget.pageType == PageTypeEnum.toSendPage) {
                    return StreamBuilder<List<ContactModel>?>(
                        stream: CommonDBFunctions.getContactsCollection(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return commonErrorWidget(
                                message: "Something went wrong");
                          }
                          final contactList = snapshot.data;
                          return ListView.separated(
                            itemCount: snapshot.data!.length,
                            separatorBuilder: (context, index) => kHeight10,
                            itemBuilder: (context, index) {
                              final contact = contactList![index];
                              return ContactSingleWidget(
                                contactNameorNumber: contact.userContactName ??
                                    contact.userContactNumber ??
                                    '',
                                contactModel: contact,
                                isSelected: state.selectedContactList != null
                                    ? state.selectedContactList!
                                        .contains(contact)
                                    : false,
                              );
                            },
                          );
                        });
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    itemCount: chatBoxUsersList.length,
                    itemBuilder: (context, index) {
                      var contact = chatBoxUsersList[index];

                      // Check if the contact's ID is not in the groupModel.groupMembers
                      if (widget.groupModel != null) {
                        if (!widget.groupModel!.groupMembers!
                            .any((member) => member == contact.chatBoxUserId)) {
                          if (widget.pageType == PageTypeEnum.groupInfoPage) {
                            return ContactSingleWidget(
                              key: ValueKey(contact.userContactNumber),
                              isSelected: state.selectedContactList != null
                                  ? state.selectedContactList!.contains(contact)
                                  : false,
                              contactModel: contact,
                              contactNameorNumber: contact.userContactName ??
                                  contact.userContactNumber ??
                                  '',
                            );
                          }
                          return zeroMeasureWidget;
                        } else {
                          return zeroMeasureWidget;
                        }
                      } else {
                        return ContactSingleWidget(
                          key: ValueKey(contact.userContactNumber),
                          isSelected: state.selectedContactList != null
                              ? state.selectedContactList!.contains(contact)
                              : false,
                          contactModel: contact,
                          contactNameorNumber: contact.userContactName ??
                              contact.userContactNumber ??
                              '',
                        );
                      }
                    },
                    separatorBuilder: (context, index) => kHeight2,
                  );
                }
                return allContactsListShowWidget(
                  pageType: widget.pageType,
                  state: state,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          
          return FloatingDoneNavigateButton(
            uploadedStatusModelID: widget.uploadedStatusModelID,
            statusModel: widget.statusModel,
            uploadedStatusModel: widget.uploadedStatusModel,
            icon: widget.pageType == PageTypeEnum.groupInfoPage
                ? Icons.done
                : widget.pageType == PageTypeEnum.toSendPage
                    ? Icons.send_rounded
                    : widget.pageType == PageTypeEnum.broadcastMembersSelectPage
                        ? Icons.done
                        : null,
            groupModel: widget.groupModel,
            isGroup: widget.isGroup,
            pageType: widget.pageType,
            receiverContactName: widget.receiverContactName ?? '',
            chatModel: widget.chatModel,
            selectedContactList: state.selectedContactList,
          );
        },
      ),
    );
  }
}

Widget allContactsListShowWidget({
  required ContactState state,
  required PageTypeEnum pageType,
}) {
  return ListView.separated(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    itemCount: state.contactList!.length,
    itemBuilder: (context, index) {
      final contact = state.contactList![index];
      if (pageType == PageTypeEnum.groupInfoPage) {
        return zeroMeasureWidget;
      }
      return ContactSingleWidget(
        key: ValueKey(contact.userContactNumber),
        isSelected: state.selectedContactList != null
            ? state.selectedContactList!.contains(contact)
            : false,
        contactModel: contact,
        contactNameorNumber:
            contact.userContactName ?? contact.userContactNumber ?? '',
      );
    },
    separatorBuilder: (context, index) => kHeight2,
  );
}
