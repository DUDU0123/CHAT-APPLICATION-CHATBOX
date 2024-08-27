import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/contact_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_info/chat_info_page_body.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_appbar_content_widget.dart';

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
      body: chatInfoPageBody(
        chatModel: chatModel,
        groupData: groupData,
        isGroup: isGroup,
        receiverContactName: receiverContactName,
        callBloc: context.read<CallBloc>(),
        groupNameEditController: groupNameEditController,
        receiverData: receiverData,
        context: context,
        isAdmin: isAdmin,
      ),
    );
  }
}
