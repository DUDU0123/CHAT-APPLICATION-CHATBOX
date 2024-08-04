import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/domain/entities/contact_entity/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({
    super.chatBoxUserId,
    super.userContactName,
    super.userAbout,
    super.userProfilePhotoOnChatBox,
    super.userContactNumber,
    super.isChatBoxUser,
  });

  factory ContactModel.fromJson(Contact contact){
    return ContactModel(
      userContactName: contact.displayName??'',
      userContactNumber: contact.phones.isNotEmpty? contact.phones.first.number:null,
      isChatBoxUser: false,
    );
  }

  factory ContactModel.fromjson(Map<String, dynamic> json) {
    return ContactModel(
      chatBoxUserId: json[dbChatBoxUserId] as String?,
      userContactName: json[dbUserContactName] as String?,
      userAbout: json[dbUserAbout] as String?,
      userProfilePhotoOnChatBox: json[dbUserProfilePhotoOnChatBox] as String?,
      userContactNumber: json[dbUserContactNumber] as String?,
      isChatBoxUser: json[dbIsChatBoxUser] as bool?,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      dbChatBoxUserId: chatBoxUserId,
      dbUserContactName: userContactName,
      dbUserAbout: userAbout,
      dbUserProfilePhotoOnChatBox: userProfilePhotoOnChatBox,
      dbUserContactNumber: userContactNumber,
      dbIsChatBoxUser: isChatBoxUser,
    };
  }
}
