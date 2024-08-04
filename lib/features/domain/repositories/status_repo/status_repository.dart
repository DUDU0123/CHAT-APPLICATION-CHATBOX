import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';

abstract class StatusRepository{
  // method to upload a status
  Future<bool> uploadStatusToDB({required StatusModel statusModel});
  // method to get/read all status
  Stream<List<StatusModel>>? getAllStatusFromDB();
  // method to delete a status
  Future<bool> deleteStatusFromDB({
    required String statusModelId,
    required String uploadedStatusId
  });
}