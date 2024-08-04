import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/service/locator.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/data_edit_dialog_box.dart';

class CommonBlueGradientContainerWidget extends StatelessWidget {
  const CommonBlueGradientContainerWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.pageType,
    this.controller,
    this.fieldTypeSettings,
  });

  final String title;
  final String subTitle;
  final String icon;
  final PageTypeEnum pageType;
  final FieldTypeSettings? fieldTypeSettings;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    if (pageType==PageTypeEnum.settingEditProfilePage) {
      final currentState =
        context.read<UserBloc>().state as CurrentUserLoadedState;
    controller?.text = fieldTypeSettings == FieldTypeSettings.name
        ? currentState.currentUserData.userName ?? ""
        : currentState.currentUserData.userAbout ?? "";
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.sp),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkLinearGradientColorOne,
            darkLinearGradientColorTwo,
          ],
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            height: (icon != keyIcon && icon != privacyIcon) ? 30.h : 35.h,
            width: 30.w,
            colorFilter: ColorFilter.mode(
              iconGreyColor,
              BlendMode.srcIn,
            ),
          ),
          kWidth10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidgetCommon(
                  text: title,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: !(pageType == PageTypeEnum.none ||
                          pageType == PageTypeEnum.settingEditProfilePage)
                      ? FontWeight.w500
                      : FontWeight.w400,
                  fontSize: !(pageType == PageTypeEnum.none ||
                          pageType == PageTypeEnum.settingEditProfilePage)
                      ? 16.5.sp
                      : 13.sp,
                  textColor: !(pageType == PageTypeEnum.none ||
                          pageType == PageTypeEnum.settingEditProfilePage)
                      ? kWhite
                      : iconGreyColor,
                ),
                kHeight2,
                subTitle.isEmpty
                    ? zeroMeasureWidget
                    : TextWidgetCommon(
                        fontSize: !(pageType == PageTypeEnum.none ||
                                pageType == PageTypeEnum.settingEditProfilePage)
                            ? 12.sp
                            : 18.sp,
                        fontWeight: !(pageType == PageTypeEnum.none ||
                                pageType == PageTypeEnum.settingEditProfilePage)
                            ? FontWeight.normal
                            : FontWeight.w500,
                        textColor: !(pageType == PageTypeEnum.none ||
                                pageType == PageTypeEnum.settingEditProfilePage)
                            ? iconGreyColor
                            : kWhite,
                        maxLines: 1,
                        text: subTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
          pageType == PageTypeEnum.settingEditProfilePage
              ? IconButton(
                  onPressed: () {
                    dataEditDialogBox(
                      maxLines: fieldTypeSettings == FieldTypeSettings.name
                          ? 1
                          : 5,
                      onPressed: () {
                        UserModel currentUser = getItInstance<UserModel>();
                    UserModel updateUser =
                        fieldTypeSettings == FieldTypeSettings.name
                            ? currentUser.copyWith(
                                userName: controller?.text,
                              )
                            : currentUser.copyWith(
                                userAbout: controller?.text,
                              );
                    context
                        .read<UserBloc>()
                        .add(EditCurrentUserData(userModel: updateUser));
                    Navigator.pop(context);
                      },
                      controller: controller,
                      context: context,
                      fieldTitle: fieldTypeSettings == FieldTypeSettings.name
                          ? "Enter your name"
                          : "About",
                      hintText: fieldTypeSettings == FieldTypeSettings.name
                          ? "Enter name"
                          : "Enter about",
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: kWhite,
                  ),
                )
              : zeroMeasureWidget,
        ],
      ),
    );
  }
}
