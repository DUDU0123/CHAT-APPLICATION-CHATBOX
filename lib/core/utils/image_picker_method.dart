import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';

File? xFileToFileConverter({required XFile? xfile}) {
  if (xfile == null) {
    return null;
  }
  File? file = File(xfile.path);
  return file;
}

Future<File?> selectAsset({
  required ImageSource imageSource,
  required AssetSelected? assetSelected,
}) async {
  switch (assetSelected) {
    case AssetSelected.photo:
      return pickImage(imageSource: imageSource);
    case AssetSelected.video:
      return takeVideoAsset(imageSource: imageSource);
    default:
      return null;
  }
}

Future<File?> pickAsset({
  required StatusType? assetSelected,
}) async {
  switch (assetSelected) {
    case StatusType.image:
    log("Image selecting");
      return pickImage(imageSource: ImageSource.gallery);
    case StatusType.video:
     log("Video selecting");
      return takeVideoAsset(imageSource: ImageSource.gallery);
    default:
      return null;
  }
}

Future<File?> pickImage({required ImageSource imageSource}) async {
  try {
    File? file;
    XFile? pickedXFile = await ImagePicker().pickImage(source: imageSource);

    file = xFileToFileConverter(xfile: pickedXFile);
    if (file != null) {
      return file;
    } else {
      return null;
    }
  } catch (e) {
    throw Exception(e);
  }
}


Future<File?> takeVideoAsset({required ImageSource imageSource}) async {
  try {
    File? file;
    XFile? videoFromCameraXfile =
        await ImagePicker().pickVideo(source: imageSource);
    file = xFileToFileConverter(xfile: videoFromCameraXfile);
    if (file != null) {
      return file;
    } else {
      return null;
    }
  } catch (e) {
    log("takeVideo error");
    throw Exception(e);
  }
}