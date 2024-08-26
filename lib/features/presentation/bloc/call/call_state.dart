part of 'call_bloc.dart';

class CallState extends Equatable {
  const CallState({
    this.callLogList,
    this.callId,
    this.callersId,
  });
  final Stream<List<CallModel>>? callLogList;
  final String? callId;
  final List<String?>? callersId;
  CallState copyWith({
    Stream<List<CallModel>>? callLogList,
    String? callId,
    List<String?>? callersId,
  }) {
    return CallState(
      callLogList: callLogList ?? this.callLogList,
      callId: callId ?? this.callId,
      callersId: callersId ?? this.callersId,
    );
  }

  @override
  List<Object> get props => [callLogList ?? [], callId??'', callersId??''];
}

final class CallInitial extends CallState {}

class CallLoadingState extends CallState {}

class CallErrorState extends CallState {
  final String errorMessage;
  const CallErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [
        errorMessage,
      ];
}
