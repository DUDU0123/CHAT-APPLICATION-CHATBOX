import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

class BlockedContactsPage extends StatefulWidget {
  const BlockedContactsPage({super.key});

  @override
  State<BlockedContactsPage> createState() => _BlockedContactsPageState();
}

class _BlockedContactsPageState extends State<BlockedContactsPage> {
  @override
  void initState() {
    context.read<UserBloc>().add(GetBlockedUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Blocked contacts"),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is BlockUserErrorState) {
            commonSnackBarWidget(
              context: context,
              contentText: state.errorMessage,
            );
          }
        },
        builder: (context, state) {
          return StreamBuilder<List<BlockedUserModel>>(
              stream: state.blockedUsersList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return commonAnimationWidget(
                    context: context,
                    isTextNeeded: false,
                  );
                }
                if (snapshot.hasError) {
                  return emptyShowWidget(
                    text: "No blocked contacts",
                    context: context,
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return emptyShowWidget(
                    text: "No blocked contacts",
                    context: context,
                  );
                }
                if (snapshot.data == null) {
                  return emptyShowWidget(
                    text: "No blocked contacts",
                    context: context,
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  itemBuilder: (context, index) {
                    return StreamBuilder<UserModel?>(
                        stream: CommonDBFunctions
                            .getOneUserDataFromDataBaseAsStream(
                          userId: snapshot.data![index].userId!,
                        ),
                        builder: (context, blockedUserSnapshot) {
                          return commonListTile(
                            leading: buildProfileImage(
                              userProfileImage:
                                  blockedUserSnapshot.data?.userProfileImage,
                              context: context,
                            ),
                            onTap: () {
                              normalDialogBoxWidget(
                                context: context,
                                title:
                                    "Unblock ${blockedUserSnapshot.data?.phoneNumber}",
                                subtitle:
                                    "Do ypu want to unblock ${blockedUserSnapshot.data?.phoneNumber}",
                                onPressed: () {
                                  context.read<UserBloc>().add(
                                        RemoveBlockedUserEvent(
                                          blockedUserId:
                                              snapshot.data![index].id!,
                                        ),
                                      );
                                  Navigator.pop(context);
                                },
                                actionButtonName: "Unblock",
                              );
                            },
                            title: blockedUserSnapshot.data?.phoneNumber ?? "",
                            isSmallTitle: false,
                            context: context,
                          );
                        });
                  },
                  separatorBuilder: (context, index) => kHeight10,
                  itemCount: snapshot.data!.length,
                );
              });
        },
      ),
    );
  }
}
