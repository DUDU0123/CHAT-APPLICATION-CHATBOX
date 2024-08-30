import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/select_user_widgets.dart/contact_single_widget.dart';

Widget allContactsListShowWidget({
  required ContactState state,
  required PageTypeEnum pageType,
}) {
  return ListView.separated(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    itemCount: state.contactList!.length,
    itemBuilder: (context, index) {
      final contact = state.contactList![index];
      if (pageType == PageTypeEnum.groupInfoPage) {
        return zeroMeasureWidget;
      }
      return ContactSingleWidget(
        key: ValueKey(contact.userContactNumber),
        isSelected: state.selectedContactList != null
            ? state.selectedContactList!.contains(contact)
            : false,
        contactModel: contact,
        contactNameorNumber:
            contact.userContactName ?? contact.userContactNumber ?? '',
      );
    },
    separatorBuilder: (context, index) => kHeight2,
  );
}

Widget appBarLeading({
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    icon: Icon(
      Icons.arrow_back,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

Widget appBarTitileWidget({
  required PageTypeEnum pageType,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextWidgetCommon(
          text: pageType == PageTypeEnum.sendContactSelectPage
              ? "Selected Contacts"
              : pageType == PageTypeEnum.groupMemberSelectPage
                  ? "New Group"
                  : pageType == PageTypeEnum.groupInfoPage
                      ? "Add members"
                      : pageType == PageTypeEnum.toSendPage
                          ? "Send to"
                          : "New Broadcast"),
      pageType == PageTypeEnum.sendContactSelectPage
          ? BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                return TextWidgetCommon(
                  text: "${state.selectedContactList?.length} contacts",
                  fontSize: 12.sp,
                );
              },
            )
          : zeroMeasureWidget,
    ],
  );
}