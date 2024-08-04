import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/select_contact_circle_widget.dart';

class SelectedContactShowWidget extends StatelessWidget {
  const SelectedContactShowWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.watch<ContactBloc>().state.selectedContactList!.isNotEmpty
          ? 100.h
          : 0.h,
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state.selectedContactList == null) {
            return zeroMeasureWidget;
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SelectContactCircleWidget(
                contactModel: state.selectedContactList![index],
              );
            },
            separatorBuilder: (context, index) => kWidth5,
            itemCount: state.selectedContactList!.length,
          );
        },
      ),
    );
  }
}
