import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/contact_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/report_model/report_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
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
  required bool mounted,
}) {
  return PopupMenuButton(
    itemBuilder: (context) {
      if (pageType == PageTypeEnum.oneToOneChatInsidePage) {
        return [
          commonPopUpMenuItem(
            context: context,
            menuText: "View contact",
            onTap: () async {
              log("ksnkn");
              ContactMethods.openContactInDevice(
                context: context,
                receiverID: chatModel?.receiverID,
              );
            },
          ),
          commonPopUpMenuItem(
            context: context,
            menuText: "Media Files",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MediaShowPage(
                    pageTypeEnum: PageTypeEnum.oneToOneChatInsidePage,
                    chatModel: chatModel,
                  ),
                ),
              );
            },
          ),
          if (chatModel?.receiverID != firebaseAuth.currentUser?.uid)
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
          if (chatModel?.receiverID != firebaseAuth.currentUser?.uid)
            PopupMenuItem(
              child: const Text("Report"),
              onTap: () async {
                final receiverModel =
                    await CommonDBFunctions.getOneUserDataFromDBFuture(
                        userId: chatModel?.receiverID);
                if (mounted) {
                  normalDialogBoxWidget(
                    context: context,
                    title:
                        "Report ${receiverModel?.contactName ?? receiverModel?.userName ?? receiverModel?.phoneNumber}",
                    subtitle:
                        "Do you want to report ${receiverModel?.contactName ?? receiverModel?.userName ?? receiverModel?.phoneNumber}?",
                    onPressed: () {
                      if (receiverModel != null) {
                        final reportModel = ReportModel(
                          reportedUserId: receiverModel.id,
                        );
                        context.read<ChatBloc>().add(
                              ReportAccountEvent(
                                reportModel: reportModel,
                                context: context,
                              ),
                            );
                      }

                      Navigator.pop(context);
                    },
                    actionButtonName: "Report",
                  );
                }
              },
            ),
          if (chatModel?.receiverID != firebaseAuth.currentUser?.uid)
            PopupMenuItem(
              child: blockMenu(chatModel: chatModel),
              onTap: () async {
                blockUnblockUserMethod(
                  context: context,
                  chatModel: chatModel,
                );
              },
            ),
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
                    rootContext: context,
                    chatModel: chatModel,
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
                  builder: (context) => MediaShowPage(
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
      return [];
    },
  );
}
