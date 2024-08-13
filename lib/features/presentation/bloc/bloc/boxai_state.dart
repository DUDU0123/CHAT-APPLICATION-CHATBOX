part of 'boxai_bloc.dart';

class BoxAIState extends Equatable {
  const BoxAIState({
    this.aiChatMessages,
  });
  final Stream<List<MessageModel>>? aiChatMessages;
  BoxAIState copyWith({Stream<List<MessageModel>>? aiChatMessages}) {
    return BoxAIState(
      aiChatMessages: aiChatMessages ?? this.aiChatMessages,
    );
  }

  @override
  List<Object> get props => [
        aiChatMessages ?? [],
      ];
}

final class BoxAIInitial extends BoxAIState {}

class BoxAIErrorState extends BoxAIState {
  final String errorMessage;
  const BoxAIErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [
        errorMessage,
      ];
}
