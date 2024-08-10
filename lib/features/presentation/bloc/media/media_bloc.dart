import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/utils/media_methods.dart';

part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  MediaBloc() : super(MediaInitial()) {
    on<MediaSelectEvent>(mediaSelectEvent);
    on<MediaResetEvent>(mediaResetEvent);
    on<GetAllMediaFiles>(getAllMediaFiles);
    on<MediaDeleteEvent>(mediaDeleteEvent);
    on<MediaRemoveEvent>(mediaRemoveEvent);
  }

  FutureOr<void> mediaSelectEvent(
      MediaSelectEvent event, Emitter<MediaState> emit) {
    if (state.selectedMediaUrls == null) {
      return null;
    }
    final selectedMediaUrls = Set<String>.from(state.selectedMediaUrls!);
    if (selectedMediaUrls.contains(event.mediaUrl)) {
      selectedMediaUrls.remove(event.mediaUrl);
      print('Removed ${event.mediaUrl}');
    } else {
      selectedMediaUrls.add(event.mediaUrl);
      print('Added ${event.mediaUrl}');
    }
    emit(state.copyWith(
      selectedMediaUrls: selectedMediaUrls,
    ));
    print('Updated state: $selectedMediaUrls');
  }

  FutureOr<void> mediaResetEvent(
      MediaResetEvent event, Emitter<MediaState> emit) {
    emit(state.copyWith(selectedMediaUrls: {}));
  }

  FutureOr<void> getAllMediaFiles(
      GetAllMediaFiles event, Emitter<MediaState> emit) {
    try {
      final Stream<List<String>> allMediaFiles =
          MediaMethods.getAllUserMediaFilesStream(
        firebaseAuth.currentUser!.uid,
      );
      emit(MediaState(allMediaFiles: allMediaFiles));
    } catch (e) {
      emit(MediaErrorState(errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> mediaDeleteEvent(
      MediaDeleteEvent event, Emitter<MediaState> emit) async {
    try {
      for (var selectedMedia in event.selectedMedias) {
        await MediaMethods.deleteMediaFromStorageUsingUrl(
          downloadUrl: selectedMedia,
        );
      }
      emit(state.copyWith(
        selectedMediaUrls: {},
        allMediaFiles: state.allMediaFiles,
      ));
    } catch (e) {
      emit(MediaErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> mediaRemoveEvent(
      MediaRemoveEvent event, Emitter<MediaState> emit) {
    final allMediaFilesStream = state.allMediaFiles;
    if (allMediaFilesStream == null) return null;

    allMediaFilesStream.listen((allMediaFiles) {
      final updatedMediaFiles = List<String>.from(allMediaFiles)
        ..remove(event.mediaUrl);

      emit(state.copyWith(
        allMediaFiles: Stream.value(updatedMediaFiles),
      ));
    });
  }
}
