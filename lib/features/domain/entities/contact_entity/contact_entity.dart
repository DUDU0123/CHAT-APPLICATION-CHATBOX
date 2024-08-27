import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String? chatBoxUserId;
  final String? contactId;
  final String? userContactName;
  final String? userAbout;
  final String? userProfilePhotoOnChatBox;
  final String? userContactNumber;
  final bool? isChatBoxUser;
  const ContactEntity({
    this.chatBoxUserId,
    this.userContactName,
    this.userAbout,
    this.userProfilePhotoOnChatBox,
    this.userContactNumber,
    this.isChatBoxUser,
    this.contactId,
  });

  @override
  List<Object?> get props => [
    chatBoxUserId,
        userContactName,
        userAbout,
        userProfilePhotoOnChatBox,
        userContactNumber,
        isChatBoxUser,contactId,
      ];
}
