import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';

class AttachmentModel extends Equatable {
  final Color colorOne;
  final Color colorTwo;
  final String icon;
  final MediaType mediaType;
  const AttachmentModel({
    required this.colorOne,
    required this.colorTwo,
    required this.icon,
    required this.mediaType,
  });

  @override
  List<Object> get props => [colorOne, colorTwo, icon];
}


class SettingsHomeButtonModel extends Equatable {
  final String title;
  final String subtitle;
  final String icon;
  final PageTypeEnum pageType;
  const SettingsHomeButtonModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.pageType,
  });

  @override
  List<Object> get props => [title, subtitle, icon, pageType];
}

class AuthOtpModel {
  final String phoneNumber;
  final int? forceResendingToken;
  final String verifyId;
  AuthOtpModel({
    required this.phoneNumber,
    this.forceResendingToken,
    required this.verifyId,
  });
  
}

List<SettingsHomeButtonModel> settingsButtonsList = const [
  SettingsHomeButtonModel(title: "Account", subtitle: "Delete account", icon: keyIcon, pageType: PageTypeEnum.accountSetting),
  SettingsHomeButtonModel(title: "Privacy", subtitle: "Profile photo", icon: privacyIcon, pageType: PageTypeEnum.privacySetting),
  SettingsHomeButtonModel(title: "Chats", subtitle: "Theme, wallpaper", icon: chatsIcon, pageType: PageTypeEnum.chatSetting),
  SettingsHomeButtonModel(title: "Notifications", subtitle: "Message, call tones", icon: notificationIcon, pageType: PageTypeEnum.notificationsSetting),
  SettingsHomeButtonModel(title: "Storage", subtitle: "Manage storage", icon: storageIcon,pageType: PageTypeEnum.storageSetting),
  SettingsHomeButtonModel(title: "Help", subtitle: "Help center, contact us", icon: helpIcon,pageType: PageTypeEnum.helpSetting),
  SettingsHomeButtonModel(title: "Invite a friend", subtitle: "", icon: inviteIcon,pageType: PageTypeEnum.inviteButton),
];

List<AttachmentModel> attachmentIcons = [
  AttachmentModel(
    colorOne: documentColorOne,
    colorTwo: documentColorTwo,
    icon: document,
    mediaType: MediaType.document,
  ),
  AttachmentModel(
    colorOne: cameraColorOne,
    colorTwo: cameraColorTwo,
    icon: cameraIcon,
    mediaType: MediaType.camera,
  ),
  AttachmentModel(
    colorOne: galleryColorOne,
    colorTwo: galleryColorTwo,
    icon: gallery,
    mediaType: MediaType.gallery,
  ),
  AttachmentModel(
    colorOne: audioColorOne,
    colorTwo: audioColorTwo,
    icon: headphone,
    mediaType: MediaType.audio,
  ),
  AttachmentModel(
    colorOne: locationColorOne,
    colorTwo: locationColorTwo,
    icon: location,
    mediaType: MediaType.location,
  ),
  AttachmentModel(
    colorOne: contactColorOne,
    colorTwo: contactColorTwo,
    icon: contact,
    mediaType: MediaType.contact,
  ),
];

const String apiKey = 'AIzaSyBXUYyQW_q_meUJlB0xl31Cf7kJRdDeO1Q';