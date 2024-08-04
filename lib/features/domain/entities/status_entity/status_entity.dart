import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/features/data/models/status_model/uploaded_status_model.dart';

class StatusEntity extends Equatable {
  final String? statusId;
  final String? statusUploaderId;
  final String? statusUploaderName;
  final List<UploadedStatusModel>? statusList;
  final dynamic timeStamp;
  const StatusEntity({
    this.statusId,
    this.statusUploaderId,
    this.statusUploaderName,
    this.statusList,
    this.timeStamp,
  });

  @override
  List<Object?> get props => [
        statusId,
        statusUploaderName,
        statusList,
        statusUploaderId,
        timeStamp,
      ];
}
