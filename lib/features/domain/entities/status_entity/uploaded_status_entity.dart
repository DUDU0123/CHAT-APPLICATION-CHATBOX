import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';

class UploadedStatusEntity extends Equatable {
  final String? uploadedStatusId;
  final StatusType? statusType;
  final String? statusCaption;
  final String? statusContent;
  final String? statusUploadedTime;
  final String? statusDuration;
  final bool? isViewedStatus;
  final Color? textStatusBgColor;
  const UploadedStatusEntity({
    this.uploadedStatusId,
    this.statusType,
    this.statusCaption,
    this.statusContent,
    this.statusUploadedTime,
    this.statusDuration,
    this.textStatusBgColor,
    this.isViewedStatus,
  });

  @override
  List<Object?> get props => [
        uploadedStatusId,
        statusType,
        statusCaption,
        statusContent,
        statusUploadedTime,
        statusDuration,
        isViewedStatus,
        textStatusBgColor,
      ];
}
