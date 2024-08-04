part of 'broadcast_bloc.dart';

sealed class BroadcastEvent extends Equatable {
  const BroadcastEvent();

  @override
  List<Object> get props => [];
}

class CreateBroadCastEvent extends BroadcastEvent {
  final BroadCastModel newBroadCastModel;
  const CreateBroadCastEvent({
    required this.newBroadCastModel,
  });
  @override
  List<Object> get props => [newBroadCastModel];
}
class GetAllBroadCastEvent extends BroadcastEvent{}
class UpdateBroadCastEvent extends BroadcastEvent{}
class DeleteBroadCastEvent extends BroadcastEvent{}