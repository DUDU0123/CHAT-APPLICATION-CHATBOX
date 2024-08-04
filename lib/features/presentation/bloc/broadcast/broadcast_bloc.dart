import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/features/data/models/broadcast_model/broadcast_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/broadcast_repo/broadcast_repository.dart';
part 'broadcast_event.dart';
part 'broadcast_state.dart';

class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  final BroadcastRepository broadcastRepository;
  BroadcastBloc({
    required this.broadcastRepository,
  }) : super(BroadcastInitial()) {
    on<GetAllBroadCastEvent>(getAllBroadCastEvent);
    on<CreateBroadCastEvent>(createBroadCastEvent);
    on<UpdateBroadCastEvent>(updateBroadCastEvent);
    on<DeleteBroadCastEvent>(deleteBroadCastEvent);
  }

  Future<FutureOr<void>> createBroadCastEvent(
      CreateBroadCastEvent event, Emitter<BroadcastState> emit) async {
    try {
      final isBroadCastCreated = await broadcastRepository.createBroadCast(
        brocastModel: event.newBroadCastModel,
      );
      log("Brodcast creared $isBroadCastCreated");
      if (isBroadCastCreated) {
        add(GetAllBroadCastEvent());
      } else {
        emit(const BroadcastErrorState(
            errorMessage: "Unable to create broadcast"));
      }
    } catch (e) {
      emit(BroadcastErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> getAllBroadCastEvent(
      GetAllBroadCastEvent event, Emitter<BroadcastState> emit) async {
    try {
      final broadcastList = broadcastRepository.getAllBroadCast();
      emit(BroadcastState(broadCastList: broadcastList));
    } catch (e) {
      emit(BroadcastErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> updateBroadCastEvent(
      UpdateBroadCastEvent event, Emitter<BroadcastState> emit) {}

  FutureOr<void> deleteBroadCastEvent(
      DeleteBroadCastEvent event, Emitter<BroadcastState> emit) {}

  
}
