import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/contact_list_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/payments/payments_home_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:provider/provider.dart';

List<Widget> appBarIconsHome(
    {required bool isSearchIconNeeded,
    required ThemeData theme,
    required int currentIndex,
    required BuildContext context}) {
  return [
    currentIndex == 0
        ? addChatButtonHome(
            theme: theme,
            onTap: () {
              context.read<ContactBloc>().add(GetContactsEvent(context: context));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactListPage(),
                ),
              );
            },
          )
        : zeroMeasureWidget,
    PopupMenuButton(
      onSelected: (value) {},
      itemBuilder: (context) {
        if (currentIndex == 0) {
          return [
            commonPopUpMenuItem(
              context: context,
              menuText: "New group",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectContactPage(
                        isGroup: false,
                        pageType: PageTypeEnum.groupMemberSelectPage,
                      ),
                    ));
              },
            ),
            commonPopUpMenuItem(
              context: context,
              menuText: "Payments",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentsHomePage(),
                  ),
                );
              },
            ),
            settingsNavigatorMenu(context),
          ];
        }
        if (currentIndex == 1 || currentIndex == 2) {
          return [
            settingsNavigatorMenu(context),
          ];
        }
        return [
          commonPopUpMenuItem(context: context, menuText: "Clear call log", onTap: () {
            context.read<CallBloc>().add(ClearAllCallLogs());
          },),
          settingsNavigatorMenu(context),
        ];
      },
    ),
  ];
}
