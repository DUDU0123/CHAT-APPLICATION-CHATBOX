part of 'status_bloc.dart';

class StatusState extends Equatable {
  StatusState({
    this.statusList,
    this.pickedStatus,
    this.pickedColorOfStatus,
    this.message,
    this.currentIndex = 0,
  });
  final Stream<List<StatusModel>>? statusList;
  File? pickedStatus;
  final Color? pickedColorOfStatus;
  final int? currentIndex;

  final String? message;
  StatusState copyWith({
    Stream<List<StatusModel>>? statusList,
    String? message,
    File? pickedStatus,
    Color? pickedColorOfStatus,
     int? currentIndex,
  }) {
    return StatusState(
      statusList: statusList ?? this.statusList,
      message: message ?? this.message,
      pickedStatus: pickedStatus ?? this.pickedStatus,
      pickedColorOfStatus: pickedColorOfStatus ?? this.pickedColorOfStatus,currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object> get props => [
        statusList ?? [],
        message ?? '',
        pickedStatus ?? File(''),
        pickedColorOfStatus ?? Colors.black,currentIndex??0,
      ];
}

class StatusInitial extends StatusState {}

class StatusLoadingState extends StatusState {}

class StatusErrorState extends StatusState {
  final String errorMessage;
  StatusErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [
        errorMessage,
      ];
}
