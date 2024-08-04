import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/domain/entities/status_entity/uploaded_status_entity.dart';

class UploadedStatusModel extends UploadedStatusEntity {
  const UploadedStatusModel({
    super.statusType,
    super.statusContent,
    super.statusCaption,
    super.statusUploadedTime,
    super.isViewedStatus,
    super.textStatusBgColor,
    super.statusDuration,
    super.uploadedStatusId,
  });
  factory UploadedStatusModel.fromJson(Map<String, dynamic> map) {
    return UploadedStatusModel(
      uploadedStatusId: map[dbUploadedStatusId],
      statusType: map[dbStatusType]!=null?StatusType.values.byName(map[dbStatusType]):null,
      statusCaption: map[dbStatusCaption],
      statusContent: map[dbStatusContent],
      statusUploadedTime: map[dbStatusUploadedTime],
      statusDuration: map[dbStatusDuration],
      isViewedStatus: map[dbisStatusViewed],
      textStatusBgColor: map[dbTextStatusBgColor] != null
          ? Color(int.parse(map[dbTextStatusBgColor]))
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      dbUploadedStatusId: uploadedStatusId,
      dbStatusType: statusType?.name,
      dbStatusCaption: statusCaption,
      dbStatusContent: statusContent,
      dbStatusUploadedTime: statusUploadedTime,
      dbStatusDuration: statusDuration,
      dbisStatusViewed: isViewedStatus,
      // dbTextStatusBgColor: textStatusBgColor,
      dbTextStatusBgColor: textStatusBgColor?.value.toString(),
    };
  }
  UploadedStatusModel copyWith({
    StatusType? statusType,
    String? statusCaption,
    String? statusContent,
    String? statusUploadedTime,
    String? statusDuration,
    bool? isViewedStatus,
    Color? textStatusBgColor,
    String? uploadedStatusId,
  }) {
    return UploadedStatusModel(
      statusType: statusType ?? this.statusType,
      statusCaption: statusCaption ?? this.statusCaption,
      statusContent: statusContent ?? this.statusContent,
      statusUploadedTime: statusUploadedTime ?? this.statusUploadedTime,
      statusDuration: statusDuration ?? this.statusDuration,
      isViewedStatus: isViewedStatus ?? this.isViewedStatus,
      textStatusBgColor: textStatusBgColor ?? this.textStatusBgColor,
      uploadedStatusId: uploadedStatusId ?? this.uploadedStatusId,
    );
  }
}

