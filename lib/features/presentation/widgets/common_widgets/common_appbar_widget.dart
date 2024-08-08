
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/app_bar_icon_list_messaging_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({
    super.key,
    required this.pageType,
    required this.appBarTitle,
    this.userStatus,
    this.userProfileImage, this.onTap, this.groupModel, this.chatModel,  this.isGroup,
  });
  final PageTypeEnum pageType;
  final String appBarTitle;
  final String? userStatus;
  final String? userProfileImage;
  final void Function()? onTap;
  final GroupModel? groupModel;final ChatModel? chatModel; final bool? isGroup;

  @override
  Widget build(BuildContext context) {
    final bool isPhotoNeededPage =
        (pageType == PageTypeEnum.oneToOneChatInsidePage ||
            pageType == PageTypeEnum.groupMessageInsidePage);
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
                    userProfileImage!=null? userProfileImageShowWidget(
                      context: context,
                      imageUrl: userProfileImage!,
                    ):nullImageReplaceWidget(
                        containerRadius: 45,
                        context: context,
                      ),
                kWidth5,
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidgetCommon(
                          overflow: TextOverflow.ellipsis,
                          text: appBarTitle,
                          fontSize: 18.sp,
                        ),
                      pageType!=PageTypeEnum.groupMessageInsidePage?  TextWidgetCommon(
                          overflow: TextOverflow.ellipsis,
                          text: userStatus ?? 'Last seen 10:00am',
                          fontSize: 10.sp,
                        ):zeroMeasureWidget,
                      ],
                    ),
                  ),
                ),
              ],
            )
          : TextWidgetCommon(
              text: appBarTitle,
            ),
      actions: !(pageType == PageTypeEnum.settingsPage)
          ? appBarIconListMessagingPage(
            appBarTitle: appBarTitle,
            chatModel: chatModel,groupModel: groupModel,isGroup: isGroup??false,
              pageType: pageType,
              context: context,
              receiverImage: userProfileImage,
            )
          : [],
    );
  }
}
