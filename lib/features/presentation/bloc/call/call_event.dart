part of 'call_bloc.dart';

sealed class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object> get props => [];
}

class CallInfoSaveEvent extends CallEvent {
  final CallModel callModel;
  const CallInfoSaveEvent({
    required this.callModel,
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
}
