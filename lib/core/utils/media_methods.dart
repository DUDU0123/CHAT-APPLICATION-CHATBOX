import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
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

static Stream<List<String>> _getFilesRecursivelyStream(String folderPath) async* {
  final List<String> filePaths = [];
  try {
    final storageRef = firebaseStorage.ref(folderPath);
    final listResult = await storageRef.listAll();

    for (var item in listResult.items) {
      try {
        log("Found file: ${item.fullPath}");
        await item.getDownloadURL();
        filePaths.add(item.fullPath);
        yield [item.fullPath]; 
      } on FirebaseException catch (e) {
        if (e.code == 'object-not-found') {
          log("File does not exist: ${item.fullPath}");
        } else {
          log("Error checking file existence: ${e.message}");
        }
      }
    }

    // Recursively get files from subfolders
    for (var prefix in listResult.prefixes) {
      log("Found subfolder: ${prefix.fullPath}");
      await for (var subfolderPaths in _getFilesRecursivelyStream(prefix.fullPath)) {
        yield subfolderPaths;
      }
    }
  } on FirebaseException catch (e) {
    log("Firebase error: ${e.code} - ${e.message}");
  } catch (e) {
    log("Error fetching files from folder $folderPath: $e");
  }
}


static Stream<List<String>> getAllUserMediaFilesStream(String userID) async* {
    final List<String> allFilePaths = [];
    try {
      log("Fetching media for user ID: $userID");
      final userMediaFolder = '$mediaAttachmentsFolder/$usersMediaFolder/$userID/';
      log("User media folder: $userMediaFolder");

      // Use the recursive stream function to get all files within the user's media folder
      await for (var filePaths in _getFilesRecursivelyStream(userMediaFolder)) {
        allFilePaths.addAll(filePaths);
        yield List<String>.from(allFilePaths); // Emit the accumulated list
      }
    }on FirebaseException catch (e) {
    log("Firebase error: ${e.code} - ${e.message}");
  }
     catch (e) {
      log("Error fetching media: $e");
      yield [];
    }
}

  static MediaType getMediaTypeFromPath(String path) {
    if (path.contains('/photo_files/')) {
      return MediaType.gallery;
    } else if (path.contains('/video_files/')) {
      return MediaType.video;
    } else if (path.contains('/audio_files/')) {
      return MediaType.audio;
    } else if (path.contains('/document_files/')) {
      return MediaType.document;
    } else {
      return MediaType.none;
    }
  }

  static Future<void> deleteMediaFromStorageUsingUrl(
      {required String? downloadUrl}) async {
    try {
      if (downloadUrl!=null) {
        final mediaReference = firebaseStorage.ref().child(downloadUrl);
        await mediaReference.delete();
        log("Successfully deleted media: $downloadUrl");
      } else {
        log("Invalid path: $downloadUrl");
      }
    } catch (e) {
      log("Error deleting media: $e");
    }
  }
}
