import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
initRecorder({required FlutterSoundRecorder recorder,}) async {
   final permissionStatus = await Permission.microphone.request();
   if (permissionStatus!=PermissionStatus.granted) {
     throw 'Microphone Permission not granted';
   }
   await recorder.openRecorder();
  }
Future<void> addToContact({
  required String contactNumber,
}) async {
  if (await canLaunchUrl(Uri.parse('tel:$contactNumber'))) {
    await launchUrl(Uri.parse('tel:$contactNumber'));
  } else {
    log('Could not launch');
  }
}

Future<void> openDocument({
  required String url,
}) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    log('Could not launch');
  }
}

Future<File?> pickOneFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File? file;
    if (result != null) {
      file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  } catch (e) {
    log("File picker exception");
    throw Exception(e);
  }
}

Future<List<File?>> pickMultipleFileWithAnyExtension() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    List<File?> files;
    if (result != null) {
      PlatformFile file = result.files.first;
      log(file.extension.toString());
      files = result.paths.map((path) => File(path!)).toList();
      return files;
    } else {
      return [null];
    }
  } catch (e) {
    log("File picker exception");
    throw Exception(e);
  }
}
// Extracting file extension
          // String fileExtension = path.extension(file.path);
          // Append file extension to fileUrl based on the file type
          // if (fileExtension == '.pdf') {
          //   fileUrl += '?type=pdf';
          // } else if (fileExtension == '.docx') {
          //   fileUrl += '?type=docx';
          // } else if (fileExtension == '.xlsx') {
          //   fileUrl += '?type=xlsx';
          // }