import 'package:equatable/equatable.dart';

class BlockedUserEntity extends Equatable {
  final String? id;
  final String? userId;
  const BlockedUserEntity({
    this.id,
    this.userId,
  });

  @override
  List<Object?> get props => [userId, id,];
}
