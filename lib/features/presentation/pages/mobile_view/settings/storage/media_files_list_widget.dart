import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/utils/media_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/media/media_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/media/media_widgets.dart';

BlocBuilder<MediaBloc, MediaState> mediaFilesListWidget() {
  return BlocBuilder<MediaBloc, MediaState>(
    builder: (context, state) {
      return StreamBuilder<List<String>>(
          stream: firebaseAuth.currentUser != null ? state.allMediaFiles : null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return commonAnimationWidget(
                context: context,
                isTextNeeded: false,
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return emptyShowWidget(
                  context: context, text: "No media files found");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return emptyShowWidget(
                  context: context, text: 'No media files found');
            }
            final snapData = snapshot.data ?? [];

            if (snapData.isEmpty) {
              return emptyShowWidget(
                  context: context, text: 'No media files found');
            }
            return StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return GridView.builder(
                  itemCount: snapData.length,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final downloadUrl = snapData[index];
                    final mediaType =
                        MediaMethods.getMediaTypeFromPath(downloadUrl);
                    return GestureDetector(
                      onLongPress: () {
                        context
                            .read<MediaBloc>()
                            .add(MediaSelectEvent(downloadUrl));
                        log("Long pressed");
                      },
                      child: BlocBuilder<MediaBloc, MediaState>(
                        builder: (context, state) {
                          log("FIle is: $downloadUrl");
                          final isSelected =
                              state.selectedMediaUrls?.contains(downloadUrl) ??
                                  false;
                          return Stack(
                            children: [
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: buildMediaItem(
                                  downloadUrl,
                                  mediaType,
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_box,
                                  color: buttonSmallTextColor,
                                ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              }
            );
          });
    },
  );
}


