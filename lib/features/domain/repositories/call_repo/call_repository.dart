import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';

abstract class CallRepository{
  Future<void> saveCallInfo({required CallModel callModel});
  Stream<List<CallModel>>? getAllCallLogs();
  Future<bool> deleteOneCallInfo({required String callModelId});
}