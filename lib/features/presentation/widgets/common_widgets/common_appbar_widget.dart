import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/app_bar_icon_list_messaging_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';

class CommonAppBar extends StatefulWidget {
  const CommonAppBar({
    super.key,
    required this.pageType,
    required this.appBarTitle,
    this.userStatus,
    this.userProfileImage,
    this.onTap,
    this.groupModel,
    this.chatModel,
    this.isGroup,
  });
  final PageTypeEnum pageType;
  final String appBarTitle;
  final String? userStatus;
  final String? userProfileImage;
  final void Function()? onTap;
  final GroupModel? groupModel;
  final ChatModel? chatModel;
  final bool? isGroup;
  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    final bool isPhotoNeededPage =
        (widget.pageType == PageTypeEnum.oneToOneChatInsidePage ||
            widget.pageType == PageTypeEnum.groupMessageInsidePage);
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: isPhotoNeededPage ? false : true,
      title: isPhotoNeededPage
          ? Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                kWidth5,

                context.watch<UserBloc>().state.userPrivacySettings != null
                    ? context.watch<UserBloc>().state.userPrivacySettings![
                                widget.chatModel?.receiverID] !=
                            null
                        ? context.watch<UserBloc>().state.userPrivacySettings![
                                widget.chatModel
                                    ?.receiverID]![userDbProfilePhotoPrivacy]!=null?context.watch<UserBloc>().state.userPrivacySettings![
                                widget.chatModel
                                    ?.receiverID]![userDbProfilePhotoPrivacy]!
                            ? widget.userProfileImage != null
                                ? userProfileImageShowWidget(
                                    context: context,
                                    imageUrl: widget.userProfileImage!,
                                  )
                                : nullImageReplaceWidget(
                                    containerRadius: 45,
                                    context: context,
                                  )
                            : nullImageReplaceWidget(
                                containerRadius: 45, context: context)
                        : nullImageReplaceWidget(
                            containerRadius: 45, context: context)
                    : nullImageReplaceWidget(
                        containerRadius: 45, context: context):nullImageReplaceWidget(
                        containerRadius: 45, context: context),
                kWidth5,
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidgetCommon(
                          overflow: TextOverflow.ellipsis,
                          text: widget.appBarTitle,
                          fontSize: 18.sp,
                        ),
                        widget.pageType != PageTypeEnum.groupMessageInsidePage
                            ? context
                                                .watch<UserBloc>()
                                                .state
                                                .userPrivacySettings?[
                                            widget.chatModel?.receiverID]
                                        ?[userDbLastSeenOnline] !=
                                    null
                                ? context
                                                .watch<UserBloc>()
                                                .state
                                                .userPrivacySettings![
                                            widget.chatModel?.receiverID]![
                                        userDbLastSeenOnline]!
                                    ? TextWidgetCommon(
                                        overflow: TextOverflow.ellipsis,
                                        text: widget.userStatus ??
                                            'Last seen 10:00am',
                                        fontSize: 10.sp,
                                      )
                                    : zeroMeasureWidget
                                : zeroMeasureWidget
                            : zeroMeasureWidget,
                      ],
                    ),
                  ),
                ),
              ],
            )
          : TextWidgetCommon(
              text: widget.appBarTitle,
            ),
      actions: !(widget.pageType == PageTypeEnum.settingsPage)
          ? appBarIconListMessagingPage(
              mounted: mounted,
              appBarTitle: widget.appBarTitle,
              chatModel: widget.chatModel,
              groupModel: widget.groupModel,
              isGroup: widget.isGroup ?? false,
              pageType: widget.pageType,
              context: context,
              receiverImage:
                  context.watch<UserBloc>().state.userPrivacySettings != null
                      ? context.watch<UserBloc>().state.userPrivacySettings![
                                  widget.chatModel?.receiverID] !=
                              null
                          ? context
                                      .watch<UserBloc>()
                                      .state
                                      .userPrivacySettings![
                                  widget.chatModel
                                      ?.receiverID]![userDbProfilePhotoPrivacy]!=null? context
                                      .watch<UserBloc>()
                                      .state
                                      .userPrivacySettings![
                                  widget.chatModel
                                      ?.receiverID]![userDbProfilePhotoPrivacy]!
                              ? widget.userProfileImage
                              : null
                          : null
                      : null:null,
            )
          : [],
    );
  }
}
