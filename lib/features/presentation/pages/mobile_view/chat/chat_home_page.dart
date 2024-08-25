import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/call_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/ai_chat_room/ai_chat_room_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/searchbar_chat_home.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SearchBarChatHome(),
          ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoadingState) {
                return SliverToBoxAdapter(
                  child: commonAnimationWidget(
                    context: context,
                    isTextNeeded: false,
                    lottie: settingsLottie,
                  ),
                );
              }
              if (state is ChatErrorState) {
                return SliverToBoxAdapter(
                    child: Center(
                  child: TextWidgetCommon(text: state.errormessage),
                ));
              }
              return StreamBuilder<List<ChatModel>>(
                stream: state.chatList,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data!.isEmpty) {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          width: screenWidth(context: context),
                          height: screenWidth(context: context),
                          child: emptyShowWidget(
                            context: context,
                            text: noChatText,
                          ),
                        ),
                      );
                    }
                  }
                  return SliverList.separated(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      final chat = snapshot.data;
                      if (chat == null) {
                        return zeroMeasureWidget;
                      }
                      
                      return ChatListTileWidget(
                        isIncomingMessage: chat[index].isIncomingMessage,
                        chatModel: chat[index],
                        isGroup: false,
                        isMutedChat: chat[index].isMuted,
                        notificationCount: chat[index].notificationCount,
                        userName: chat[index].receiverName ?? '',
                        userProfileImage: chat[index].receiverProfileImage,
                      );
                    },
                    separatorBuilder: (context, index) => kHeight5,
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkLinearGradientColorTwo,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AIChatRoomPage(),
            ),
          );
        },
        child: Icon(
          Icons.adb_sharp,
          color: kWhite,
          size: 30.sp,
        ),
      ),
    );
  }
}
