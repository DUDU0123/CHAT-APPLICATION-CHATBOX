import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/service/dialog_helper.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/navigator_bottomnav_page/navigator_bottomnav_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/auth/auth_small_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/app_icon_hold_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/phone_number_recieve_field.dart';
class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight(context: context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state.message != null) {
                  if (state.message!.isNotEmpty) {
                    DialogHelper.showSnackBar(
                        title: 'Info', contentText: state.message!);
                  }
                }
                if (state.isUserCreated ?? false) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigatorBottomnavPage(),
                    ),
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading ?? false) {
                  return commonAnimationWidget(
                    context: context,
                    lottie: settingsLottie,
                    fontSize: 16.sp,
                    isTextNeeded: false,
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppIconHoldWidget(),
                    kHeight20,
                    commonAuthTextField(
                        controller: emailController,
                        hintText: 'example@gmail.com',
                        labelText: 'Email'),
                    kHeight15,
                    commonAuthTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        labelText: 'Enter password'),
                    kHeight15,
                    PhoneNumberRecieveField(
                      phoneNumberController: phoneNumberController,
                    ),
                    kHeight15,
                    CommonButtonContainer(
                      onTap: () {
                        final email = emailController.text;
                        final password = passwordController.text;
                        final authBloc = context.read<AuthenticationBloc>();
                        final String? countryCode =
                            authBloc.state.country?.phoneCode;
                        final mobileNumber = phoneNumberController.text.trim();
                        final String phoneNumber =
                            countryCode != null && countryCode.isNotEmpty
                                ? "+$countryCode$mobileNumber"
                                : "+91 $mobileNumber";
                        context.read<AuthenticationBloc>().add(
                              CreateUserEvent(
                                context: context,
                                email: email,
                                password: password,
                                phoneNumberWithCountryCode: phoneNumber,
                              ),
                            );
                      },
                      horizontalMarginOfButton: 30,
                      text: "Create account",
                      child: state.isLoading != null
                          ? state.isLoading!
                              ? commonCircularProgressIndicator()
                              : null
                          : null,
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
