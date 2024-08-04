import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/domain/entities/broadcast_entity/broadcast_entity.dart';

class BroadCastModel extends BroadCastEntity {
  const BroadCastModel({
    super.broadCastId,
    super.broadCastAdminId,
    super.broadCastMembersId,
    super.broadCastName,
    super.broadCastProfilePhoto,
  });

  factory BroadCastModel.fromJson(Map<String, dynamic> map) {
    return BroadCastModel(
      broadCastAdminId: map[broadcastAdminId],
      broadCastId: map[broadcastId],
      broadCastMembersId: List<String>.from(map[broadcastMembersId] ?? []),
      broadCastName: map[broadcastName],
      broadCastProfilePhoto: map[broadcastProfilePhoto],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      broadcastId: broadCastId,
      broadcastAdminId: broadCastAdminId,
      broadcastName: broadCastName,
      broadcastProfilePhoto: broadCastProfilePhoto,
      broadcastMembersId: broadCastMembersId,
    };
  }

  BroadCastModel copyWith({
    String? broadCastId,
    String? broadCastAdminId,
    String? broadCastProfilePhoto,
    String? broadCastName,
    List<String>? broadCastMembersId,
  }) {
    return BroadCastModel(
      broadCastId: broadCastId ?? this.broadCastId,
      broadCastAdminId: broadCastAdminId ?? this.broadCastAdminId,
      broadCastMembersId: broadCastMembersId ?? this.broadCastMembersId,
      broadCastName: broadCastName ?? this.broadCastName,
      broadCastProfilePhoto:
          broadCastProfilePhoto ?? this.broadCastProfilePhoto,
    );
  }
}