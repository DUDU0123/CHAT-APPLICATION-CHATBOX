import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/status/status_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/status_tile_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/status_viewers_show_widgets.dart';

class StatusHomePage extends StatefulWidget {
  const StatusHomePage({
    super.key,
    required this.currentUserId,
  });
  final String? currentUserId;

  @override
  State<StatusHomePage> createState() => _StatusHomePageState();
}

class _StatusHomePageState extends State<StatusHomePage> {
  @override
  void initState() {
    CommonDBFunctions.updateStatusListInStatusModelInDB(
        userId: firebaseAuth.currentUser?.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StatusBloc, StatusState>(
        listener: (context, state) {
          if (state is StatusErrorState) {
            commonSnackBarWidget(
              context: context,
              contentText: state.errorMessage,
            );
          }
        },
        builder: (context, state) {
          if (state is StatusLoadingState) {
            return commonAnimationWidget(context: context, isTextNeeded: false);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              StreamBuilder<StatusModel?>(
                  stream: CommonDBFunctions.getCurrentUserStatus(),
                  builder: (context, snapshot) {
                    return statusTileWidget(
                      currentUserId: widget.currentUserId,
                      isCurrentUser: true,
                      statusModel: snapshot.data,
                      context: context,
                    );
                  }),
              kHeight15,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: smallGreyMediumBoldTextWidget(text: "Updates"),
              ),
              kHeight15,
              Expanded(
                child: StreamBuilder<List<StatusModel>?>(
                    stream: state.statusList,
                    builder: (context, snapshot) {
                      if (snapshot.data == null || snapshot.hasError) {
                        return commonErrorWidget(message: "No status");
                      }
                      if (snapshot.data!.isEmpty) {
                        return emptyShowWidget(
                            context: context, text: "No status");
                      }
                      final otherUsersStatuses = snapshot.data!.where((status) {
                        final privacySettings = context
                            .watch<UserBloc>()
                            .state
                            .userPrivacySettings?[status.statusUploaderId];
                        final isShowableStatus =
                            privacySettings?[userDbStatusPrivacy] ?? false;
                        return status.statusUploaderId !=
                                firebaseAuth.currentUser?.uid &&
                            (status.statusList?.isNotEmpty ?? false) &&
                            isShowableStatus;
                      }).toList();

                      if (otherUsersStatuses.isEmpty) {
                        return emptyShowWidget(
                            context: context, text: "No status");
                      }

                      for (var statusmodel in otherUsersStatuses) {
                        CommonDBFunctions.updateStatusListInStatusModelInDB(
                            userId: statusmodel.statusUploaderId);
                      }

                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        itemCount: otherUsersStatuses.length,
                        itemBuilder: (context, index) {
                          final status = otherUsersStatuses[index];
                          return statusTileWidget(
                            currentUserId: widget.currentUserId,
                            isCurrentUser: false,
                            context: context,
                            statusModel: status,
                          );
                        },
                      );
                    }),
              )
            ],
          );
        },
      ),
      floatingActionButton: textStatusButton(),
    );
  }
}
