part of 'boxai_bloc.dart';

sealed class BoxAIEvent extends Equatable {
  const BoxAIEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends BoxAIEvent {
  final String message;
  const SendMessageEvent({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class GetAllAIChatMessages extends BoxAIEvent {}

class DeleteMessageEvent extends BoxAIEvent {
  final String messageId;
  const DeleteMessageEvent({
    required this.messageId,
  });
  @override
  List<Object> get props => [messageId];
}

class ClearChatEvent extends BoxAIEvent {}
