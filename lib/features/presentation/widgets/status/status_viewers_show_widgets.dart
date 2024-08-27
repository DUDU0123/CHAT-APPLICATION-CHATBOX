import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

Widget viewersShowButton({required List<String>? viewersList}) {
  final viewers = viewersList
      ?.where((viewerId) => viewerId != firebaseAuth.currentUser?.uid)
      .toList();
  return Column(
    children: [
      TextWidgetCommon(
        text: viewers != null ? viewers.length.toString() : '0',
        textColor: kWhite,
        fontSize: 16.sp,
      ),
      Icon(
        Icons.remove_red_eye_outlined,
        color: kWhite,
        size: 18.sp,
      ),
    ],
  );
}

Future<dynamic> statusViewersListShowBottomSheet(
    {required BuildContext context, required List<String>? viewersList}) {
  // Calculate the height based on the number of viewers
  double maxHeight = screenHeight(context: context) / 2;
  double calculatedHeight = (viewersList?.length ?? 0) * 70.h +
      100.h; // Adjust 70.h as per your item height

  // Ensure the height does not exceed the maximum height (half of the screen)
  double finalHeight =
      calculatedHeight > maxHeight ? maxHeight : calculatedHeight;

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: darkScaffoldColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.sp),
            topRight: Radius.circular(20.sp),
          ),
        ),
        height: finalHeight,
        child: Column(
          children: [
            Container(
              height: 50.h,
              width: screenWidth(context: context),
              decoration: BoxDecoration(
                color: darkSwitchColor,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Center(
                child: TextWidgetCommon(
                  text: "Viewed by ${viewersList?.length}",
                  textColor: kWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(20.sp),
                  itemCount: viewersList?.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder<UserModel?>(
                        stream: viewersList != null
                            ? CommonDBFunctions
                                .getOneUserDataFromDataBaseAsStream(
                                userId: viewersList[index],
                              )
                            : null,
                        builder: (context, snapshot) {
                          return ListTile(
                            leading: buildProfileImage(
                                userProfileImage:
                                    snapshot.data?.userProfileImage,
                                context: context),
                            tileColor: kGrey,
                            title: TextWidgetCommon(
                              text: snapshot.data?.contactName ??
                                  snapshot.data?.userName ??
                                  snapshot.data?.phoneNumber ??
                                  '',
                              fontWeight: FontWeight.w500,
                              textColor: kWhite,
                              textAlign: TextAlign.start,
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      );
    },
  );
}
