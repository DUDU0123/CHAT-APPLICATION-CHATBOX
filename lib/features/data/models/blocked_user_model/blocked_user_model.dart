import 'package:official_chatbox_application/features/domain/entities/blocked_user_entity/blocked_user_entity.dart';

class BlockedUserModel extends BlockedUserEntity {
  const BlockedUserModel({
    super.userId,
    super.id,
  });
  factory BlockedUserModel.fromJson({
    required Map<String, dynamic> map,
  }) {
    return BlockedUserModel(
      userId: map['blocked_user_id'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blocked_user_id': userId,
      'id':id,
    };
  }

  BlockedUserModel copyWith({
    String? userId,
    String? id,
  }) {
    return BlockedUserModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
    );
  }
}