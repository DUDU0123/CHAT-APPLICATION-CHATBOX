import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/image_picker_method.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/uploaded_status_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/status_repo/status_repository.dart';

import '../../widgets/common_widgets/file_show_page.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final StatusRepository statusRepository;
  StatusBloc({
    required this.statusRepository,
  }) : super(StatusInitial()) {
    on<StatusLoadEvent>(statusLoadEvent);
    on<StatusUploadEvent>(statusUploadEvent);
    on<StatusShareEvent>(statusShareEvent);
    on<StatusDeleteEvent>(statusDeleteEvent);
    on<PickStatusEvent>(pickStatusEvent);
    on<FileResetEvent>(fileResetEvent);
    on<PickTextStatusBgColor>(pickTextStatusBgColor);
    on<UpdateStatusViewersList>(updateStatusViewersList);
  }

  FutureOr<void> statusLoadEvent(
      StatusLoadEvent event, Emitter<StatusState> emit) {
    emit(StatusLoadingState());
    try {
      final Stream<List<StatusModel>>? statusList =
          statusRepository.getAllStatusFromDB();
          statusList?.listen(
            (data)=>log(data.length.toString())
          );
      emit(StatusState(
        statusList: statusList,
      ));
    } catch (e) {
      log("Error on get all status bloc: ${e.toString()}");
      emit(StatusErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> statusUploadEvent(
      StatusUploadEvent event, Emitter<StatusState> emit) async {
    emit(StatusLoadingState());
    try {
      final bool isUploaded = await statusRepository.uploadStatusToDB(
          statusModel: event.statusModel);
      emit(StatusState(
        statusList: state.statusList,
        message: isUploaded ? "Status sent" : "Unable to sent",
      ));
      print(isUploaded.toString());
      add(StatusLoadEvent());
    } catch (e) {
      log("Error on upload status bloc: ${e.toString()}");
      emit(StatusErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> statusShareEvent(
      StatusShareEvent event, Emitter<StatusState> emit) {
    try {} catch (e) {
      log("Error on share status bloc: ${e.toString()}");
      emit(StatusErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> statusDeleteEvent(
      StatusDeleteEvent event, Emitter<StatusState> emit) async {
    try {
      final bool isDeleted = await statusRepository.deleteStatusFromDB(
        statusModelId: event.statusModelId,
        uploadedStatusId: event.uploadedStatusId,
      );
      emit(StatusState(
        statusList: state.statusList,
        message: isDeleted ? "Status sent" : "Unable to sent",
      ));
    } catch (e) {
      log("Error on delete status bloc: ${e.toString()}");
      emit(StatusErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> pickStatusEvent(
      PickStatusEvent event, Emitter<StatusState> emit) async {
    try {
      final file = await pickAsset(assetSelected: event.statusType);
      log("File $file");
      if (event.statusType == StatusType.image) {
        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => FileShowPage(
              pageType: PageTypeEnum.chatStatus,
              statusModel: event.statusModel,
              fileType: FileType.image,
              fileToShow: file,
            ),
          ),
        );
      } else {
        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => FileShowPage(
              pageType: PageTypeEnum.chatStatus,
              statusModel: event.statusModel,
              fileType: FileType.video,
              fileToShow: context.watch<StatusBloc>().state.pickedStatus,
            ),
          ),
        );
      }
      emit(state.copyWith(pickedStatus: file));
    } catch (e) {
      log("Error on pick status bloc: ${e.toString()}");
      emit(StatusErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fileResetEvent(
      FileResetEvent event, Emitter<StatusState> emit) {
    emit(state.copyWith(pickedStatus: null));
  }

  FutureOr<void> pickTextStatusBgColor(
      PickTextStatusBgColor event, Emitter<StatusState> emit) {
    try {
      // Use the currentIndex from the state
      final currentIndex = state.currentIndex;
      if (currentIndex != null) {
        // Get the list of available colors
        final availableColors = event.availableColors;

        // Calculate the new index
        final newIndex = (currentIndex + 1) % availableColors.length;

        // Get the new color
        final newColor = availableColors[newIndex];

        // Emit the new state with updated color and index
        emit(state.copyWith(
          pickedColorOfStatus: newColor,
          currentIndex: newIndex,
        ));
      } else {
        emit(StatusErrorState(errorMessage: "Current index null"));
      }
    } catch (e) {
      emit(StatusErrorState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> updateStatusViewersList(
      UpdateStatusViewersList event, Emitter<StatusState> emit) async {
    try {
      await statusRepository.updateStatusViewersListInDB(
        ownerId: event.ownerId,
        statusModel: event.statusModel,
        uploadedStatusModel: event.uploadedStatusModel,
        viewerId: event.viewerId,
      );
    } catch (e) {
      emit(StatusErrorState(errorMessage: e.toString()));
    }
  }
}
