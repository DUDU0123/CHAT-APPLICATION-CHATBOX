part of 'status_bloc.dart';

sealed class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

class StatusLoadEvent extends StatusEvent {}

class StatusUploadEvent extends StatusEvent {
  final StatusModel statusModel;
  const StatusUploadEvent({
    required this.statusModel,
  });
  @override
  List<Object> get props => [
        statusModel,
      ];
}

class StatusShareEvent extends StatusEvent {}

class StatusDeleteEvent extends StatusEvent {
  final String statusModelId;
  final String uploadedStatusId;
  const StatusDeleteEvent({
    required this.statusModelId,
    required this.uploadedStatusId,
  });
  @override
  List<Object> get props => [
        statusModelId,
        uploadedStatusId,
      ];
}

class PickStatusEvent extends StatusEvent {
  final StatusType statusType;
  final StatusModel? statusModel;
  final BuildContext context;
  const PickStatusEvent({
    required this.statusType,
    required this.statusModel,
    required this.context,
  });
  @override
  List<Object> get props => [
        statusType,
        context,
        statusModel ?? const StatusModel(),
      ];
}

class FileResetEvent extends StatusEvent {
  const FileResetEvent();
  @override
  List<Object> get props => [];
}

class PickTextStatusBgColor extends StatusEvent {
  final List<Color> availableColors;
  const PickTextStatusBgColor({
    required this.availableColors,
  });
}
