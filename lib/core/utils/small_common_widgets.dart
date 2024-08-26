import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/network_status_methods.dart';
import 'package:official_chatbox_application/features/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_icon_button_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:provider/provider.dart';

Widget countrySelectedShowWidget() {
  return Padding(
    padding: EdgeInsets.only(left: 10.w),
    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state.country != null
            ? TextWidgetCommon(
                text: (state.country!.flagEmoji + state.country!.phoneCode),
                fontWeight: FontWeight.w500,
                fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                textColor: Theme.of(context).colorScheme.onPrimary,
              )
            : Row(
                children: [
                  Image.asset(
                    indiaFlag,
                    scale: 18.sp,
                  ),
                  TextWidgetCommon(
                    text: "91",
                    fontWeight: FontWeight.w500,
                    fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                  )
                ],
              );
      },
    ),
  );
}


Widget commonAnimationWidget({
  required BuildContext context,
  bool? isTextNeeded = true,
  String? text,
  double? fontSize,
  String? lottie,
}) {
  return Center(
    child: SizedBox(
      width: 200.w,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isTextNeeded ?? false)
              TextWidgetCommon(
                textAlign: TextAlign.center,
                text: text ?? "Creating Otp...",
                textColor: buttonSmallTextColor.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontSize: fontSize ?? 26.sp,
              ),
            LottieBuilder.network(
              lottie ??
                  'https://lottie.host/8d23344c-f904-4f4d-b66c-9193441547b9/1PlShH1AmG.json',
              errorBuilder: (context, error, stackTrace) {
                return  emptyShowWidget(context: context, text: "No data");
              },
              frameBuilder: (context, child, composition) {
                if (composition == null) {
                  return emptyShowWidget(context: context, text: "No data");
                }
                return child;
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget commonErrorWidget({String? message}) =>
    Center(child: Text(message ?? 'Unexpected error occured'));

Widget searchButton(
    {required ThemeData theme, required void Function()? onPressed}) {
  return CommonIconButtonWidget(
    theme: theme,
    height: 22,
    width: 22,
    iconImage: search,
    onPressed: onPressed,
  );
}

Widget cameraButtonMainPage(
    {required ThemeData theme, required void Function()? onPressed}) {
  return CommonIconButtonWidget(
    theme: theme,
    height: 30,
    width: 30,
    iconImage: cameraIcon,
    onPressed: onPressed,
  );
}

Widget addChatButtonHome(
    {required ThemeData theme, required void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        CommonIconButtonWidget(
          theme: theme,
          height: 30,
          width: 30,
          iconImage: chatsIcon,
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.add,
            color: theme.colorScheme.onPrimary,
          ),
        )
      ],
    ),
  );
}

PopupMenuItem<dynamic> settingsNavigatorMenu(BuildContext context) {
  return PopupMenuItem(
    child: const Text("Settings"),
    onTap: () {
      Navigator.pushNamed(context, "/settings_page");
    },
  );
}

Widget emptyShowWidget({required BuildContext context, required String text}) {
  return SizedBox(
    width: screenWidth(context: context),
    height: screenHeight(context: context),
    child: Center(
      child: SizedBox(
        width: 250.w,
        child: TextWidgetCommon(
          textAlign: TextAlign.center,
          text: text,
          textColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
        ),
      ),
    ),
  );
}

Widget commonProfileDefaultIconCircularCotainer(
    {required BuildContext context, double? containerConstraint}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).popupMenuTheme.color,
      shape: BoxShape.circle,
    ),
    width: containerConstraint?.w ?? 50.w,
    height: containerConstraint?.w ?? 50.h,
    child: const Center(
      child: Icon(
        Icons.person,
      ),
    ),
  );
}

Widget smallGreyMediumBoldTextWidget({
  required String text,
}) {
  return TextWidgetCommon(
    text: text,
    fontSize: 12.sp,
    textColor: iconGreyColor,
    fontWeight: FontWeight.w500,
  );
}

PopupMenuItem<dynamic> commonPopUpMenuItem({
  required BuildContext context,
  required String menuText,
  dynamic value,
  void Function()? onTap,
}) {
  return PopupMenuItem(
    value: value,
    onTap: onTap,
    child: TextWidgetCommon(
      text: menuText,
      textColor: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

Widget readMoreButton({
  required BuildContext context,
  required CommonProvider commonProvider,
  double? fontSize,
  bool? isInMessageList = false,
  String? messageID,
}) {
  final isExpanded = commonProvider.isExpandedMessage(messageID ?? '');
  return GestureDetector(
    onTap: () {
      !isInMessageList
          ? Provider.of<CommonProvider>(context, listen: false).changeExpanded()
          : Provider.of<CommonProvider>(context, listen: false)
              .toggleExpand(messageID: messageID ?? '');
    },
    child: TextWidgetCommon(
      text: !isInMessageList!
          ? !commonProvider.isExpanded
              ? "...read more"
              : "read less"
          : !isExpanded
              ? "...read more"
              : "read less",
      textColor: buttonSmallTextColor,
      fontSize: fontSize?.sp ?? 16.sp,
    ),
  );
}

Widget listTileCommonWidget(
    {Widget? leading,
    Widget? trailing,
    double? fontSize,
    required String tileText,
    FontWeight? fontWeight,
    Color? textColor,
    TextAlign? textAlign,
    Color? subTitleTextColor,
    String? subTitleTileText,
    Widget? subTitle,
    void Function()? onTap}) {
  return ListTile(
    onTap: onTap,
    leading: leading,
    title: TextWidgetCommon(
      textColor: textColor,
      text: tileText,
      fontSize: fontSize,
      fontWeight: fontWeight,
      textAlign: textAlign,
    ),
    subtitle: subTitle ??
        TextWidgetCommon(
          textColor: subTitleTextColor ?? iconGreyColor,
          text: subTitleTileText ?? '',
        ),
    trailing: trailing,
  );
}

Future<dynamic> animationLoadingDialogBoxTransparent(
    {required BuildContext context}) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: kTransparent,
            content:
                commonAnimationWidget(context: context, isTextNeeded: false),
          ));
}
