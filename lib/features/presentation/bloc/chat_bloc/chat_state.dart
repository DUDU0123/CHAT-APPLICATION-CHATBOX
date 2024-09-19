part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final Stream<List<ChatModel>>? chatList;
  final List<ChatModel>? searchedList;
  final File? pickedFile;
  final bool? isBlockedUser;
  final String? message;
  const ChatState({
    this.chatList,
    this.pickedFile,
    this.isBlockedUser,
    this.message,
    this.searchedList,
  });

  ChatState copyWith({
    Stream<List<ChatModel>>? chatList,
    File? pickedFile,
    String? message,
    bool? isBlockedUser,
    List<ChatModel>? searchedList,
  }) {
    return ChatState(
      chatList: chatList ?? this.chatList,
      pickedFile: pickedFile ?? this.pickedFile,
      message: message ?? this.message,
      isBlockedUser: isBlockedUser ?? this.isBlockedUser,
      searchedList: searchedList ?? this.searchedList,
    );
  }

  @override
  List<Object> get props => [
        chatList ?? [],
        pickedFile ?? File(''),
        isBlockedUser ?? false,
        message ?? '', searchedList??[]
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
