import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/domain/entities/call_entity/call_entity.dart';

class CallModel extends CallEntity {
  const CallModel({
    super.callId,
    super.callerId,
    super.callrecieversId,
    super.callStartTime,
    super.callEndTime,
    super.callDuration,
    super.callType,
    super.isGroupCall,
    super.isIncomingCall,
    super.isMissedCall,
    super.chatModelId,
    super.groupModelId,
    super.callStatus,
    super.receiverName,
    super.receiverImage,
  });

  factory CallModel.fromJson({required Map<String, dynamic> map}) {
    return CallModel(
      callId: map[dbCallId],
      callerId: map[dbCallerId],
      callrecieversId: (map[dbCallRecieversId] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      callStartTime: map[dbCallStartTime],
      callEndTime: map[dbCallEndTime],
      callDuration: map[dbCallDuration],
      callType: CallType.values.byName(map[dbCallType]),
      isGroupCall: map[dbIsGroupCall],
      isIncomingCall: map[dbIsIncomingCall],
      isMissedCall: map[dbIsMissedCall],
      chatModelId: map[dbCallChatModelId],
      groupModelId: map[dbCallGroupModelId],
      callStatus: map[dbCallStatus],
      receiverName: map[dbCallReceiverName],
      receiverImage: map[dbReceiverImage],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      dbCallId: callId,
      dbCallerId: callerId,
      dbCallRecieversId: callrecieversId,
      dbCallStartTime: callStartTime,
      dbCallEndTime: callEndTime,
      dbCallDuration: callDuration,
      dbCallType: callType?.name,
      dbIsGroupCall: isGroupCall,
      dbIsIncomingCall: isIncomingCall,
      dbIsMissedCall: isMissedCall,
      dbCallChatModelId: chatModelId,
      dbCallGroupModelId: groupModelId,
      dbCallStatus: callStatus,
      dbCallReceiverName: receiverName,dbReceiverImage: receiverImage,
    };
  }

  CallModel copyWith({
    String? callId,
    List<String>? callrecieversId,
    String? callerId,
    bool? isMissedCall,
    bool? isIncomingCall,
    bool? isGroupCall,
    String? callStartTime,
    String? callEndTime,
    CallType? callType,
    String? callDuration,
    String? groupModelId,
    String? chatModelId,
    String? callStatus,
    String? receiverName,String? receiverImage,
  }) {
    return CallModel(
      callId: callId ?? this.callId,
      callrecieversId: callrecieversId ?? this.callrecieversId,
      callerId: callerId ?? this.callerId,
      isMissedCall: isMissedCall ?? this.isMissedCall,
      isIncomingCall: isIncomingCall ?? this.isIncomingCall,
      isGroupCall: isGroupCall ?? this.isGroupCall,
      callStartTime: callStartTime ?? this.callStartTime,
      callEndTime: callEndTime ?? this.callEndTime,
      callType: callType ?? this.callType,
      callDuration: callDuration ?? this.callDuration,
      chatModelId: chatModelId ?? this.chatModelId,
      groupModelId: groupModelId ?? this.groupModelId,
      callStatus: callStatus ?? this.callStatus,
      receiverName: receiverName ?? this.receiverName,receiverImage: receiverImage?? this.receiverImage,

    );
  }
}
