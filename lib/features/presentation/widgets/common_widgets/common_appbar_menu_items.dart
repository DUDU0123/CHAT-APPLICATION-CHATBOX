import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_info_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/media_show_page.dart/media_show_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/wallpaper/wallpaper_select_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_app_bar_widgets_and_methods.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

PopupMenuButton<dynamic> commonAppBarMenuItemHoldWidget({
  required PageTypeEnum pageType,
  required ChatModel? chatModel,
  required GroupModel? groupModel,
  required bool isGroup,
}) {
  return PopupMenuButton(
    itemBuilder: (context) {
      if (pageType == PageTypeEnum.oneToOneChatInsidePage) {
        return [
          commonPopUpMenuItem(
            context: context,
            menuText: "View contact",
            onTap: () async {
              final contactBloc = context.read<ContactBloc>();
              final userModel =
                  await CommonDBFunctions.getOneUserDataFromDBFuture(
                userId: chatModel?.receiverID,
              );
              try {
                // Find the contact where the chatBoxUserId matches the userModel's id
                final contactList =
                    contactBloc.state.contactList?.where((contact) {
                  log("Phone number userModel: ${userModel?.phoneNumber}");
                  log("Phone number contact: ${contact.userContactNumber}");
                  return contact.chatBoxUserId == userModel?.id;
                }).toList();

                if (contactList != null && contactList.isNotEmpty) {
                  // Check if the first contact's contactId is not null
                  if (contactList.first.contactId != null) {
                    await FlutterContacts.openExternalView(
                        contactList.first.contactId!);
                  } else {
                    log("Contact ID is null for the matched contact.");
                  }
                } else {
                  log("No contact matched the provided criteria.");
                }
              } catch (e) {
                log("Error: ${e.toString()}");
              }
            },
          ),

          commonPopUpMenuItem(
            context: context,
            menuText: "Media,links and docs",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  MediaShowPage(
                    pageTypeEnum: PageTypeEnum.oneToOneChatInsidePage,
                    chatModel: chatModel,
                  ),
                ),
              );
            },
          ),
          PopupMenuItem(
            child: chatMuteMenu(chatModel: chatModel),
            onTap: () {
              chatNotficationMuteUnMuteMethod(
                context: context,
                chatModel: chatModel,
              );
            },
          ),
          commonPopUpMenuItem(
            context: context,
            menuText: "Wallpaper",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WallpaperSelectPage(
                    chatModel: chatModel,
                    groupModel: groupModel,
                  ),
                ),
              );
            },
          ),
          commonPopUpMenuItem(
            context: context,
            menuText: "Clear chat",
            onTap: () {
              normalDialogBoxWidget(
                context: context,
                title: "Clear chat",
                subtitle: "Do you want to clear this chat?",
                onPressed: () {
                  if (chatModel != null) {
                    chatModel.chatID != null
                        ? context
                            .read<ChatBloc>()
                            .add(ClearChatEvent(chatId: chatModel.chatID!))
                        : null;
                  }
                  Navigator.pop(context);
                },
                actionButtonName: "Clear chat",
              );
            },
          ),
          const PopupMenuItem(child: Text("Report")),
          const PopupMenuItem(child: Text("Block")),
        ];
      }
      if (pageType == PageTypeEnum.groupMessageInsidePage) {
        return [
          commonPopUpMenuItem(
            context: context,
            menuText: "Group info",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatInfoPage(
                    groupData: groupModel,
                    isGroup: isGroup,
                  ),
                ),
              );
            },
          ),
          commonPopUpMenuItem(
            context: context,
            menuText: "Group media",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  MediaShowPage(
                    pageTypeEnum: PageTypeEnum.groupMessageInsidePage,
                    groupModel: groupModel,
                  ),
                ),
              );
            },
          ),
          PopupMenuItem(
            child: groupMuteMenu(groupModel: groupModel),
            onTap: () {
              groupNotficationMuteUnMuteMethod(
                context: context,
                groupModel: groupModel,
              );
            },
          ),
          commonPopUpMenuItem(
            context: context,
            menuText: "Wallpaper",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WallpaperSelectPage(
                    chatModel: chatModel,
                    groupModel: groupModel,
                  ),
                ),
              );
            },
          ),
          commonPopUpMenuItem(
            context: context,
            menuText: "Clear chat",
            onTap: () {
              normalDialogBoxWidget(
                context: context,
                title: "Clear chat",
                subtitle: "Do you want to clear this group chat?",
                onPressed: () {
                  if (groupModel != null) {
                    if (groupModel.groupID != null) {
                      context.read<GroupBloc>().add(
                          ClearGroupChatEvent(groupID: groupModel.groupID!));
                    }
                  }
                  Navigator.pop(context);
                },
                actionButtonName: "Clear chat",
              );
            },
          ),
        ];
      }
      return [
        const PopupMenuItem(child: Text("Broadcast list info")),
        const PopupMenuItem(child: Text("Broadcast list media")),
        const PopupMenuItem(child: Text("Wallpaper")),
        const PopupMenuItem(child: Text("Clear chat")),
      ];
    },
  );
}
