import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';

import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/media_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/storage_methods.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/media/media_widgets.dart';

MediaType getMediaTypeFromPath(String path) {
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

class StorageSettings extends StatefulWidget {
  const StorageSettings({super.key});

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  int? appStorageUsage;

  @override
  void initState() {
    super.initState();
    _fetchStorageUsage();
  }

  void _fetchStorageUsage() async {
    int usage = await StorageMethods.calculateAppStorageUsage();
    setState(() {
      appStorageUsage = usage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final storageUsed = appStorageUsage != null
        ? (appStorageUsage! ~/ (1024 * 1024)).toString()
        : '';
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Manage storage"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dataLevelTextShowWidget(
                      data: storageUsed,
                      isUsed: true,
                    ),
                    dataLevelTextShowWidget(
                      data: "1.8",
                      isUsed: false,
                    ),
                  ],
                ),
                kHeight10,
                Container(
                  width: screenWidth(context: context),
                  height: 15.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.sp),
                    color: buttonSmallTextColor,
                  ),
                ),
                kHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 10.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                          color: buttonSmallTextColor, shape: BoxShape.circle),
                    ),
                    kWidth10,
                    TextWidgetCommon(
                      text: "ChatBox ($storageUsed MB)",
                      textColor: iconGreyColor,
                    )
                  ],
                ),
                kHeight20,
                TextWidgetCommon(
                  text: "MEDIA",
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
                future: firebaseAuth.currentUser != null
                    ? MediaMethods.getAllUserMediaFiles(
                        firebaseAuth.currentUser!.uid)
                    : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return commonAnimationWidget(
                      context: context,
                      isTextNeeded: false,
                    );
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return emptyShowWidget(
                        context: context, text: 'No media files found');
                  }
                  final snapData = snapshot.data;
                  return GridView.builder(
                    itemCount: snapData?.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      final downloadUrl = snapData![index];
                      log(downloadUrl);
                      final mediaType = getMediaTypeFromPath(downloadUrl);
                      return buildMediaItem(
                        downloadUrl,
                        mediaType,
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget dataLevelTextShowWidget({
    required String data,
    required bool isUsed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          //color: buttonSmallTextColor,
          child: Stack(
            children: [
              TextWidgetCommon(
                text: data,
                fontWeight: FontWeight.w500,
                fontSize: 35.sp,
              ),
              Positioned(
                right: 0,
                bottom: 5.h,
                child: TextWidgetCommon(
                  text: "MB",
                  fontWeight: FontWeight.normal,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
        TextWidgetCommon(
          text: isUsed ? "Used" : "Free",
          textColor: iconGreyColor,
        ),
      ],
    );
  }
}
