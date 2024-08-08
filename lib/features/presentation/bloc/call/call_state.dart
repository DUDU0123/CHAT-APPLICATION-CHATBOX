part of 'call_bloc.dart';

class CallState extends Equatable {
  const CallState({
    this.callLogList,
  });
  final Stream<List<CallModel>>? callLogList;
  CallState copyWith({Stream<List<CallModel>>? callLogList}) {
    return CallState(
      callLogList: callLogList ?? this.callLogList,
    );
  }

  @override
  List<Object> get props => [callLogList ?? []];
}

final class CallInitial extends CallState {}
class CallLoadingState extends CallState{}
class CallErrorState extends CallState {
  final String errorMessage;
  const CallErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [errorMessage,];
}
