import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/media_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/media/media_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/storage/media_files_list_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:provider/provider.dart';

class StorageSettings extends StatefulWidget {
  const StorageSettings({super.key});

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  // Stream<List<String>>? _mediaFilesStream;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchMediaFilesAsStream();
  // }

  // void fetchMediaFilesAsStream() {
  //   if (firebaseAuth.currentUser != null) {
  //     _mediaFilesStream = MediaMethods.getAllUserMediaFilesStream(
  //       firebaseAuth.currentUser!.uid,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
                      data: Provider.of<CommonProvider>(context).appStorage,
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
                        color: buttonSmallTextColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    kWidth10,
                    TextWidgetCommon(
                      text:
                          "ChatBox (${Provider.of<CommonProvider>(context).appStorage} MB)",
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
            child: mediaFilesListWidget(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Provider.of<MediaBloc>(context, listen: true)
                  .state
                  .selectedMediaUrls !=
              null
          ? Provider.of<MediaBloc>(context, listen: true)
                  .state
                  .selectedMediaUrls!
                  .isNotEmpty
              ? FloatingActionButton(
                  backgroundColor: darkLinearGradientColorTwo,
                  isExtended: true,
                  onPressed: () {
                    final Set<String>? selectedUrls =
                        Provider.of<MediaBloc>(context, listen: false)
                            .state
                            .selectedMediaUrls;
                    if (selectedUrls != null) {
                      context.read<MediaBloc>().add(
                            MediaDeleteEvent(
                              selectedMedias: selectedUrls,
                            ),
                          );
                      Provider.of<MediaBloc>(context, listen: false)
                          .add(GetAllMediaFiles());
                    }
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: kRed,
                    size: 30.sp,
                  ),
                )
              : zeroMeasureWidget
          : zeroMeasureWidget,
    );
  }
}
