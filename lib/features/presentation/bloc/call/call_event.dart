part of 'call_bloc.dart';

sealed class CallEvent extends Equatable {
  const CallEvent();
  @override
  List<Object> get props => [];
}

class CallInfoSaveEvent extends CallEvent {
  final CallModel callModel;
  final BuildContext context;
  const CallInfoSaveEvent({
    required this.callModel,
    required this.context,
  });
  @override
  List<Object> get props => [callModel];
}

class CallInfoUpdateEvent extends CallEvent {
  final CallModel callModel;
  const CallInfoUpdateEvent({
    required this.callModel,
  });
  @override
  List<Object> get props => [callModel];
}

class GetAllCallLogEvent extends CallEvent {}

class DeleteACallLogEvent extends CallEvent {
  final String callId;
  const DeleteACallLogEvent({
    required this.callId,
  });
  @override
  List<Object> get props => [callId];
}

class GetCurrentCallIdAndCallersId extends CallEvent {
  final String callId;
  final List<String?> callersId;
  const GetCurrentCallIdAndCallersId({
    required this.callId,
    required this.callersId,
  });
  @override
  List<Object> get props => [callId, callersId];
}

class UpdateCallStatusEvent extends CallEvent {
  final String callStatus;
  const UpdateCallStatusEvent({
    required this.callStatus,
  });
  @override
  List<Object> get props => [
        callStatus,
      ];
}
