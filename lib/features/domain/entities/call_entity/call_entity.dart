import 'package:equatable/equatable.dart';

import 'package:official_chatbox_application/core/enums/enums.dart';

class CallEntity extends Equatable {
  final String? callId;
  final List<String>? callrecieversId;
  final String? callerId;
  final bool? isMissedCall;
  final bool? isIncomingCall;
  final bool? isGroupCall;
  final String? callStartTime;
  final String? callEndTime;
  final CallType? callType;
  final String? callDuration;
  final String? chatModelId;
  final String? groupModelId;
  final String? callStatus;
  final String? receiverName;
  final String? receiverImage;

  const CallEntity({
    this.callId,
    this.callrecieversId,
    this.callerId,
    this.isMissedCall,
    this.isIncomingCall,
    this.isGroupCall,
    this.callStartTime,
    this.callEndTime,
    this.callType,
    this.callDuration,
    this.chatModelId,
    this.groupModelId,
    this.callStatus,
    this.receiverName,
     this.receiverImage,
  });

  @override
  List<Object?> get props {
    return [
      callId,
      callrecieversId,
      callerId,
      isMissedCall,
      isIncomingCall,
      isGroupCall,
      callStartTime,
      callEndTime,
      callType,
      callDuration,
      chatModelId,
      groupModelId,
      callStatus,
      receiverName,receiverImage,
    ];
  }
}
