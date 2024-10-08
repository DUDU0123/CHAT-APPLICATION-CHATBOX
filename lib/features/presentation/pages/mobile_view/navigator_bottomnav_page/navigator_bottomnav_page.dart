import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/service/notification_service.dart';
import 'package:official_chatbox_application/core/utils/app_methods.dart';
import 'package:official_chatbox_application/core/utils/call_methods.dart';
import 'package:official_chatbox_application/core/utils/get_appbar_title.dart';
import 'package:official_chatbox_application/core/utils/network_status_methods.dart';
import 'package:official_chatbox_application/features/data/data_sources/auth_data/auth_data.dart';
import 'package:official_chatbox_application/features/presentation/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/status/status_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/calls/call_home_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_home_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/group/group_home_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/navigator_bottomnav_page/bottom_navbar.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/status/status_home_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/appbar_title_home.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/appbar_icons_home.dart';
class NavigatorBottomnavPage extends StatefulWidget {
  const NavigatorBottomnavPage({super.key});

  @override
  State<NavigatorBottomnavPage> createState() => _NavigatorBottomnavPageState();
}

class _NavigatorBottomnavPageState extends State<NavigatorBottomnavPage> {
  final pages = [
    const ChatHomePage(),
    const GroupHomePage(),
    StatusHomePage(
      currentUserId: AuthData(firebaseAuth: firebaseAuth)
          .getCurrentUserId(firebaseAuth.currentUser?.uid),
    ),
    const CallHomePage(),
  ];

  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    NotificationService.getDeviceToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (context.watch<UserBloc>().state.currentUserData != null) {
      if (context.watch<UserBloc>().state.currentUserData!.isDisabled != null) {
        if (firebaseAuth.currentUser != null &&
            context.watch<UserBloc>().state.currentUserData!.isDisabled!) {
          AppMethods.pop();
        }
      }
    }
    CallMethods.onUserLogin(currentUser: firebaseAuth.currentUser, context: context,);
    NetworkStatusMethods.initialize(context: context);
    final bottomNavBloc = BlocProvider.of<BottomNavBloc>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            BlocBuilder<BottomNavBloc, BottomNavState>(
              builder: (context, state) {
                return SliverAppBar(
                  expandedHeight: 0,
                  surfaceTintColor: kTransparent,
                  floating: state.currentIndex == 0,
                  pinned: state.currentIndex != 0,
                  snap: state.currentIndex == 0,
                  automaticallyImplyLeading: false,
                  title: AppBarTitleHome(
                    appBarTitle:
                        getAppBarTitle(currentIndex: state.currentIndex),
                  ),
                  actions: appBarIconsHome(
                    context: context,
                    currentIndex: state.currentIndex,
                    theme: Theme.of(context),
                    isSearchIconNeeded: state.currentIndex == 2,
                  ),
                );
              },
            ),
          ];
        },
        body: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, state) {
            return PageView(
              onPageChanged: (index) {
                if (index == 0) {
                  context.read<ChatBloc>().add(GetAllChatsEvent());
                } else if (index == 1) {
                  context.read<GroupBloc>().add(GetAllGroupsEvent());
                } else if (index == 2) {
                  context.read<StatusBloc>().add(StatusLoadEvent());
                }
                bottomNavBloc.add(
                  BottomNavIconClickedEvent(
                    currentIndex: index,
                  ),
                );
              },
              controller: pageController,
              children: pages,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        pageController: pageController,
      ),
    );
  }
}
