import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/uploaded_status_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/floating_done_navigation_button.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/select_contacts_body.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/select_contacts_small_widgets.dart';

class SelectContactPage extends StatefulWidget {
  const SelectContactPage({
    super.key,
    this.chatModel,
    this.receiverContactName,
    required this.pageType,
    this.groupModel,
    required this.isGroup,
    this.uploadedStatusModel,
    this.statusModel,
    this.uploadedStatusModelID,
    this.isStatus,
    this.messageType,
    this.messageContent,
    this.rootContext,
  });
  final ChatModel? chatModel;
  final String? receiverContactName;
  final PageTypeEnum pageType;
  final GroupModel? groupModel;
  final UploadedStatusModel? uploadedStatusModel;
  final StatusModel? statusModel;
  final String? uploadedStatusModelID;
  final bool isGroup;
  final bool? isStatus;
  final MessageType? messageType;
  final String? messageContent;
  final BuildContext? rootContext;
  @override
  State<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  @override
  void initState() {
    super.initState();
    // Clear the selected contacts when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactBloc>().add(ClearListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<ContactBloc>().state.contactList?.length == 0 ||
        context.watch<ContactBloc>().state.contactList?.length == null) {
      context.read<ContactBloc>().add(GetContactsEvent(context: context));
    }
    return Scaffold(
      appBar: AppBar(
        leading: appBarLeading(context: context),
        title: appBarTitileWidget(pageType: widget.pageType),
      ),
      body: selectContactsBody(
        context: context,
        pageType: widget.pageType,
        groupModel: widget.groupModel,
      ),
      floatingActionButton: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          return FloatingDoneNavigateButton(
            rootContext: widget.rootContext,
            messageType: widget.messageType,
            messageContent: widget.messageContent,
            isStatus: widget.isStatus ?? false,
            uploadedStatusModelID: widget.uploadedStatusModelID,
            statusModel: widget.statusModel,
            uploadedStatusModel: widget.uploadedStatusModel,
            icon: widget.pageType == PageTypeEnum.groupInfoPage
                ? Icons.done
                : widget.pageType == PageTypeEnum.toSendPage
                    ? Icons.send_rounded
                    : widget.pageType == PageTypeEnum.broadcastMembersSelectPage
                        ? Icons.done
                        : null,
            groupModel: widget.groupModel,
            isGroup: widget.isGroup,
            pageType: widget.pageType,
            receiverContactName: widget.receiverContactName ?? '',
            chatModel: widget.chatModel,
            selectedContactList: state.selectedContactList,
          );
        },
      ),
    );
  }
}
