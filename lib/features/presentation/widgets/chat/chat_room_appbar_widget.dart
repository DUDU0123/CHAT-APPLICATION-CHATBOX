import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/features/data/data_sources/user_data/user_data.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_info_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget oneToOneChatAppBarWidget({
  required ChatModel? chatModel,
  required bool isGroup,
  required String userName,
  required BuildContext context,
  required String receiverID,
}) {
  return StreamBuilder<UserModel?>(
      stream: UserData.getOneUserDataFromDataBaseAsStream(
          userId: chatModel?.receiverID ?? receiverID),
      builder: (context, snapshot) {
        
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final privacySettings = state.userPrivacySettings?[chatModel?.receiverID] ?? {};
            final bool isShowableProfileImage =
            privacySettings[userDbProfilePhotoPrivacy] ?? false;
            return CommonAppBar(
              isGroup: false,
              chatModel: chatModel,
              onTap: () async {
                if (chatModel == null) {
                  return;
                }
                if (chatModel.receiverID == null) {
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatInfoPage(
                        chatModel: chatModel,
                        isGroup: false,
                        receiverContactName: userName,
                        receiverData: snapshot.data,
                      ),
                    ));
              },
              userProfileImage: isShowableProfileImage
                  ? chatModel?.receiverProfileImage
                  : null,
              userStatus: snapshot.data != null
                  ? snapshot.data!.userNetworkStatus != null
                      ? snapshot.data!.userNetworkStatus!
                          ? 'Online'
                          : TimeProvider.getUserLastActiveTime(
                              givenTime:
                                  snapshot.data!.lastActiveTime.toString(),
                              context: context,
                            )
                      : TimeProvider.getUserLastActiveTime(
                          givenTime: snapshot.data!.lastActiveTime.toString(),
                          context: context,
                        )
                  : 'Offline',
              appBarTitle: userName,
              pageType: isGroup
                  ? PageTypeEnum.groupMessageInsidePage
                  : PageTypeEnum.oneToOneChatInsidePage,
            );
          },
        );
      });
}

Widget groupChatAppBarWidget({
  required GroupModel? groupModel,
  required bool isGroup,
  required BuildContext context,
}) {
  if (groupModel == null) {
    return const TextWidgetCommon(text: "No Appbar");
  }
  return StreamBuilder<GroupModel?>(
      stream: groupModel != null
          ? CommonDBFunctions.getOneGroupDataByStream(
              userID: firebaseAuth.currentUser!.uid,
              groupID: groupModel.groupID!,
            )
          : null,
      builder: (context, snapshot) {
        return CommonAppBar(
          isGroup: true,
          groupModel: snapshot.data,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatInfoPage(
                  isGroup: true,
                  groupData: groupModel,
                ),
              ),
            );
          },
          userProfileImage: snapshot.data != null
              ? snapshot.data?.groupProfileImage
              : groupModel.groupProfileImage,
          appBarTitle: snapshot.data != null
              ? snapshot.data?.groupName ?? "Group name"
              : groupModel.groupName ?? "Group name",
          pageType: PageTypeEnum.groupMessageInsidePage,
        );
      });
}
