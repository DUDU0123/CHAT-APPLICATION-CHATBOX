
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/settings/common_blue_gradient_container_widget.dart';

import '../../../../../../core/constants/colors.dart';

class AccountOwnerProfileDetailsGridView extends StatelessWidget {
  const AccountOwnerProfileDetailsGridView({
    super.key,
    required this.nameController,
    required this.aboutController,
  });

  final TextEditingController nameController;
  final TextEditingController aboutController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is CurrentUserErrorState) {
          return Center(child: Text(state.message));
        }

          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            crossAxisCount: 1,
            childAspectRatio: 4.5,
            mainAxisSpacing: 10.h,
            children: [
              CommonBlueGradientContainerWidget(
                fieldTypeSettings: FieldTypeSettings.name,
                controller: nameController,
                title: "Name",
                subTitle: state.currentUserData?.userName ?? 'Edit Name',
                icon: contact,
                pageType: PageTypeEnum.settingEditProfilePage,
              ),
              CommonBlueGradientContainerWidget(
                fieldTypeSettings: FieldTypeSettings.about,
                controller: aboutController,
                title: "About",
                subTitle: state.currentUserData?.userAbout ?? 'Available',
                icon: info,
                pageType: PageTypeEnum.settingEditProfilePage,
              ),
              CommonBlueGradientContainerWidget(
                title: "Phone number",
                subTitle: state.currentUserData?.phoneNumber ?? '0000000000',
                icon: call,
                pageType: PageTypeEnum.none,
              ),
            ],
          );

      },
    );
  }
}
