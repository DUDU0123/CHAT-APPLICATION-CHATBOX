import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
class DeleteAccountPage extends StatefulWidget {
 const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Delete this account",
        ),
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
        if (state.message != null) {
          if (state.message!.isNotEmpty) {
            commonSnackBarWidget(context: context, contentText: state.message!);
          }
        }
        if (state.isLoading ?? false) {
          showDialog(
            context: context,
            builder: (context) {
              return commonAnimationWidget(
                context: context,
                lottie: settingsLottie,
                text: "Deleting",
                fontSize: 16.sp,
                isTextNeeded: true,
              );
            },
          );
        }
      }, builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextWidgetCommon(
                  textAlign: TextAlign.center,
                  text:
                      "If you delete this account, every information related to this account will be deleted and can't receover it. If you are sure to delete, click on Delete account button below.",
                  fontSize: 16.sp,
                ),
                kHeight15,
                CommonButtonContainer(
                  horizontalMarginOfButton: 40,
                  text: "Delete account",
                  onTap: () {
                    final authBloc = context.read<AuthenticationBloc>();
                    authBloc.add(
                      UserPermanentDeleteEvent(
                        mounted: mounted,
                        context: context,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
