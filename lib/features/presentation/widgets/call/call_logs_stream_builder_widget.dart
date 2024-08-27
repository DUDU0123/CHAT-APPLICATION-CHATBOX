import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/call/call_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';

StreamBuilder<List<CallModel>?> callLogsStreamBuilderWidget(CallState state) {
    return StreamBuilder<List<CallModel>?>(
        stream: state.callLogList,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.hasError) {
            debugPrint("Null error: ${snapshot.error.toString()}");
            return emptyShowWidget(context: context, text: "No call Logs");
          }
          if (snapshot.data!.isEmpty) {
            debugPrint(
              "Empty error : ${snapshot.error.toString()}",
            );
            return emptyShowWidget(context: context, text: "No call Logs");
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
                              userId: callModel.callerId != currentUserId
                                  ? callModel.callerId!
                                  : callModel.callrecieversId!.first,
                            )
                          : callModel.groupModelId != null
                              ? CommonDBFunctions.getOneGroupDataByStream(
                                  groupID: callModel.groupModelId!,
                                  userID: currentUserId!,
                                )
                              : null
                      : null,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return emptyShowWidget(
                          context: context, text: "Fetching call logs....");
                    }
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
                    return listTileCommonWidget(
                      onTap: () {
                        callLogDeleteActionMethod(
                          context: context,
                          callModel: callModel,
                        );
                      },
                      leading: buildProfileImage(
                        userProfileImage: callModel.isGroupCall != null
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
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      subTitle: callTileSubTitleWidget(callModel),
                      trailing: callTrailingIconWidget(
                        callModel,
                        context,
                      ),
                    );
                  });
            },
            separatorBuilder: (context, index) => kHeight5,
            itemCount: snapshot.data!.length,
          );
        });
  }