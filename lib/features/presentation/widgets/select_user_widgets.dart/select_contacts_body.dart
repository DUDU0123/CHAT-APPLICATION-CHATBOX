import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/selected_contacts_show_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/contact_single_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/select_contacts_small_widgets.dart';

Widget selectContactsBody({
    required BuildContext context,required PageTypeEnum pageType, required GroupModel? groupModel
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.watch<ContactBloc>().state.selectedContactList!.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: smallGreyMediumBoldTextWidget(
                    text: pageType != PageTypeEnum.sendContactSelectPage
                        ? "Added members"
                        : "Selected contacts"),
              )
            : zeroMeasureWidget,
        const SelectedContactShowWidget(),
        context.watch<ContactBloc>().state.contactList!.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: smallGreyMediumBoldTextWidget(
                    text: pageType != PageTypeEnum.sendContactSelectPage
                        ? "Add members"
                        : "Select contacts"),
              )
            : zeroMeasureWidget,
        Expanded(
          child: BlocBuilder<ContactBloc, ContactState>(
            builder: (context, state) {
              if (state is ContactsErrorState) {
                return commonErrorWidget(message: "Unable to load contacts");
              }
              if (state is ContactsLoadingState) {
                return commonAnimationWidget(
                  context: context,
                  isTextNeeded: false,
                );
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
              if (pageType != PageTypeEnum.sendContactSelectPage) {
                if (pageType == PageTypeEnum.toSendPage) {
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
                                  ? state.selectedContactList!.contains(contact)
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
                    if (groupModel != null) {
                      if (!groupModel!.groupMembers!
                          .any((member) => member == contact.chatBoxUserId)) {
                        if (pageType == PageTypeEnum.groupInfoPage) {
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
                pageType: pageType,
                state: state,
              );
            },
          ),
        ),
      ],
    );
  }
