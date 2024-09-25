import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/service/dialog_helper.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_listtile_widget.dart';

class GroupHomePage extends StatelessWidget {
  const GroupHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state.message != null) {
            if (state.message!.isNotEmpty) {
              DialogHelper.showSnackBar(
                  title: "Info", contentText: state.message!);
            }
          }
        },
        builder: (context, state) {
          if (state.isLoading ?? false) {
            return commonAnimationWidget(
              context: context,
              isTextNeeded: false,
            );
          }
          return StreamBuilder<List<GroupModel>?>(
              stream: state.groupList,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return commonErrorWidget(
                    message: "Something went wrong: ${snapshot.error}",
                  );
                }
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return emptyShowWidget(
                    text: "No groups",
                    context: context,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final GroupModel group = snapshot.data![index];
                    return ChatListTileWidget(
                      isMutedChat: group.isMuted,
                      notificationCount: group.notificationCount,
                      isIncomingMessage: group.isIncomingMessage,
                      userProfileImage: group.groupProfileImage,
                      userName: group.groupName != null
                          ? group.groupName!.isNotEmpty
                              ? group.groupName!
                              : 'ChatBox Group'
                          : 'ChatBox Group',
                      isGroup: true,
                      groupModel: group,
                    );
                  },
                  separatorBuilder: (context, index) => kHeight5,
                );
              });
        },
      ),
    );
  }
}
