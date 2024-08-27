import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/image_picker_method.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/wallpaper/wallpaper_widgets.dart';

class WallpaperSelectPage extends StatefulWidget {
  const WallpaperSelectPage({
    super.key,
    this.groupModel,
    this.chatModel,
    this.pageTypeEnum,
  });
  final GroupModel? groupModel;
  final ChatModel? chatModel;
  final PageTypeEnum? pageTypeEnum;

  @override
  State<WallpaperSelectPage> createState() => _WallpaperSelectPageState();
}

class _WallpaperSelectPageState extends State<WallpaperSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(
          text: "Wallpaper",
        ),
      ),
      body: SizedBox(
        width: screenWidth(context: context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pickedWalpaperShowWidget(
              context: context,
            ),
            kHeight15,
            wallpaperButtonWidget(
                buttonName: "Pick wallpaper",
                onPressed: () async {
                  final file =
                      await pickImage(imageSource: ImageSource.gallery);
                  if (mounted) {
                    context
                        .read<ChatBloc>()
                        .add(PickImageEvent(pickedFile: file));
                  }
                }),
            kHeight15,
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    wallpaperButtonWidget(
                        buttonName: "Set for All",
                        onPressed: () async {
                          if (state.pickedFile != null) {
                            CommonDBFunctions.setWallpaper(
                              forWhich: For.all,
                              chatModel: widget.chatModel,
                              groupModel: widget.groupModel,
                              wallpaperFile: state.pickedFile!,
                            );
                            commonSnackBarWidget(
                              context: context,
                              contentText: "Wallpaper set for all chats",
                            );
                          }
                        }),
                    widget.pageTypeEnum != PageTypeEnum.chatSetting
                        ? kWidth10
                        : zeroMeasureWidget,
                    widget.pageTypeEnum != PageTypeEnum.chatSetting
                        ? wallpaperButtonWidget(
                            buttonName: "Set for this",
                            onPressed: () async {
                              if (state.pickedFile != null) {
                                CommonDBFunctions.setWallpaper(
                                  forWhich: For.notAll,
                                  chatModel: widget.chatModel,
                                  groupModel: widget.groupModel,
                                  wallpaperFile: state.pickedFile!,
                                );
                                commonSnackBarWidget(
                                  context: context,
                                  contentText:
                                      "Wallpaper set for only this chat",
                                );
                              }
                            })
                        : zeroMeasureWidget,
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
