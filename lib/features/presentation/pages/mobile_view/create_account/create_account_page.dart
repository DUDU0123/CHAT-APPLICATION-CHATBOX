import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/theme/theme_constants.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/app_icon_hold_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/phone_number_recieve_field.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});
  TextEditingController regionController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight(context: context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationErrorState) {
                  commonSnackBarWidget(
                      context: context, contentText: state.message);
                }
              },
              builder: (context, state) {
                if (state is OtpSentState) {
                  return commonAnimationWidget(
                    isTextNeeded: false,
                    context: context,
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppIconHoldWidget(),
                    kHeight25,
                    TextWidgetCommon(
                      text: "Enter phone number",
                      fontSize: 20.sp,
                      textColor: theme.textTheme.titleMedium?.color,
                      fontWeight: theme.textTheme.titleMedium?.fontWeight,
                    ),
                    kHeight10,
                    PhoneNumberRecieveField(
                      phoneNumberController: phoneNumberController,
                    ),
                    kHeight15,
                    CommonButtonContainer(
                      onTap: () {
                        final authBloc = context.read<AuthenticationBloc>();
                        final String? countryCode = authBloc.state.country?.phoneCode;
                        final mobileNumber = phoneNumberController.text.trim();
                        final String phoneNumber =
                           countryCode!=null && countryCode.isNotEmpty? "+$countryCode$mobileNumber":"+91 $mobileNumber";
                        authBloc.add(
                          OtpSentEvent(
                            phoneNumberWithCountryCode: phoneNumber,
                            context: context,
                          ),
                        );
                      },
                      horizontalMarginOfButton: 30,
                      text: "Next",
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
