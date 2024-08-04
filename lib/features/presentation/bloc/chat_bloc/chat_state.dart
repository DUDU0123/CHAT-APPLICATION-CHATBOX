part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final Stream<List<ChatModel>>? chatList;
  final File? pickedFile;
  final String? message;
  const ChatState({
    this.chatList,
    this.pickedFile,
    this.message,
  });

  ChatState copyWith({
    Stream<List<ChatModel>>? chatList,
    File? pickedFile,String? message,
  }) {
    return ChatState(
      chatList: chatList ?? this.chatList,
      pickedFile: pickedFile ?? this.pickedFile,message: message ?? this.message
    );
  }

  @override
  List<Object> get props => [
        chatList ?? [],
        pickedFile ?? File(''),
      ];
}

class ChatInitial extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatErrorState extends ChatState {
  final String errormessage;
  const ChatErrorState({
    required this.errormessage,
  });
  @override
  List<Object> get props => [errormessage];
}

class ClearChatsLoadingState extends ChatState {}

class ClearChatsSuccessState extends ChatState {
  final String clearChatMessage;

  const ClearChatsSuccessState({required this.clearChatMessage});

  @override
  List<Object> get props => [clearChatMessage];
}

class ClearChatsErrorState extends ChatState {
  final String errorMessage;

  const ClearChatsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}