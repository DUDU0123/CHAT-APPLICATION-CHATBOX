import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/core/utils/theme_type_giver.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/wallpaper/wallpaper_select_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/theme_set_dialogbox.dart';

class ChatSettings extends StatelessWidget {
  const ChatSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Chats",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            commonListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const ThemeSetDialogBox();
                  },
                );
              },
              title: "Theme",
              subtitle: themeType(context: context),
              isSmallTitle: false,
              context: context,
              leading: SvgPicture.asset(
                theme,
                width: 30.w,
                height: 30.h,
                colorFilter: ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
              ),
            ),
            kHeight10,
            commonListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WallpaperSelectPage(
                      pageTypeEnum: PageTypeEnum.chatSetting,
                    ),
                  ),
                );
              },
              title: "Wallpaper",
              isSmallTitle: false,
              context: context,
              leading: SvgPicture.asset(
                wallpaper,
                width: 30.w,
                height: 30.h,
                colorFilter: ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
              ),
            ),
            kHeight10,
            BlocListener<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ClearChatsLoadingState) {
                  animationLoadingDialogBoxTransparent(
                    context: context,
                  );
                } else if (state is ClearChatsSuccessState) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }

                  commonSnackBarWidget(
                      context: context, contentText: state.clearChatMessage);
                } else if (state is ClearChatsErrorState) {
                  commonSnackBarWidget(
                    context: context,
                    contentText: state.errorMessage,
                  );
                }
              },
              child: commonListTile(
                onTap: () {
                  normalDialogBoxWidget(
                    actionButtonName: "Clear chats",
                    context: context,
                    onPressed: () {
                      context.read<ChatBloc>().add(ClearAllChatsEvent());
                      Navigator.pop(context);
                    },
                    subtitle: "This will clear all the messages in every chats",
                    title: "Clear all chats",
                  );
                },
                title: "Clear all chats",
                isSmallTitle: false,
                context: context,
                leading: SvgPicture.asset(
                  clearIcon,
                  width: 30.w,
                  height: 30.h,
                  colorFilter: ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
