import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/tfa_widgets.dart';

class TwoStepVerificationPage extends StatelessWidget {
  TwoStepVerificationPage({super.key});
  TextEditingController twoStepVerificationPinController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Two Step Verification",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: SingleChildScrollView(
          child: StreamBuilder<UserModel?>(
              stream: CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                  userId: firebaseAuth.currentUser!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.data == null) {
                  return zeroMeasureWidget;
                }
                final userModel = userSnapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    twoStepVerificationTopImageStaticWidget(),
                    kHeight25,
                    userModel!.tfaPin!.isEmpty
                        ? twoStepListTileWidget(
                            icon: Icons.password,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TFAPinCreatePage(
                                    context: context,
                                    twoStepVerificationPinController:
                                        twoStepVerificationPinController,
                                  ),
                                ),
                              );
                            },
                            title: "Create Pin",
                          )
                        : twoStepListTileWidget(
                            icon: Icons.password,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TFAPinCreatePage(
                                    context: context,
                                    twoStepVerificationPinController:
                                        twoStepVerificationPinController,
                                  ),
                                ),
                              );
                            },
                            title: "Change PIN",
                          ),
                    turnOffWidget(context: context),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
