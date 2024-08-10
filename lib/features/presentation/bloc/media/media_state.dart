part of 'media_bloc.dart';

class MediaState extends Equatable {
  final Stream<List<String>>? allMediaFiles;
  final Set<String>? selectedMediaUrls;

  const MediaState({
    this.allMediaFiles,
    this.selectedMediaUrls = const {},
  });

  MediaState copyWith({
    Set<String>? selectedMediaUrls,
    Stream<List<String>>? allMediaFiles,
  }) {
    return MediaState(
      selectedMediaUrls: selectedMediaUrls ?? this.selectedMediaUrls,
      allMediaFiles: allMediaFiles ?? this.allMediaFiles,
    );
  }

  @override
  List<Object> get props => [selectedMediaUrls ?? {}, allMediaFiles??[],];
}

class MediaInitial extends MediaState {}
class MediaErrorState extends MediaState {
  final String errorMessage;
  const MediaErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [
    errorMessage,
  ];
}