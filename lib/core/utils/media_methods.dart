import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';

class MediaMethods{
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

 static Future<List<String>> getChatMediaFiles({required MediaType mediaType, required ChatModel? chatModel,}) {
    final pathToChatMediaFolderInStorageDB =
        '$mediaAttachmentsFolder/$chatsMediaFolder/${chatModel?.chatID}';
    final mediaFolderPath =
        getFolderPath(pathToChatMediaFolderInStorageDB, mediaType);
    return getMediaFiles(mediaFolderPath);
  }

 static Future<List<String>> getGroupMedias({required MediaType mediaType, required GroupModel? groupModel,}) {
    final pathToGroupMediaFolderInStorageDB =
        '$mediaAttachmentsFolder/$groupsMediaFolder/${groupModel?.groupID}';
    final mediaFolderPath =
        getFolderPath(pathToGroupMediaFolderInStorageDB, mediaType);
    return getMediaFiles(mediaFolderPath);
  }
}