import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String? docId;
  final String? reportedUserId;
 const ReportEntity({
    this.docId,
    this.reportedUserId,
  });

  @override
  List<Object?> get props => [docId, reportedUserId];
}
