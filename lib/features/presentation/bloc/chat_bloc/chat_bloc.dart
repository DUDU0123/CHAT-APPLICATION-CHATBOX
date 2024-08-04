import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/chat_repo/chat_repo.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo chatRepo;
  ChatBloc({
    required this.chatRepo,
  }) : super(ChatInitial()) {
    on<CreateANewChatEvent>(createANewChatEvent);
    on<GetAllChatsEvent>(getAllChatsEvent);
    on<DeletAChatEvent>(deleteAChatEvent);
    on<ClearChatEvent>(clearChatEvent);
    on<PickImageEvent>(pickImageEvent);
    on<ClearAllChatsEvent>(clearAllChatsEvent);
  }

  FutureOr<void> createANewChatEvent(
      CreateANewChatEvent event, Emitter<ChatState> emit) async {
    try {
      await chatRepo.createNewChat(
        receiverId: event.receiverId,
        recieverContactName: event.recieverContactName,
      );
      add(GetAllChatsEvent());
    } catch (e) {
      log("Create chat: e ${e.toString()}");
      emit(ChatErrorState(errormessage: e.toString()));
    }
  }

  FutureOr<void> getAllChatsEvent(
      GetAllChatsEvent event, Emitter<ChatState> emit) {
    emit(ChatLoadingState());
    try {
      log("Get all chats event called");
      Stream<List<ChatModel>> chatList = chatRepo.getAllChats();
      // emit(ChatSuccessState(chatList: chatList));
      emit(ChatState(chatList: chatList));
    } catch (e) {
      log("Create chat: e ${e.toString()}");
      emit(ChatErrorState(errormessage: e.toString()));
    }
  }

  Future<FutureOr<void>> deleteAChatEvent(
      DeletAChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      event.chatModel != null
          ? chatRepo.deleteAChat(
              chatModel: event.chatModel!,
            )
          : null;
      add(GetAllChatsEvent());
    } catch (e) {
      log("Delete chat: e ${e.toString()}");
      emit(ChatErrorState(errormessage: e.toString()));
    }
  }

  FutureOr<void> clearChatEvent(
      ClearChatEvent event, Emitter<ChatState> emit) async {
    try {
      await chatRepo.clearChatMethodInOneToOne(chatID: event.chatId);
    } catch (e) {
      log("Clear chat: e ${e.toString()}");
      emit(ChatErrorState(errormessage: e.toString()));
    }
  }

  FutureOr<void> pickImageEvent(PickImageEvent event, Emitter<ChatState> emit) {
    try {
      emit(state.copyWith(
          pickedFile: event.pickedFile, chatList: state.chatList));
    } catch (e) {
      emit(ChatErrorState(errormessage: e.toString()));
    }
  }

 Future<void> clearAllChatsEvent(ClearAllChatsEvent event, Emitter<ChatState> emit) async {
    emit(ClearChatsLoadingState());
    try {
      final isCleared = await chatRepo.clearAllChatsInApp();
      if (isCleared) {
        emit(const ClearChatsSuccessState(clearChatMessage: "Cleared all chats"));
        add(GetAllChatsEvent());
      } else {
        emit(const ClearChatsErrorState(errorMessage: "Can't clear the chats"));
      }
    } catch (e) {
      emit(ClearChatsErrorState(errorMessage: e.toString()));
    }
  }
}
