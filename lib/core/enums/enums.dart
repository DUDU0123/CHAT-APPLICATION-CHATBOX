enum PageTypeEnum {
  chatHome,
  chatStatus,
  chatGroup,
  chatCalls,
  settingsPage,
  oneToOneChatInsidePage,
  settingEditProfilePage,
  accountSetting,
  privacySetting,
  chatSetting,
  notificationsSetting,
  storageSetting,
  helpSetting,
  inviteButton,
  messagingPage,
  sendContactSelectPage,
  groupMemberSelectPage,
  groupMessageInsidePage,
  groupSettingsPage,
  broadcastMembersSelectPage,
  broadCastSettingsPage,
  broadCastMessageInsidePage,
  groupDetailsAddPage,
  groupInfoPage,
  fromStatusPage,
  toSendPage,
  none,
}
enum For{
  all,notAll,
}
enum FieldTypeSettings {
  name,
  about,
}

enum MessageStatus {
  sent,
  delivered,
  read,
  none,
}

enum MessageType {
  text,
  photo,
  audio,
  video,
  document,
  location,
  contact,
  none,
}

enum MediaType {
  document,
  camera,
  gallery,
  audio,
  location,
  contact,
  none,
}

enum AssetSelected {
  video,
  photo,
}
enum MembersGroupPermission {
  editGroupSettings,
  sendMessages,
  addMembers,
}

enum AdminsGroupPermission {
  viewMembers,
  approveMembers,
  editGroupSettings,
  sendMessages,
  addMembers,
}
enum StatusType {
  video,
  image,
  text,none
}
