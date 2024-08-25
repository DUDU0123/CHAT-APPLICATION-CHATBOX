import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/chat_open_contacts_method.dart';
import 'package:official_chatbox_application/core/utils/invite_app_function.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/user_tile_name_about_profile_image.dart';

class ContactListPage extends StatelessWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidgetCommon(text: "Select Contact"),
            TextWidgetCommon(
              text:
                  "${context.watch<ContactBloc>().state.contactList?.length} contacts",
              fontSize: 12.sp,
              textColor: iconGreyColor,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                if (state.contactList == null) {
                  return zeroMeasureWidget;
                }
                log("Length: Contactpage: ${state.contactList?.length}");
                if (state is ContactsErrorState) {
                  return emptyShowWidget(context: context, text: "No contacts");
                }
                if (state is ContactsLoadingState) {
                  return commonAnimationWidget(
                    context: context,
                    isTextNeeded: false,
                    fontSize: 12.sp,
                  );
                }
                sortContactsToShowChatBoxUsersFirst(
                  contactList: state.contactList!,
                );
                return state.contactList!.isEmpty
                    ? emptyShowWidget(context: context, text: "No Contacts")
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          if (state.contactList![index].isChatBoxUser != null) {
                            state.contactList![index].isChatBoxUser!
                                ? log(
                                    "Id: ${state.contactList![index].chatBoxUserId} \n name: ${state.contactList![index].userContactName} \n Imageee: ${state.contactList![index].userProfilePhotoOnChatBox}",
                                  )
                                : null;
                          }
                          return UserTileWithNameAndAboutAndProfileImage(
                            onTap: () {
                              if (state.contactList![index].isChatBoxUser !=
                                  null) {
                                state.contactList![index].isChatBoxUser!
                                    ?
                                    chatOpen(
                                        receiverId: state
                                            .contactList![index].chatBoxUserId!,
                                        recieverContactName: state
                                                .contactList![index]
                                                .userContactName ??
                                            '',
                                        context: context)
                                    : null;
                              }
                            },
                            trailing:
                                state.contactList![index].isChatBoxUser != null
                                    ? !state.contactList![index].isChatBoxUser!
                                        ? TextButton(
                                            onPressed: () async {
                                              //create the link to send as invitation
                                              // write the logic to send an invitation to install and use the application
                                              await inviteToChatBoxApp();
                                            },
                                            child: TextWidgetCommon(
                                              text: "Invite",
                                              textColor: buttonSmallTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.sp,
                                            ),
                                          )
                                        : zeroMeasureWidget
                                    : zeroMeasureWidget,
                            userName:
                                state.contactList![index].userContactName ?? '',
                            userAbout: state.contactList![index].userAbout ??
                                state.contactList![index].userContactNumber,
                            userPicture: state
                                .contactList![index].userProfilePhotoOnChatBox,
                          );
                        },
                        separatorBuilder: (context, index) => kHeight5,
                        itemCount: state.contactList!.length,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
