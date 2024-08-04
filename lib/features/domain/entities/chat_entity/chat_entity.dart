import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/domain/entities/message_entity/message_entity.dart';
class ChatEntity extends Equatable {
  final String? chatID;
  final String? receiverID;
  final String? chatWallpaper;
  final String? receiverName;
  final String? receiverProfileImage;
  
  final List<MessageAttachmentModel>? attachmentsWithMessage;
  final bool? isMuted;
  final MessageStatus? lastMessageStatus;
  final String? lastMessage;
  final String? lastMessageTime;
  final MessageType? lastMessageType;
  final int? notificationCount;
  final bool? isIncomingMessage;
  final bool? isChatOpen;
  final String? senderID;
  final bool? isGroup;
  const ChatEntity({
    this.chatID,
    this.receiverID,
    this.chatWallpaper,
    this.receiverName,
    this.receiverProfileImage,
    this.attachmentsWithMessage,
    this.isMuted,
    this.lastMessageStatus,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageType,
    this.notificationCount,
    this.isIncomingMessage,
    this.isChatOpen,
    this.senderID,
    this.isGroup,
  });

  @override
  List<Object?> get props {
    return [
      chatID,
      receiverID,
      lastMessage,
      lastMessageTime,
      receiverProfileImage,
      isMuted,
      notificationCount,
      senderID,
      lastMessageStatus,
      lastMessageType,
      receiverName,
      attachmentsWithMessage,
      isIncomingMessage,
      isChatOpen,
      isGroup,chatWallpaper,
    ];
  }
}
