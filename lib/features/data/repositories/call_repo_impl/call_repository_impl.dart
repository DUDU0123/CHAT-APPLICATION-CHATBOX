import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/data/data_sources/call_data/call_data.dart';
import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/call_repo/call_repository.dart';

class CallRepositoryImpl extends CallRepository {
  final CallData callData;
  CallRepositoryImpl({
    required this.callData,
  });
  @override
  Future<void> saveCallInfo({required CallModel callModel,  required BuildContext context,}) async{
    await callData.saveCallInfo(callModel: callModel, context: context,);
  }
  
  @override
  Stream<List<CallModel>>? getAllCallLogs() {
    return callData.getAllCallLogs();
  }
  
  @override
  Future<bool> deleteOneCallInfo({required String callModelId}) async{
    return await callData.deleteOneCallInfo(callModelId: callModelId);
  }

}
