
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_info_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/wallpaper/wallpaper_select_page.dart';
import 'package:provider/provider.dart';

List<Widget> appBarIconListMessagingPage({
  required PageTypeEnum pageType,
  required BuildContext context,
  required GroupModel? groupModel,
  required ChatModel? chatModel,
  required bool isGroup,
}) {
  final selectedMessagesId =
      context.watch<MessageBloc>().state.selectedMessageIds;

  return [
    IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        videoCall,
        width: 30.w,
        height: 30.h,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onPrimary,
          BlendMode.srcIn,
        ),
      ),
    ),
    IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        call,
        width: 30.w,
        height: 23.h,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onPrimary,
          BlendMode.srcIn,
        ),
      ),
    ),
    PopupMenuButton(
      onSelected: (value) {},
      itemBuilder: (context) {
        if (pageType == PageTypeEnum.oneToOneChatInsidePage) {
          return [
            const PopupMenuItem(child: Text("View contact")),
            const PopupMenuItem(child: Text("Media,links and docs")),
            const PopupMenuItem(child: Text("Search")),
            const PopupMenuItem(child: Text("Mute notifications")),
            PopupMenuItem(child: const Text("Wallpaper"), onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WallpaperSelectPage(
                      chatModel: chatModel,
                      groupModel: groupModel,
                    ),
                  ),
                );
            },),
            const PopupMenuItem(child: Text("Clear chat")),
            const PopupMenuItem(child: Text("Report")),
            const PopupMenuItem(child: Text("Block")),
          ];
        }
        if (pageType == PageTypeEnum.groupMessageInsidePage) {
          return [
            PopupMenuItem(
              child: const Text("Group info"),
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
            const PopupMenuItem(child: Text("Group media")),
            const PopupMenuItem(child: Text("Search")),
            const PopupMenuItem(child: Text("Mute notifications")),
            PopupMenuItem(
              child: const Text("Wallpaper"),
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
            PopupMenuItem(
              child: const Text("Clear chat"),
              onTap: () {
                if (groupModel != null) {
                  if (groupModel.groupID != null) {
                    context
                        .read<GroupBloc>()
                        .add(ClearGroupChatEvent(groupID: groupModel.groupID!));
                  }
                }
              },
            ),
          ];
        }
        // if (pageType == PageTypeEnum.broadCastMessageInsidePage)
        return [
          const PopupMenuItem(child: Text("Broadcast list info")),
          const PopupMenuItem(child: Text("Broadcast list media")),
          const PopupMenuItem(child: Text("Search")),
          const PopupMenuItem(child: Text("Wallpaper")),
          const PopupMenuItem(child: Text("Clear chat")),
        ];
      },
    )
  ];
}
