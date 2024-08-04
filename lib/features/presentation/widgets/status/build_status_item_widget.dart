import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

List<StoryItem?> buildStatusItems({
  required StoryController controller,
  required StatusModel statusModel,
  required BuildContext context,
}) {
  return statusModel.statusList != null
      ? statusModel.statusList!
          .map((status) {
            Duration videoDuration;
            try {
              videoDuration = TimeProvider.parseDuration(status.statusDuration ?? '0:00:30');
            } catch (e) {
              videoDuration = const Duration(seconds: 30); // Default to 30 seconds if parsing fails
            }
            switch (status.statusType) {
              case StatusType.video:
                return StoryItem.pageVideo(
                  status.statusContent ?? "",
                  controller: controller,
                  caption: TextWidgetCommon(
                    text: status.statusCaption ?? '',
                    textAlign: TextAlign.center,
                    textColor: kWhite,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.sp,
                  ),
                  duration: videoDuration > const Duration(seconds: 30)
                      ? const Duration(seconds: 30)
                      : videoDuration,
                );
              case StatusType.image:
                return StoryItem.pageImage(
                  url: status.statusContent ?? '',
                  controller: controller,
                  imageFit: BoxFit.contain,
                  caption: Text(
                    status.statusCaption ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  duration: const Duration(seconds: 10),
                );
              case StatusType.text:
              log("${status.statusContent}");
                return StoryItem.text(
                  title: status.statusContent ?? '',
                  backgroundColor: status.textStatusBgColor ?? kBlack,
                  duration: const Duration(seconds: 10),
                );
              default:
                return null;
            }
          })
          .where((item) => item != null)
          .toList()
      : [];
}