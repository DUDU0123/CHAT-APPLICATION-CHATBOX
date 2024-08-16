import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/data_sources/user_data/user_data.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/circle_image_show_prevent_error_widget.dart';

BlocBuilder<UserBloc, UserState> selectedUserDataWidget(
    {required ContactModel contactModel}) {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      Stream<UserModel?> userModel = const Stream.empty();
      if (contactModel.chatBoxUserId != null) {
        userModel = UserData.getOneUserDataFromDataBaseAsStream(
          userId: contactModel.chatBoxUserId!,
        );
      }
      return StreamBuilder<UserModel?>(
        stream: userModel,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            commonProfileDefaultIconCircularCotainer(
              context: context,
            );
          }
          return snapshot.data?.userProfileImage != null
              ? BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    final privacySettings =
                        state.userPrivacySettings?[snapshot.data?.id] ?? {};
                    final isShowableProfileImage =
                        privacySettings[userDbProfilePhotoPrivacy] ?? false;
                    return isShowableProfileImage? circleImageShowPreventErrorWidget(
                      containerSize: 50,
                      image: snapshot.data!.userProfileImage!,
                    ): commonProfileDefaultIconCircularCotainer(
                  context: context,
                );
                  },
                )
              : commonProfileDefaultIconCircularCotainer(
                  context: context,
                );
        },
      );
    },
  );
}
