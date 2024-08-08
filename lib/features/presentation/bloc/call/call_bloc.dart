import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';
import 'package:official_chatbox_application/features/data/repositories/call_repo_impl/call_repository_impl.dart';
part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepositoryImpl callRepository;
  CallBloc({
    required this.callRepository,
  }) : super(CallInitial()) {
    on<CallInfoSaveEvent>(callInfoSaveEvent);
    on<GetAllCallLogEvent>(getAllCallLogEvent);
    on<DeleteACallLogEvent>(deleteACallLogEvent);
  }

  FutureOr<void> callInfoSaveEvent(
      CallInfoSaveEvent event, Emitter<CallState> emit) {
    try {
      callRepository.saveCallInfo(callModel: event.callModel);
    } catch (e) {
      emit(CallErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getAllCallLogEvent(
      GetAllCallLogEvent event, Emitter<CallState> emit) {
    try {
      final Stream<List<CallModel>>? callLogList =
          callRepository.getAllCallLogs();
      emit(CallState(callLogList: callLogList));
    } catch (e) {
      emit(CallErrorState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> deleteACallLogEvent(
      DeleteACallLogEvent event, Emitter<CallState> emit) async {
    try {
      final bool value = await callRepository.deleteOneCallInfo(
        callModelId: event.callId,
      );
      log("Deleted: $value");
      add(GetAllCallLogEvent());
    } catch (e) {
      emit(CallErrorState(errorMessage: e.toString()));
    }
  }
}
