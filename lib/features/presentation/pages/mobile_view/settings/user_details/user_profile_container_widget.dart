import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/camera_icon_button.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/profile_image_selector_bottom_sheet.dart';

Future<dynamic> userProfilePhotoPickBottomSheetWidget(
    {required BuildContext context}) {
  return assetSelectorBottomSheet(
    firstButtonIcon: Icons.photo,
    secondButtonIcon: Icons.camera_alt_outlined,
    context: context,
    firstButtonName: "Gallery",
    secondButtonName: "Camera",
    firstButtonAction: () {
      context.read<UserBloc>().add(
            const PickProfileImageFromDevice(
              imageSource: ImageSource.gallery,
            ),
          );
      Navigator.pop(context);
    },
    secondButtonAction: () {
      context.read<UserBloc>().add(
            const PickProfileImageFromDevice(
              imageSource: ImageSource.camera,
            ),
          );
      Navigator.pop(context);
    },
  );
}

Widget userProfileImageContainerWidget(
    {required BuildContext context, required double containerRadius}) {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is ImagePickErrorState) {
        return Center(
          child: Text(state.message),
        );
      }
      if (state.currentUserData == null) {
        return zeroMeasureWidget;
      }

      return state.currentUserData?.userProfileImage != null
          ? Container(
              height: containerRadius.h,
              width: containerRadius.w,
              decoration: BoxDecoration(
                color: Theme.of(context).popupMenuTheme.color,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      state.currentUserData!.userProfileImage!),
                  fit: BoxFit.cover,
                ),
              ),
              child: containerRadius >= 160
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: CameraIconButton(
                        onPressed: () {
                          userProfilePhotoPickBottomSheetWidget(
                            context: context,
                          );
                        },
                      ),
                    )
                  : zeroMeasureWidget,
            )
          : nullImageReplaceWidget(
              containerRadius: containerRadius,
              context: context,
            );
    },
  );
}

Widget nullImageReplaceWidget(
    {required double containerRadius, required BuildContext context}) {
  return Stack(
    children: [
      Container(
        height: containerRadius.h,
        width: containerRadius.w,
        decoration: BoxDecoration(
          color: Theme.of(context).popupMenuTheme.color,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                contact,
                width: 100.w,
                height: 100.h,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            containerRadius >= 160
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: CameraIconButton(
                      onPressed: () {
                        userProfilePhotoPickBottomSheetWidget(
                          context: context,
                        );
                      },
                    ),
                  )
                : zeroMeasureWidget,
          ],
        ),
      ),
    ],
  );
}
