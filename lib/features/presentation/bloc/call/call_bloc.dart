import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/call_repo/call_repository.dart';
part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepository callRepository;
  CallBloc({
    required this.callRepository,
  }) : super(CallInitial()) {
    on<CallInfoSaveEvent>(callInfoSaveEvent);
    on<GetAllCallLogEvent>(getAllCallLogEvent);
    on<DeleteACallLogEvent>(deleteACallLogEvent);
    on<GetCurrentCallIdAndCallersId>(getCurrentCallIdAndCallersId);
    on<UpdateCallStatusEvent>(updateCallStatusEvent);
    on<ClearAllCallLogs>(clearAllCallLogs);
  }

  FutureOr<void> callInfoSaveEvent(
      CallInfoSaveEvent event, Emitter<CallState> emit) {
    try {
      callRepository.saveCallInfo(
        callModel: event.callModel,
        context: event.context,
      );
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
      add(GetAllCallLogEvent());
    } catch (e) {
      emit(CallErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getCurrentCallIdAndCallersId(
      GetCurrentCallIdAndCallersId event, Emitter<CallState> emit) {
    try {
      emit(
        CallState(
            callId: event.callId,
            callersId: event.callersId,
            callLogList: state.callLogList),
      );
    } catch (e) {
      emit(CallErrorState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> updateCallStatusEvent(
      UpdateCallStatusEvent event, Emitter<CallState> emit) async {
    try {
      if (state.callersId != null) {
        for (var callerID in state.callersId!) {
          await fireStore
              .collection(usersCollection)
              .doc(callerID)
              .collection(callsCollection)
              .doc(state.callId)
              .update({
            dbCallStatus: event.callStatus,
          });
        }
      }

      add(GetAllCallLogEvent());
    } catch (e) {
      emit(CallErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> clearAllCallLogs(
      ClearAllCallLogs event, Emitter<CallState> emit) async{
    try {
      final value = await callRepository.clearCallLogs();
      if (value) {
        add(GetAllCallLogEvent());
      }
    } catch (e) {
      emit(CallErrorState(errorMessage: e.toString()));
    }
  }
}
