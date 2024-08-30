import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/media_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/media/media_widgets.dart';

class MediaShowPage extends StatelessWidget {
  const MediaShowPage({
    super.key,
    required this.pageTypeEnum,
    this.chatModel,
    this.groupModel,
  });
  final PageTypeEnum pageTypeEnum;
  final ChatModel? chatModel;
  final GroupModel? groupModel;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: TextWidgetCommon(
            text: pageTypeEnum == PageTypeEnum.groupMessageInsidePage
                ? "Group media"
                : "Media Files",
          ),
          bottom: TabBar(
            labelColor: buttonSmallTextColor,
            dividerColor: kTransparent,
            indicatorColor: buttonSmallTextColor,
            unselectedLabelColor: iconGreyColor,
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(
                text: "Photos",
              ),
              Tab(text: "Videos"),
              Tab(
                text: "Audios",
              ),
              Tab(
                text: "Docs",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildMediaGrid(
              mediaType: MediaType.gallery,
              pageTypeEnum: pageTypeEnum,
            ),
            buildMediaGrid(
              mediaType: MediaType.video,
              pageTypeEnum: pageTypeEnum,
            ),
            buildMediaGrid(
              mediaType: MediaType.audio,
              pageTypeEnum: pageTypeEnum,
            ),
            buildMediaGrid(
              mediaType: MediaType.document,
              pageTypeEnum: pageTypeEnum,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMediaGrid({
    required MediaType mediaType,
    required PageTypeEnum pageTypeEnum,
  }) {

    final currentUserId = firebaseAuth.currentUser?.uid;
    return FutureBuilder<List<String>>(
      future: pageTypeEnum == PageTypeEnum.groupMessageInsidePage
          ? MediaMethods.getGroupMedias(
            currentUserId: currentUserId,
              mediaType: mediaType,
              groupModel: groupModel,
            )
          : MediaMethods.getChatMediaFiles(
              mediaType: mediaType,
              currentUserId: currentUserId,
              chatModel: chatModel,
            ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return commonAnimationWidget(
            context: context,
            isTextNeeded: false,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return emptyShowWidget(
              context: context, text: 'No media files found');
        }
        final mediaFiles = snapshot.data!;
        return GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          itemCount: mediaFiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6.w,
            mainAxisSpacing: 6.h,
          ),
          itemBuilder: (context, index) {
            final filePath = mediaFiles[index];
            return buildMediaItem(filePath, mediaType);
          },
        );
      },
    );
  }
}
