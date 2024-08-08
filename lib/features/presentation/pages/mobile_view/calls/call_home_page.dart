import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/call_buttons.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

class CallHomePage extends StatefulWidget {
  const CallHomePage({super.key});

  @override
  State<CallHomePage> createState() => _CallHomePageState();
}

class _CallHomePageState extends State<CallHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // listTileCommonWidget(
          //   subTitleTileText: "Make a call to anyone",
          //   textColor: Theme.of(context).colorScheme.onPrimary,
          //   tileText: "Make a call",
          //   fontSize: 20.sp,
          //   fontWeight: FontWeight.bold,
          //   leading: CircleAvatar(
          //     radius: 30.sp,
          //     backgroundColor: buttonSmallTextColor,
          //     child: Icon(
          //       Icons.call,
          //       color: kWhite,
          //       size: 30.sp,
          //     ),
          //   ),
          // ),
          recentCallTextWidget(),
          Expanded(
            child: BlocConsumer<CallBloc, CallState>(
              listener: (context, state) {
                if (state is CallErrorState) {
                  return commonSnackBarWidget(
                    context: context,
                    contentText: state.errorMessage,
                  );
                }
              },
              builder: (context, state) {
                return StreamBuilder<List<CallModel>?>(
                    stream: state.callLogList,
                    builder: (context, snapshot) {
                      if (snapshot.data == null || snapshot.hasError) {
                        debugPrint("Null error: ${snapshot.error.toString()}");
                        return emptyShowWidget(
                            context: context, text: "No call Logs");
                      }
                      if (snapshot.data!.isEmpty) {
                        debugPrint(
                          "Empty error : ${snapshot.error.toString()}",
                        );
                        return emptyShowWidget(
                            context: context, text: "No call Logs");
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          final callModel = snapshot.data![index];
                          final currentUserId = firebaseAuth.currentUser?.uid;

                          return StreamBuilder<Object?>(
                              stream: callModel.isGroupCall != null
                                  ? !callModel.isGroupCall!
                                      ? CommonDBFunctions
                                          .getOneUserDataFromDataBaseAsStream(
                                          userId: callModel.callerId !=
                                                  currentUserId
                                              ? callModel.callerId!
                                              : callModel
                                                  .callrecieversId!.first,
                                        )
                                      : callModel.groupModelId != null
                                          ? CommonDBFunctions
                                              .getOneGroupDataByStream(
                                              groupID: callModel.groupModelId!,
                                              userID: currentUserId!,
                                            )
                                          : null
                                  : null,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return emptyShowWidget(
                                      context: context,
                                      text: "Fetching call logs....");
                                }
                                final theme = Theme.of(context);
                                final callBloc = context.read<CallBloc>();
                                UserModel? userModel;
                                GroupModel? groupModel;

                                if (snapshot.hasData) {
                                  if (callModel.isGroupCall != null &&
                                      !callModel.isGroupCall!) {
                                    userModel = snapshot.data as UserModel?;
                                  } else if (callModel.isGroupCall != null &&
                                      callModel.isGroupCall!) {
                                    groupModel = snapshot.data as GroupModel?;
                                  }
                                }
                                ChatModel? chatModel;
                                return listTileCommonWidget(
                                  onTap: () {
                                    callLogDeleteActionMethod(
                                      context: context,
                                      callModel: callModel,
                                    );
                                  },
                                  leading: buildProfileImage(
                                    userProfileImage:
                                        callModel.isGroupCall != null
                                            ? !callModel.isGroupCall!
                                                ? userModel?.userProfileImage
                                                : groupModel?.groupProfileImage
                                            : null,
                                    context: context,
                                  ),
                                  tileText: callModel.isGroupCall != null
                                      ? !callModel.isGroupCall!
                                          ? userModel?.contactName ??
                                              userModel?.phoneNumber ??
                                              userModel?.phoneNumber ??
                                              '${userModel?.phoneNumber}'
                                          : groupModel?.groupName ??
                                              '${groupModel?.groupName}'
                                      : '',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  textColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  subTitle: Row(
                                    children: [
                                      Transform.rotate(
                                        angle: pi / 180 * -40,
                                        child: Icon(
                                          callModel.callerId ==
                                                  firebaseAuth.currentUser?.uid
                                              ? Icons.arrow_forward_outlined
                                              : Icons.arrow_back_outlined,
                                          color: callModel.isMissedCall != null
                                              ? callModel.isMissedCall!
                                                  ? kGreen
                                                  : kRed
                                              : kRed,
                                          size: 16.sp,
                                        ),
                                      ),
                                      TextWidgetCommon(
                                        text: TimeProvider.getRelativeTime(
                                            callModel.callStartTime!),
                                        fontSize: 10.sp,
                                        textColor: iconGreyColor,
                                      )
                                    ],
                                  ),
                                  trailing:
                                      //  GestureDetector(
                                      //   onTap: () async {
                                      //     chatModel = callModel.chatModelId != null
                                      //         ? await CommonDBFunctions
                                      //             .getChatModelByChatID(
                                      //             chatModelId:
                                      //                 callModel.chatModelId!,
                                      //           )
                                      //         : null;
                                      //   },
                                      //   child:
                                        //  callButtonsMethods(
                                        //   callBloc: callBloc,
                                        //   chatModel: chatModel,
                                        //   groupModel: groupModel,
                                        //   isVideoCall:
                                        //       callModel.callType == CallType.audio
                                        //           ? false
                                        //           : true,
                                        //   theme: theme,
                                        //   receiverTitle: callModel.receiverName!,
                                        //   receiverImage: callModel.receiverImage,
                                        // ),
                                      // ),
                                      IconButton(
                                    onPressed: () async {
                                      final theme = Theme.of(context);
                                      final callBloc = context.read<CallBloc>();

                                      final groupModel =
                                          callModel.groupModelId != null
                                              ? await CommonDBFunctions
                                                  .getGroupDetailsByGroupID(
                                                      userID: firebaseAuth
                                                          .currentUser!.uid,
                                                      groupID: callModel
                                                          .groupModelId!)
                                              : null;
                                      callButtonsMethods(
                                        callBloc: callBloc,
                                        chatModel: chatModel,
                                        groupModel: groupModel,
                                        isVideoCall:
                                            callModel.callType == CallType.audio
                                                ? false
                                                : true,
                                        theme: theme,
                                        receiverTitle: callModel.receiverName!,
                                        receiverImage: callModel.receiverImage,
                                      );
                                    },
                                    icon: SvgPicture.asset(
                                      callModel.callType == CallType.audio
                                          ? call
                                          : videoCall,
                                      width: 26.w,
                                      height: 26.h,
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).colorScheme.onPrimary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        separatorBuilder: (context, index) => kHeight5,
                        itemCount: snapshot.data!.length,
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

void callLogDeleteActionMethod({
  required BuildContext context,
  required CallModel callModel,
}) {
  return normalDialogBoxWidget(
    context: context,
    title: "Delete call log",
    subtitle: "Do you want to delete this call log?",
    onPressed: () {
      callModel.callId != null
          ? context.read<CallBloc>().add(
                DeleteACallLogEvent(
                  callId: callModel.callId!,
                ),
              )
          : null;
      Navigator.pop(context);
    },
    actionButtonName: "Delete",
  );
}

Widget recentCallTextWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 25.w,
      vertical: 5.h,
    ),
    child: smallGreyMediumBoldTextWidget(text: "Recent calls"),
  );
}
