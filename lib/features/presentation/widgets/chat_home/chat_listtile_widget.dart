import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_actions_on_longpress_method.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/user_profile_show_dialog.dart';

class ChatListTileWidget extends StatefulWidget {
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

  @override
  State<ChatListTileWidget> createState() => _ChatListTileWidgetState();
}

class _ChatListTileWidgetState extends State<ChatListTileWidget> {
  @override
  void initState() {
    if (widget.chatModel != null) {
      context.read<UserBloc>().add(UserPrivacyCheckerEvent(
          receiverID: widget.chatModel?.receiverID));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final userID = widget.chatModel?.receiverID ?? widget.receiverID;
        final privacySettings = state.userPrivacySettings?[userID] ?? {};
        final isShowableProfileImage =
            (privacySettings[userDbProfilePhotoPrivacy] ?? false);
        return GestureDetector(
          onTap: () {
            context.read<MessageBloc>().add(GetAllMessageEvent(
                  groupModel: widget.groupModel,
                  isGroup: widget.isGroup,
                  chatId: widget.chatModel?.chatID,
                  currentUserId: firebaseAuth.currentUser?.uid ?? '',
                  receiverId: widget.receiverID ?? "",
                ));
          },
          onLongPress: () {
            chatTileActionsOnLongPressMethod(
              isGroup: widget.isGroup,
              groupModel: widget.groupModel,
              context: context,
              chatModel: widget.chatModel,
            );
          },
          child: ListTile(
            contentPadding: widget.contentPadding,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomPage(
                    groupModel: widget.groupModel,
                    chatModel: widget.chatModel,
                    userName: widget.userName,
                    isGroup: widget.isGroup,
                    receiverID: widget.receiverID,
                  ),
                ),
              );
            },
            leading: GestureDetector(
              onTap: () {
                userProfileShowDialog(
                    userName: widget.userName,
                    chatModel: widget.chatModel,
                    groupModel: widget.groupModel,
                    isGroup: widget.isGroup,
                    context: context,
                    userProfileImage: widget.isGroup
                        ? widget.userProfileImage
                        : isShowableProfileImage
                            ? widget.userProfileImage
                            : null);
              },
              child: buildProfileImage(
                userProfileImage:
                 widget.isGroup
                        ? widget.userProfileImage:   isShowableProfileImage ? widget.userProfileImage : null,
                context: context,
              ),
            ),
            title: buildUserName(userName: widget.userName),
            subtitle: buildSubtitle(
              chatModel: widget.chatModel,
              groupModel: widget.groupModel,
              isGroup: widget.isGroup,
              isIncomingMessage: widget.isIncomingMessage,
              isTyping: widget.isTyping,
              isVoiceRecoding: widget.isVoiceRecoding,
            ),
            trailing: buildTrailing(
              chatModel: widget.chatModel,
              groupModel: widget.groupModel,
              context: context,
              notificationCount: widget.notificationCount,
              isMutedChat: widget.isMutedChat,
            ),
          ),
        );
      },
    );
  }
}
