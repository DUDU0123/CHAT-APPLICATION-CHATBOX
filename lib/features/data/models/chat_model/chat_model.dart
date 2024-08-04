import 'dart:developer';

import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/domain/entities/chat_entity/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    super.chatID,
    super.senderID,
    super.receiverID,
    super.lastMessage,
    super.lastMessageTime,
    super.lastMessageStatus,
    super.lastMessageType,
    super.notificationCount,
    super.receiverProfileImage,
    super.attachmentsWithMessage,
    super.receiverName,
    super.isMuted,
    super.isIncomingMessage,
    super.isChatOpen,
    super.chatWallpaper,
  });

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    log("Map Data: $map");
    return ChatModel(
      // isGroup:map[isGroupChat]??false,
      attachmentsWithMessage: map['attachments'],
      chatID: map[chatId],
      receiverID: map[receiverId],
      senderID: map[senderId],
      receiverProfileImage: map[receiverProfilePhoto],
      lastMessageTime: map[chatLastMessageTime],
      lastMessage: map[chatLastMessage],
      isMuted: map[chatMuted] ?? false,
      notificationCount: map[chatMessageNotificationCount],
      // lastMessageStatus: MessageStatus.values.byName(map[lastChatStatus]),
      lastMessageStatus: map[lastChatStatus] != null
      ? MessageStatus.values.byName(map[lastChatStatus])
      : null,
      // lastMessageType: MessageType.values.byName(map[lastChatType]),
      lastMessageType: map[lastChatType] != null
      ? MessageType.values.byName(map[lastChatType])
      : null,
      receiverName: map[receiverNameInChatList],
      isIncomingMessage: map[isIncoming],
      isChatOpen: map[isUserChatOpen] ?? false,
      chatWallpaper: map[dbchatWallpaper],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      chatId: chatID,
      receiverId: receiverID,
      senderId: senderID,
      // isGroupChat: isGroup,
      receiverProfilePhoto: receiverProfileImage,
      chatLastMessageTime: lastMessageTime,
      chatLastMessage: lastMessage,
      chatMuted: isMuted,
      chatMessageNotificationCount: notificationCount,
      lastChatType: lastMessageType?.name,
      lastChatStatus: lastMessageStatus?.name,
      receiverNameInChatList: receiverName,
      'attachments': attachmentsWithMessage,
      isIncoming: isIncomingMessage,
      isUserChatOpen: isChatOpen,
      dbchatWallpaper: chatWallpaper,
    };
  }

  ChatModel copyWith({
    String? chatID,
    String? senderID,
    String? receiverID,
    String? lastMessage,
    String? lastMessageTime,
    MessageStatus? lastMessageStatus,
    MessageType? lastMessageType,
    // bool? isGroup,
    int? notificationCount,
    String? receiverProfileImage,
    String? receiverName,
    bool? isMuted,
    bool? isIncomingMessage,
    bool? isChatOpen,
    String? chatWallpaper,
  }) {
    return ChatModel(
      chatID: chatID ?? this.chatID,
      senderID: senderID ?? this.senderID,
      receiverID: receiverID ?? this.receiverID,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageStatus: lastMessageStatus ?? this.lastMessageStatus,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      notificationCount: notificationCount ?? this.notificationCount,
      receiverProfileImage: receiverProfileImage ?? this.receiverProfileImage,
      receiverName: receiverName ?? this.receiverName,
      isMuted: isMuted ?? this.isMuted,
      isIncomingMessage: isIncomingMessage ?? this.isIncomingMessage,
      isChatOpen: isChatOpen ?? this.isChatOpen,
      // isGroup: isGroup??this.isGroup,
      chatWallpaper: chatWallpaper ?? this.chatWallpaper,
    );
  }
}
