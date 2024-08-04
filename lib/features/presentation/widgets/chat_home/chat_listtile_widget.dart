import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/features/data/data_sources/user_data/user_data.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_actions_on_longpress_method.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/user_profile_show_dialog.dart';

import '../../../../config/bloc_providers/all_bloc_providers.dart';
import '../../bloc/message/message_bloc.dart';

class ChatListTileWidget extends StatelessWidget {
  const ChatListTileWidget({
    super.key,
    required this.userName,
    this.userProfileImage,
    this.notificationCount,
    this.isMutedChat,
    this.isTyping,
    this.isVoiceRecoding,
    this.isIncomingMessage,
    required this.isGroup,
    this.chatModel,
    this.groupModel,
    this.receiverID,
    this.contentPadding,
  });

  final String userName;
  final String? userProfileImage;
  final int? notificationCount;

  final bool? isMutedChat;
  final bool? isTyping;
  final bool? isVoiceRecoding;
  final bool? isIncomingMessage;
  final bool isGroup;
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final String? receiverID;
  final EdgeInsetsGeometry? contentPadding;

  bool? getUserNetworkStatus({required String userID}) {
    bool? isOnline = false;

    UserData.getOneUserDataFromDataBaseAsStream(userId: userID).listen((user) {
      if (user == null) {
        return;
      }
      if (user.userNetworkStatus == null) {
        return;
      }
      if (user.userNetworkStatus!) {
        log("User Status: ${user.userNetworkStatus}");
        isOnline = user.userNetworkStatus;
      }
    });

    return isOnline;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<MessageBloc>().add(GetAllMessageEvent(
              groupModel: groupModel,
              isGroup: isGroup,
              chatId: chatModel?.chatID,
              currentUserId: firebaseAuth.currentUser?.uid ?? '',
              receiverId: receiverID ?? "",
            ));
      },
      onLongPress: () {
        chatTileActionsOnLongPressMethod(
          isGroup: isGroup,
          groupModel: groupModel,
          context: context,
          chatModel: chatModel,
        );
      },
      child: ListTile(
        contentPadding: contentPadding,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomPage(
                groupModel: groupModel,
                chatModel: chatModel,
                userName: userName,
                isGroup: isGroup,
                receiverID: receiverID,
              ),
            ),
          );
        },
        leading: GestureDetector(
          onTap: () {
            log("Tapped image");
            userProfileShowDialog(
              context: context,
              userProfileImage: userProfileImage,
            );
          },
          child: buildProfileImage(
            userProfileImage: userProfileImage,
            context: context,
          ),
        ),
        title: buildUserName(
          userName: userName,
        ),
        subtitle: buildSubtitle(
          chatModel: chatModel,
          groupModel: groupModel,
          isGroup: isGroup,
          isIncomingMessage: isIncomingMessage,
          isTyping: false,
          isVoiceRecoding: false,
        ),
        trailing: buildTrailing(
          chatModel: chatModel,groupModel: groupModel,
          context: context,
          notificationCount: notificationCount,
          isMutedChat: isMutedChat,
        ),
      ),
    );
  }
}
