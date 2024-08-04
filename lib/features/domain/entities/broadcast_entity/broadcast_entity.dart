import 'package:equatable/equatable.dart';

class BroadCastEntity extends Equatable {
  final String? broadCastId;
  final String? broadCastAdminId;
  final String? broadCastProfilePhoto;
  final String? broadCastName;
  final List<String>? broadCastMembersId;
  const BroadCastEntity({
    this.broadCastId,
    this.broadCastAdminId,
    this.broadCastProfilePhoto,
    this.broadCastName,
    this.broadCastMembersId,
  });

  @override
  List<Object?> get props {
    return [
      broadCastId,
      broadCastAdminId,
      broadCastProfilePhoto,
      broadCastName,
      broadCastMembersId,
    ];
  }
}


