import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class PaymentsHomePage extends StatelessWidget {
  const PaymentsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<ContactBloc>().state.contactList?.length == 0 ||
        context.watch<ContactBloc>().state.contactList?.length == null) {
      context.read<ContactBloc>().add(GetContactsEvent(context: context));
    }
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Payments"),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const PaymentHistoryPage(),
              //   ),
              // );
            },
            icon: Icon(
              Icons.history,
              color: buttonSmallTextColor,
              size: 28.sp,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactsLoadingState) {
            return commonAnimationWidget(context: context, isTextNeeded: false);
          }
          if (state.contactList == null) {
            return emptyShowWidget(context: context, text: "No contacts");
          }
          if (state.contactList!.isEmpty) {
            return emptyShowWidget(context: context, text: "No contacts");
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: smallGreyMediumBoldTextWidget(text: "Send money to: "),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: state.contactList!.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => SendMoneyPage(
                      //         contact: state.contactList![index],
                      //       ),
                      //     ));
                    },
                    leading: buildProfileImage(
                      userProfileImage:
                          state.contactList![index].userProfilePhotoOnChatBox,
                      context: context,
                    ),
                    title: TextWidgetCommon(
                      text: state.contactList![index].userContactName ?? "",
                    ),
                  ),
                  separatorBuilder: (context, index) => kHeight10,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}