part of 'broadcast_bloc.dart';

class BroadcastState extends Equatable {
  const BroadcastState({this.broadCastList});
  final Stream<List<BroadCastModel>>? broadCastList;
  BroadcastState copyWith({Stream<List<BroadCastModel>>? broadCastList}) {
    return BroadcastState(
      broadCastList: broadCastList ?? this.broadCastList,
    );
  }

  @override
  List<Object> get props => [broadCastList ?? []];
}

class BroadcastInitial extends BroadcastState {}

class BroadcastLoadingState extends BroadcastState {}

class BroadcastErrorState extends BroadcastState {
  final String errorMessage;
  const BroadcastErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [errorMessage];
}
