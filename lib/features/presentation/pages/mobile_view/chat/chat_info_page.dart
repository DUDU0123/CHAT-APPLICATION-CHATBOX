import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/contact_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_actions_on_longpress_method.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_info/chat_info_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_appbar_content_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_list_tile_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_user_details_part_widget.dart';

class ChatInfoPage extends StatelessWidget {
  const ChatInfoPage({
    super.key,
    this.receiverData,
    this.receiverContactName,
    this.groupData,
    required this.isGroup,
    this.chatModel,
    this.isAIChat,
  });
  final UserModel? receiverData;
  final String? receiverContactName;
  final GroupModel? groupData;
  final bool isGroup;
  final bool? isAIChat;
  final ChatModel? chatModel;
  @override
  Widget build(BuildContext context) {
    TextEditingController groupNameEditController = TextEditingController();
    List<String>? groupAdmins = groupData?.groupAdmins;
    bool isAdmin =
        groupAdmins?.contains(firebaseAuth.currentUser?.uid) ?? false;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: infoPageAppBarContentWidget(
          context: context,
          receiverData: receiverData,
          groupData: groupData,
          isGroup: isGroup,
          receiverContactName: receiverContactName,
        ),
        actions: [
          !isGroup
              ? PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      commonPopUpMenuItem(
                        context: context,
                        menuText: "Share",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectContactPage(
                                messageContent: receiverData?.phoneNumber,
                                messageType: MessageType.contact,
                                isStatus: false,
                                pageType: PageTypeEnum.toSendPage,
                                isGroup: false,
                              ),
                            ),
                          );
                        },
                      ),
                      commonPopUpMenuItem(
                        context: context,
                        menuText: "Edit",
                        onTap: () {
                          ContactMethods.openEditContactInDevice(
                            context: context,
                            receiverID: receiverData?.id,
                          );
                        },
                      ),
                      commonPopUpMenuItem(
                        context: context,
                        menuText: "View in address book",
                        onTap: () {
                          ContactMethods.openContactInDevice(
                            context: context,
                            receiverID: receiverData?.id,
                          );
                        },
                      )
                    ];
                  },
                )
              : zeroMeasureWidget,
        ],
      ),
      body: chatInfoPageBody(groupNameEditController, context, isAdmin),
    );
  }

  Padding chatInfoPageBody(TextEditingController groupNameEditController,
      BuildContext context, bool isAdmin) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoPageUserDetailsPart(
              groupNameEditController: groupNameEditController,
              context: context,
              receiverData: receiverData,
              groupData: groupData,
              isGroup: isGroup,
              receiverContactName: receiverContactName,
            ),
            kHeight20,
            infoPageActionIconsBlueGradient(
              context: context,
              isGroup: isGroup,
            ),
            chatDescriptionOrAbout(
              groupData: groupData,
              context: context,
              isGroup: isGroup,
              receiverAbout: receiverData?.userAbout,
              groupDescription: groupData?.groupDescription,
              receiverData: receiverData,
            ),
            heightWidgetReturnOnCondition(
              isGroup: isGroup,
              groupData: groupData,
            ),
            !isGroup
                ? chatMediaGradientContainerWidget(
                    context: context,
                    chatModel: chatModel,
                  )
                : isAdmin
                    ? groupPermissionGraientContainerWidget(
                        context: context,
                        groupData: groupData,
                      )
                    : zeroMeasureWidget,
            heightWidgetReturnOnCondition(
              isGroup: isGroup,
              groupData: groupData,
            ),
            membersListOrGroupListWidget(
              context: context,
              receiverData: receiverData,
              groupData: groupData,
            ),
            kHeight20,
            chatModel != null
                ? infoPageListTileWidget(
                    chatModel: chatModel,
                    context: context,
                    receiverData: receiverData,
                    isFirstTile: true,
                  )
                : zeroMeasureWidget,
            // for group
            groupData != null
                ? groupData!.groupMembers!
                        .contains(firebaseAuth.currentUser?.uid)
                    ? groupListTile(
                        context: context,
                        isGroup: isGroup,
                        title: "Exit group",
                        groupData: groupData!,
                        icon: Icons.logout,
                        tileType: 'exit-tile',
                      )
                    : zeroMeasureWidget
                : zeroMeasureWidget,
            // for group
            groupData != null
                ? !groupData!.groupMembers!
                        .contains(firebaseAuth.currentUser?.uid)
                    ? commonListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: kRed,
                          size: 28.sp,
                        ),
                        color: kRed,
                        onTap: () {
                          deleteChatMethodCommon(
                            context: context,
                            isGroup: isGroup,
                            chatModel: chatModel,
                            groupModel: groupData,
                          );
                        },
                        title: "Delete Group",
                        isSmallTitle: false,
                        context: context,
                      )
                    : zeroMeasureWidget
                : zeroMeasureWidget,
            // for one-to-one chat
            chatModel != null
                ? infoPageListTileWidget(
                    context: context,
                    isFirstTile: false,
                    chatModel: chatModel,
                    receiverData: receiverData,
                  )
                : zeroMeasureWidget,
          ],
        ),
      ),
    );
  }
}
