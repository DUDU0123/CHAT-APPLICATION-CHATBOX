import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';

class MessageEntity extends Equatable {
  final String? messageId;
  final String? senderID;
  final String? receiverID;
  final String? message;
  final String? messageTime;
  final MessageStatus? messageStatus;
  final MessageType? messageType;
  final bool? isEditedMessage;
  final MessageModel? replyToMessage;
  final bool? isDeletedMessage;
  final bool? isStarredMessage;
  final bool? isPinnedMessage;
  final String? name;
  const MessageEntity({
    this.name,
    this.messageId,
    this.senderID,
    this.receiverID,
    this.message,
    this.messageTime,
    this.messageStatus,
    this.messageType,
    this.isEditedMessage,
    this.isDeletedMessage,
    this.isStarredMessage,
    this.isPinnedMessage,
    this.replyToMessage,
  });

  @override
  List<Object?> get props {
    return [
      name,
      messageId,
      senderID,
      receiverID,
      message,
      messageTime,
      messageStatus,
      messageType,
      isEditedMessage,
      isDeletedMessage,
      isStarredMessage,
      isPinnedMessage,
      replyToMessage,
    ];
  }
}

