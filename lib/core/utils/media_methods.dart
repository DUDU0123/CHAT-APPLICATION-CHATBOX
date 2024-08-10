import 'dart:developer';

import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';

class MediaMethods {
  static Future<List<String>> getMediaFiles(String folderPath) async {
    try {
      final storageRef = firebaseStorage.ref(folderPath);
      final listResult = await storageRef.listAll();
      final filePaths = listResult.items.map((item) => item.fullPath).toList();
      return filePaths;
    } catch (e) {
      return [];
    }
  }

  static String getFolderPath(String basePath, MediaType mediaType) {
    switch (mediaType) {
      case MediaType.gallery:
        return '$basePath/$photoFolder';
      case MediaType.video:
        return '$basePath/$videoFolder';
      case MediaType.audio:
        return '$basePath/$audioFolder';
      case MediaType.document:
        return '$basePath/$docsFolder';
      default:
        return basePath;
    }
  }

  static Future<List<String>> getChatMediaFiles({
    required MediaType mediaType,
    required ChatModel? chatModel,
    required String? currentUserId,
  }) {
    final pathToChatMediaFolderInStorageDB =
        '$mediaAttachmentsFolder/$usersMediaFolder/${firebaseAuth.currentUser?.uid}/$chatsMediaFolder/${chatModel?.chatID}';
    final mediaFolderPath =
        getFolderPath(pathToChatMediaFolderInStorageDB, mediaType);
    log(mediaFolderPath);
    return getMediaFiles(mediaFolderPath);
  }

  //
  static Future<List<String>> getGroupMedias({
    required MediaType mediaType,
    required GroupModel? groupModel,
    required String? currentUserId,
  }) {
    final pathToGroupMediaFolderInStorageDB =
        '$mediaAttachmentsFolder/$usersMediaFolder/${firebaseAuth.currentUser?.uid}/$groupsMediaFolder/${groupModel?.groupID}';
    final mediaFolderPath =
        getFolderPath(pathToGroupMediaFolderInStorageDB, mediaType);
    return getMediaFiles(mediaFolderPath);
  }

//   static Future<List<String>> getAllUserMediaFiles(String userID) async {
//   try {
//     log("Fetching media for user ID: $userID");
//     final userMediaFolder = '$mediaAttachmentsFolder/$usersMediaFolder/$userID/';
//     log("User media folder: $userMediaFolder");
//     final storageRef = firebaseStorage.ref(userMediaFolder);
//     final listResult = await storageRef.listAll();
//     log("Items found: ${listResult.items.length}, Folders found: ${listResult.prefixes.length}");

//     final List<String> filePaths = [];

//     for (var item in listResult.items) {
//       log("Found item: ${item.fullPath}");
//       filePaths.add(item.fullPath);
//     }

//     for (var prefix in listResult.prefixes) {
//       log("Found folder: ${prefix.fullPath}");
//       final subfolderPaths = await getMediaFiles(prefix.fullPath);
//       log("Subfolder files: $subfolderPaths");
//       filePaths.addAll(subfolderPaths);
//     }

//     log("Total media files found: ${filePaths.length}");
//     return filePaths;
//   } catch (e) {
//     log("Error fetching media: $e");
//     return [];
//   }
// }
static Future<List<String>> _getFilesRecursively(String folderPath) async {
  final List<String> filePaths = [];
  try {
    final storageRef = firebaseStorage.ref(folderPath);
    final listResult = await storageRef.listAll();

    // Add files in the current folder to the list
    for (var item in listResult.items) {
      log("Found file: ${item.fullPath}");
      filePaths.add(item.fullPath);
    }

    // Recursively get files from subfolders
    for (var prefix in listResult.prefixes) {
      log("Found subfolder: ${prefix.fullPath}");
      final subfolderPaths = await _getFilesRecursively(prefix.fullPath);
      filePaths.addAll(subfolderPaths);
    }
  } catch (e) {
    log("Error fetching files from folder $folderPath: $e");
  }
  return filePaths;
}

static Future<List<String>> getAllUserMediaFiles(String userID) async {
  try {
    log("Fetching media for user ID: $userID");
    final userMediaFolder = '$mediaAttachmentsFolder/$usersMediaFolder/$userID/';
    log("User media folder: $userMediaFolder");

    // Use the recursive function to get all files within the user's media folder
    final filePaths = await _getFilesRecursively(userMediaFolder);

    log("Total media files found: ${filePaths.length}");
    return filePaths;
  } catch (e) {
    log("Error fetching media: $e");
    return [];
  }
}

}
