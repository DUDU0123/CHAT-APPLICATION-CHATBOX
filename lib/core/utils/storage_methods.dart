import 'dart:io';
import 'package:path_provider/path_provider.dart';
class StorageMethods{
 static Future<int> calculateDirectorySize(Directory directory) async {
  int totalSize = 0;
  try {
    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync(recursive: true, followLinks: false);
      for (FileSystemEntity file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }
    }
  } catch (e) {
    print("Error calculating directory size: $e");
  }
  return totalSize;
}
static Future<int> calculateAppStorageUsage() async {
  int totalSize = 0;

  // Get the directory for the app's documents
  Directory appDocDir = await getApplicationDocumentsDirectory();
  totalSize += await calculateDirectorySize(appDocDir);

  // Get the directory for the app's cache
  Directory appCacheDir = await getTemporaryDirectory();
  totalSize += await calculateDirectorySize(appCacheDir);

  return totalSize;
}
}