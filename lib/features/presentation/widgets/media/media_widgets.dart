import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/chat_asset_send_methods.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/media_show_page.dart/photo_video_show_page.dart';

Widget mediaContainerCommon({
  required Widget childWidget,
  void Function()? onTap,
  double? height,
  double? width,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: kBlack,
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: childWidget,
    ),
  );
}

Widget buildMediaItem(String filePath, MediaType mediaType) {
  return FutureBuilder<String>(
    future: firebaseStorage.ref(filePath).getDownloadURL(),
    builder: (context, snapshot) {
      log(name: "Error medias", snapshot.error.toString());
      final downloadUrl = snapshot.data;
      if (downloadUrl == null ||
          snapshot.error ==
              '[firebase_storage/object-not-found] No object exists at the desired reference.') {
        return zeroMeasureWidget;
      }
      switch (mediaType) {
        case MediaType.gallery:
          return mediaContainerCommon(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoVideoShowPage(
                    fileType: FileType.image,
                    fileToShowUrl: downloadUrl,
                  ),
                ),
              );
            },
            childWidget: ClipRRect(
              borderRadius: BorderRadius.circular(10.sp),
              child: Image.network(
                downloadUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        case MediaType.video:
          return mediaContainerCommon(
            // height: 100,width: 100,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoVideoShowPage(
                    fileType: FileType.video,
                    fileToShowUrl: downloadUrl,
                  ),
                ),
              );
            },
            childWidget: snapshot.data != null
                ? Icon(
                    Icons.play_arrow_rounded,
                    color: darkLinearGradientColorOne,
                    size: 50.sp,
                  )
                // Image.file(File(snapshot.data!))
                : Icon(
                    Icons.error,
                    color: iconGreyColor,
                  ),
          );
        case MediaType.audio:
          AudioPlayer audioPlayer = AudioPlayer();
          return mediaContainerCommon(
            onTap: () async {
              await audioPlayer.setUrl(downloadUrl);
              if (audioPlayer.playing) {
                await audioPlayer.pause();
              } else {
                await audioPlayer.play();
              }
            },
            childWidget: Center(
              child: Icon(
                Icons.headphones,
                color: darkLinearGradientColorOne,
                size: 50.sp,
              ),
            ),
          );
        case MediaType.document:
          return mediaContainerCommon(
              onTap: () {
                openDocument(url: downloadUrl);
              },
              childWidget: Center(
                child: SvgPicture.asset(
                  colorFilter: ColorFilter.mode(
                    darkLinearGradientColorOne,
                    BlendMode.srcIn,
                  ),
                  document,
                  width: 50.w,
                  height: 50.h,
                ),
              ));
        default:
          return Container(color: kBlack);
      }
    },
  );
}
