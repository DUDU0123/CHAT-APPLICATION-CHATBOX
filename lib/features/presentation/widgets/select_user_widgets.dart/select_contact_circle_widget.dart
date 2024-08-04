
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/select_user_data_widget.dart';

class SelectContactCircleWidget extends StatelessWidget {
  const SelectContactCircleWidget({
    super.key,
    required this.contactModel,
  });
  final ContactModel contactModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(contactModel.userContactNumber),
      children: [
        Stack(
          children: [
            selectedUserDataWidget(
              contactModel: contactModel,
            ),
            Positioned(
              bottom: 0.h,
              right: 0.w,
              child: Container(
                height: 25.h,
                width: 25.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        darkLinearGradientColorOne,
                        darkLinearGradientColorTwo,
                      ],
                    )),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      context
                          .read<ContactBloc>()
                          .add(SelectUserEvent(contact: contactModel));
                    },
                    icon: Icon(
                      Icons.close,
                      color: kWhite,
                      size: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 50.w,
          child: TextWidgetCommon(
            text: contactModel.userContactName ??
                contactModel.userContactNumber ??
                '',
            fontSize: 12.sp,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
