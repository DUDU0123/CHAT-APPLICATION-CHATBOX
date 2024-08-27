import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/report_model/report_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/chat_repo/chat_repo.dart';
import 'package:rxdart/rxdart.dart';
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
    on<ChatUpdateEvent>(chatUpdateEvent);
    on<ReportAccountEvent>(reportAccountEvent);
    on<CheckIsBlockedUserEvent>(checkIsBlockedUserEvent);
    on<ChatSearchEvent>(chatSearchEvent);
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

  Future<void> clearAllChatsEvent(
      ClearAllChatsEvent event, Emitter<ChatState> emit) async {
    emit(ClearChatsLoadingState());
    try {
      final isCleared = await chatRepo.clearAllChatsInApp();
      if (isCleared) {
        emit(const ClearChatsSuccessState(
          clearChatMessage: "Cleared all chats",
        ));
        add(GetAllChatsEvent());
      } else {
        emit(const ClearChatsErrorState(errorMessage: "Can't clear the chats"));
      }
    } catch (e) {
      emit(ClearChatsErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> chatUpdateEvent(
      ChatUpdateEvent event, Emitter<ChatState> emit) async {
    try {
      final isUpdated =
          await chatRepo.updateChatData(chatModel: event.chatModel);
      log(name: "Mute notification", isUpdated.toString());
      if (isUpdated) {
        add(GetAllChatsEvent());
      } else {
        emit(const ChatErrorState(errormessage: "Cannot update data"));
      }
    } catch (e) {
      emit(ChatErrorState(errormessage: e.toString()));
    }
  }

  Future<FutureOr<void>> reportAccountEvent(
      ReportAccountEvent event, Emitter<ChatState> emit) async {
    try {
      final value =
          await chatRepo.reportAccount(reportModel: event.reportModel);
      log(name: "reported user", value.toString());
      if (value) {
        commonSnackBarWidget(
            context: event.context, contentText: "Reported successfully");
        add(GetAllChatsEvent());
      } else {
        emit(const ChatErrorState(errormessage: "Unable to report user"));
      }
    } catch (e) {
      emit(ChatErrorState(errormessage: e.toString()));
    }
  }

  Future<FutureOr<void>> checkIsBlockedUserEvent(
      CheckIsBlockedUserEvent event, Emitter<ChatState> emit) async {
    try {
      if (event.currentUserId != null && event.receiverID != null) {
        final isBlockedUser = await CommonDBFunctions.checkIfIsBlocked(
          receiverId: event.receiverID!,
          currentUserId: event.currentUserId!,
        );
        state.copyWith(
          isBlockedUser: isBlockedUser,
          chatList: state.chatList,
          message: state.message,
          pickedFile: state.pickedFile,
        );
      }
    } catch (e) {
      emit(ChatErrorState(errormessage: e.toString()));
    }
  }

  FutureOr<void> chatSearchEvent(
      ChatSearchEvent event, Emitter<ChatState> emit) {
    final debouncedSearchStream = Rx.timer(
      event.searchInput,
      const Duration(milliseconds: 500),
    ).flatMap((searchInput) {
      final searchStream = fireStore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser?.uid)
          .collection(chatsCollection)
          .where(receiverNameInChatList, isGreaterThanOrEqualTo: searchInput)
          .where(receiverNameInChatList, isLessThanOrEqualTo: searchInput + '\uf8ff')
          .snapshots();

      // Map the Firestore snapshots into a list of UserModel
      final filteredUserStream = searchStream.map((snapshot) {
        return snapshot.docs
            .map((doc) => ChatModel.fromJson(doc.data()))
            .toList();
      });

      return filteredUserStream;
    });

    emit(
      state.copyWith(
        chatList: debouncedSearchStream,
      ),
    );
  }
}
