part of 'media_bloc.dart';

sealed class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object> get props => [];
}

class GetAllMediaFiles extends MediaEvent {}

class MediaSelectEvent extends MediaEvent {
  final String mediaUrl;

  const MediaSelectEvent(this.mediaUrl);

  @override
  List<Object> get props => [mediaUrl];
}

class MediaResetEvent extends MediaEvent {
  @override
  List<Object> get props => [];
}

class MediaDeleteEvent extends MediaEvent {
  final Set<String> selectedMedias;
  const MediaDeleteEvent({
    required this.selectedMedias,
  });
  @override
  List<Object> get props => [
        selectedMedias,
      ];
}
class MediaRemoveEvent extends MediaEvent {
  final String mediaUrl;

  const MediaRemoveEvent(this.mediaUrl);

  @override
  List<Object> get props => [mediaUrl];
}