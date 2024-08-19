import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/ai_repo/ai_repository.dart';

part 'boxai_event.dart';
part 'boxai_state.dart';

class BoxAIBloc extends Bloc<BoxAIEvent, BoxAIState> {
  final AIRepository aiRepository;
  BoxAIBloc({
    required this.aiRepository,
  }) : super(BoxAIInitial()) {
    on<SendMessageEvent>(sendMessageEvent);
    on<GetAllAIChatMessages>(getAllAIChatMessages);
    on<DeleteMessageEvent>(deleteMessageEvent);
    on<ClearChatEvent>(clearChatEvent);
  }

  Future<FutureOr<void>> sendMessageEvent(
      SendMessageEvent event, Emitter<BoxAIState> emit) async {
    try {
      final value = await aiRepository.sendMessageInAIChat(
        messageText: event.message,
      );
      if (value) {
        add(GetAllAIChatMessages());
      } else {
        emit(const BoxAIErrorState(errorMessage: "Unable to send message"));
      }
    } catch (e) {
      emit(BoxAIErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getAllAIChatMessages(
      GetAllAIChatMessages event, Emitter<BoxAIState> emit) {
    try {
      final aiChatMessages = aiRepository.getAllAIChatMessages();
      emit(BoxAIState(aiChatMessages: aiChatMessages));
    } catch (e) {
      emit(BoxAIErrorState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> deleteMessageEvent(
      DeleteMessageEvent event, Emitter<BoxAIState> emit) async {
    try {
      final value = await aiRepository.deleteMessage(
        messageId: event.messageId,
      );
      if (value) {
        add(GetAllAIChatMessages());
      } else {
        emit(const BoxAIErrorState(errorMessage: "Unable to delete message"));
      }
    } catch (e) {
      emit(BoxAIErrorState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> clearChatEvent(
      ClearChatEvent event, Emitter<BoxAIState> emit) async {
    try {
      final value = await aiRepository.clearChat();
      if (value) {
        add(GetAllAIChatMessages());
      } else {
        emit(const BoxAIErrorState(errorMessage: "Unable to clear the chat"));
      }
    } catch (e) {
      emit(BoxAIErrorState(errorMessage: e.toString()));
    }
  }
}
