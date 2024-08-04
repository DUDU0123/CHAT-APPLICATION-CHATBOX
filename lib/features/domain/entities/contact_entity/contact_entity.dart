import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  String? chatBoxUserId;
  String? userContactName;
  String? userAbout;
  String? userProfilePhotoOnChatBox;
  String? userContactNumber;
  bool? isChatBoxUser;
  ContactEntity({
    this.chatBoxUserId,
    this.userContactName,
    this.userAbout,
    this.userProfilePhotoOnChatBox,
    this.userContactNumber,
    this.isChatBoxUser,
  });

  @override
  List<Object?> get props => [
    chatBoxUserId,
        userContactName,
        userAbout,
        userProfilePhotoOnChatBox,
        userContactNumber,
        isChatBoxUser,
      ];
}
