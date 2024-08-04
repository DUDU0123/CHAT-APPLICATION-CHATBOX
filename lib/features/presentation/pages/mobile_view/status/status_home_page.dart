
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/status/status_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/status/status_pages/text_status_setup_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/status_tile_widget.dart';

class StatusHomePage extends StatefulWidget {
  const StatusHomePage({super.key});

  @override
  State<StatusHomePage> createState() => _StatusHomePageState();
}

class _StatusHomePageState extends State<StatusHomePage> {
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
                    // log("Error fetching current status: ${snapshot.error}");
                    // log("Current status of current user: ${snapshot.data}");
                    return statusTileWidget(
                      isCurrentUser: true,
                      statusModel: snapshot.data,
                      context: context,
                    );
                  }),
              kHeight15,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: smallGreyMediumBoldTextWidget(text: "Recent updates"),
              ),
              kHeight15,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: smallGreyMediumBoldTextWidget(text: "Viewed updates"),
              ),
              Expanded(
                child: StreamBuilder<List<StatusModel>?>(
                    stream: state.statusList,
                    builder: (context, snapshot) {
                      log(snapshot.data.toString());
                      if (snapshot.data == null || snapshot.hasError) {
                        return commonErrorWidget(
                            message:
                                "No data ${snapshot.error} ${snapshot.stackTrace}");
                      }
                      if (snapshot.data!.isEmpty) {
                        return emptyShowWidget(
                            context: context, text: "No status");
                      }
                      final otherUsersStatuses = snapshot.data!
                          .where((status) =>
                              status.statusUploaderId !=
                              firebaseAuth.currentUser?.uid)
                          .toList();

                      if (otherUsersStatuses.isEmpty) {
                        return emptyShowWidget(
                            context: context, text: "No status");
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
      floatingActionButton: StreamBuilder<StatusModel?>(
          stream: CommonDBFunctions.getCurrentUserStatus(),
          builder: (context, snapshot) {
            return FloatingActionButton(
              backgroundColor: darkLinearGradientColorTwo,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TextStatusSetupPage(
                        currentStatusModel: snapshot.data,
                      ),
                    ));
              },
              child: Icon(
                Icons.edit,
                color: kWhite,
              ),
            );
          }),
    );
  }
}
