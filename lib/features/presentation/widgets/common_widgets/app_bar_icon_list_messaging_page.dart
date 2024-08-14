import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/call_buttons.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_app_bar_widgets_and_methods.dart';
import 'common_appbar_menu_items.dart';

List<Widget> appBarIconListMessagingPage({
  required PageTypeEnum pageType,
  required BuildContext context,
  required GroupModel? groupModel,
  required ChatModel? chatModel,
  required bool isGroup,
  required String appBarTitle,
  required String? receiverImage,
  required bool mounted,
}) {
  final currentUserId = firebaseAuth.currentUser?.uid;
  final callBloc = context.read<CallBloc>();
  Icon muteIcon = Icon(
    Icons.mic_off_outlined,
    color: iconGreyColor,
  );
  return [
    chatModel != null
        ? chatMuteIconWidget(
            chatModel: chatModel,
            muteIcon: muteIcon,
          )
        : zeroMeasureWidget,
    groupModel != null
        ? groupMuteIconWidget(
            groupModel: groupModel,
            muteIcon: muteIcon,
          )
        : zeroMeasureWidget,
    chatModel != null
        ? chatModel.receiverID != currentUserId
            ? callButtonsMethods(
              context: context,
                theme: Theme.of(context),
                callBloc: callBloc,
                receiverImage: receiverImage,
                receiverTitle: appBarTitle,
                chatModel: chatModel,
                groupModel: groupModel,
                isVideoCall: true,
              )
            : zeroMeasureWidget
        : callButtonsMethods(
          context: context,
            theme: Theme.of(context),
            callBloc: callBloc,
            receiverImage: receiverImage,
            receiverTitle: appBarTitle,
            chatModel: chatModel,
            groupModel: groupModel,
            isVideoCall: true,
          ),
    kWidth10,
    chatModel != null
        ? chatModel.receiverID != currentUserId
            ? callButtonsMethods(
              context: context,
                callBloc: callBloc,
                receiverTitle: appBarTitle,
                receiverImage: receiverImage,
                chatModel: chatModel,
                groupModel: groupModel,
                isVideoCall: false,
                theme: Theme.of(context),
              )
            : zeroMeasureWidget
        : callButtonsMethods(
          context: context,
            callBloc: callBloc,
            receiverImage: receiverImage,
            receiverTitle: appBarTitle,
            chatModel: chatModel,
            groupModel: groupModel,
            isVideoCall: false,
            theme: Theme.of(context),
          ),
    commonAppBarMenuItemHoldWidget(
      mounted: mounted,
      pageType: pageType,
      chatModel: chatModel,
      groupModel: groupModel,
      isGroup: isGroup,
    ),
  ];
}
