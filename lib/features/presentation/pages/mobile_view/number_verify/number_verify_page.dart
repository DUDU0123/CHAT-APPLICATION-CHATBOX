
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/theme/theme_constants.dart';
import 'package:official_chatbox_application/core/constants/app_constants.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/app_icon_hold_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/verify_number/resend_otp_widget.dart';

class NumberVerifyPage extends StatelessWidget {
  NumberVerifyPage({super.key});
  TextEditingController numberVerifyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthOtpModel data =
        ModalRoute.of(context)?.settings.arguments as AuthOtpModel;
    final theme = ThemeConstants.theme(context: context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationErrorState) {
              commonSnackBarWidget(
                context: context,
                contentText: state.message,
              );
            }
            if (state is OtpReSentState) {
              commonSnackBarWidget(
                context: context,
                contentText: "Otp Sent Successfully",
              );
            }
            if (state is AuthenticationSuccessState) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "bottomNav_Navigator",
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthenticationLoadingState) {
              return commonAnimationWidget(
                context: context,
                isTextNeeded: false,
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppIconHoldWidget(),
                kHeight25,
                TextWidgetCommon(
                  textAlign: TextAlign.center,
                  text: "To verify, enter the otp send to the given number",
                  fontSize: 20.sp,
                  textColor: theme.textTheme.titleMedium?.color,
                  fontWeight: theme.textTheme.titleMedium?.fontWeight,
                ),
                kHeight20,
                SizedBox(
                  height: 50.h,
                  child: TextFieldCommon(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    style: fieldStyle(context: context),
                    hintText: "Enter 6-digit otp",
                    textAlign: TextAlign.center,
                    controller: numberVerifyController,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.sp),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                kHeight15,
                CommonButtonContainer(
                  onTap: () {
                    context.read<AuthenticationBloc>().add(
                          CreateUserEvent(
                            context: context,
                            otpCode: numberVerifyController.text,
                            verificationId: data.verifyId,
                            phoneNumber: data.phoneNumber,
                          ),
                        );
                    numberVerifyController.text = '';
                  },
                  horizontalMarginOfButton: 30,
                  text: "Next",
                ),
                kHeight5,
                ResendOtpWidget(
                  onTap: () {
                    context.read<AuthenticationBloc>().add(ResendOtpEvent(
                          context: context,
                          phoneNumberWithCountryCode: data.phoneNumber,
                          forceResendingToken: data.forceResendingToken,
                        ));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
