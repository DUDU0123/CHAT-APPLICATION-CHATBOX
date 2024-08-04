import 'package:official_chatbox_application/features/data/data_sources/status_data/status_data.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/uploaded_status_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/status_repo/status_repository.dart';

class StatusRepositoryImpl extends StatusRepository {
  final StatusData statusData;
  StatusRepositoryImpl({
    required this.statusData,
  });
  @override
  Stream<List<StatusModel>>? getAllStatusFromDB() {
    return statusData.getAllStatus();
  }

  @override
  Future<bool> uploadStatusToDB({required StatusModel statusModel}) {
    return statusData.uploadStatus(statusModel: statusModel);
  }

  @override
  Future<bool> deleteStatusFromDB(
      {required String statusModelId, required String uploadedStatusId}) {
    return statusData.deleteStatus(
      statusModelId: statusModelId,
      uploadedStatusId: uploadedStatusId,
    );
  }

  @override
  Future<void> updateStatusViewersListInDB({
    required StatusModel statusModel,
    required UploadedStatusModel uploadedStatusModel,
    required String viewerId,
  }) async {
    await statusData.updateStatusViewersList(
      statusModel: statusModel,
      uploadedStatusModel: uploadedStatusModel,
      viewerId: viewerId,
    );
  }
}
