import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/theme/theme_manager.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:provider/provider.dart';

Widget chatRoomBackgroundImageWidget({
  required BuildContext context,
  ChatModel? chatModel,
  GroupModel? groupModel,
}) {
  return SizedBox(
    width: screenWidth(context: context),
    height: screenHeight(context: context),
    child: StreamBuilder<String?>(
      stream: getWallpaperStream(chatModel: chatModel, groupModel: groupModel),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return defaultWallpaper(context: context);
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Image.network(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        } else {
          return defaultWallpaper(context: context);
        }
      },
    ),
  );
}

Widget defaultWallpaper({
  required BuildContext context,
}) {
  return Image.asset(
    fit: BoxFit.cover,
    Provider.of<ThemeManager>(context).isDark ? bgImage : bgImage,
  );
}

Stream<String?> getWallpaperStream({
  ChatModel? chatModel,
  GroupModel? groupModel,
}) {
  if (chatModel != null) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(firebaseAuth.currentUser?.uid)
        .collection(chatsCollection)
        .doc(chatModel.chatID)
        .snapshots()
        .map((snapshot) => snapshot.data()?[dbchatWallpaper] as String?);
  } else if (groupModel != null) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(firebaseAuth.currentUser?.uid)
        .collection(groupsCollection)
        .doc(groupModel.groupID)
        .snapshots()
        .map((snapshot) => snapshot.data()?[dbGroupWallpaper] as String?);
  } else {
    return Stream.value(null);
  }
}