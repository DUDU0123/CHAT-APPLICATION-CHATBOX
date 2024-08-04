const userDbId = 'id';
const userDbName = 'username';
const userDbEmail = 'user_email';
const userDbPhoneNumber = 'phone_number';
const userDbAbout ='user_about';
const userDbProfileImage = 'user_profile_image';
const userDbNetworkStatus = 'user_network_status';
const userDbCreatedAt = 'created_at';
const userDbTFAPin = 'tfa_pin';
const userDbBlockedStatus = 'is_blocked_user';
const userDbGroupIdList = 'user_group_id_list';
const isUserDisabled = 'is_disabled_user';
const userDbLastActiveTime = 'user_last_active_time';
const userDbContactName = 'user_db_contact_name';

// collections names
const usersCollection = 'users';
const contactsCollection = 'chat_box_contact';
const chatsCollection = 'chats';
const groupsCollection = 'groups';
const messagesCollection = 'messages';
const statusCollection = 'statuses';
const attachmentsCollection = 'attachments';
const starredMessagesCollection = 'starred_collection';



// messageDb fields name
const dbMessageID = 'message_id';
const dbMessageSenderID = 'message_sender_id';
const dbMessageRecieverID = 'message_reciever_id';
const dbMessageContent = 'message_content';
const dbMessageSendTime = 'message_send_time';
const dbMessageStatus = 'message_status';
const dbMessageType = 'message_type';
const dbAttachmentsWithMessage = 'message_attachments';
const dbIsMessageEdited = 'edited_message';
const dbIsMessageDeleted = 'deleted_message';
const dbIsMessagePinned = 'pinned_message';
const dbIsMessageStarred = 'starred_message';
const nameOfMessage = 'message_name';
const dbReplyToMessage = 'reply_to_message';

// chat db fields name
const chatId = 'chat_id';
const senderId = 'sender_id';
const receiverId = 'receiver_id';
const chatLastMessage = 'last_message';
const chatLastMessageTime = 'last_message_time';
const chatMessageNotificationCount = 'not_seen_message_Count';
const receiverProfilePhoto = 'receiver_profile_image';
const chatMuted = 'is_muted_chat';
const lastChatStatus = 'last_message_status';
const lastChatType = 'last_message_type';
const isIncoming = 'is_incoming';
const receiverNameInChatList = 'receiver_name';
const isUserChatOpen = 'isChatOpen';
const isGroupChat = 'is_group';
const dbchatWallpaper = 'chat_wallpaper';


// group db fields name
const dbGroupId = 'group_id';
const dbGroupName = 'group_name';
const dbGroupDescription = 'group_description';
const dbGroupProfileImage = 'group_profile_image';
const dbGroupAdminsList = 'group_admins';
const dbGroupMembersList = 'group_members';
const dbGroupAdminsPermissionList = 'group_admins_permissions';
const dbGroupMembersPermissionList = 'group_members_permissions';
const dbGroupCreatedAt = 'group_created_at';
const dbGroupLastUpdatedDate = 'group_last_updated_date';
const dbIsGroupMuted = 'is_muted_group';
const dbGroupLastMessage = 'group_last_message';
const dbGroupLastMessenger = 'group_last_messenger';
const dbGroupLastMessageTime = 'group_last_message_time';
const dbGroupLastMessageType = 'group_last_message_type';
const dbGroupLastMessageStatus = 'group_last_message_status';
const dbGroupNotificationCount = 'group_notification_count';
const dbGroupIsIncomingMessage = 'is_incoming_group_message';
const dbIsGroupOpen = 'is_group_open';
const dbGroupCreatedBy = 'group_created_by';
const dbGroupWallpaper = 'group_wallpaper';


// status db field name
const dbStatusId = 'status_id';
const dbUploadedStatusId = 'uploaded_status_id';
const dbStatusUploaderName = 'status_uploader_name';
const dbStatusUploaderId = 'status_uploader_id';
const dbStatusContentList = 'status_content_list';
const dbStatusType = 'statusType';
const dbStatusCaption = 'statusCaption';
const dbStatusContent = 'status_content';
const dbStatusUploadedTime = 'status_uploaded_time';
const dbStatusDuration = 'status_duration';
const dbisStatusViewed= 'is_viewed';
const dbStatusModelTimeStamp = 'timestamp';
const dbTextStatusBgColor = 'text_status_bg_color';


// contacts db field name
const dbChatBoxUserId = 'chatBoxUserId';
const dbUserContactName = 'userContactName';
const dbUserAbout = 'userAbout';
const dbUserProfilePhotoOnChatBox = 'userProfilePhotoOnChatBox';
const dbUserContactNumber = 'userContactNumber';
const dbIsChatBoxUser = 'isChatBoxUser';

// broadcast db field name
const broadcastId = 'broadcast_id';
const broadcastAdminId = 'broadcast_admin_id';
const broadcastName = 'broadcast_name';
const broadcastProfilePhoto = 'broadcast_profile_photo';
const broadcastMembersId = 'broadcast_members_id';

// database storage folder name or file name
const usersProfileImageFolder = "profile_images/";
const chatAssetFolder = "chatsAsset/";