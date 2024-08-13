import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/theme/theme_manager.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/data_sources/ai_data/ai_data.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/bloc/boxai_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/ai_chat_room/inner_pages/ai_chat_info_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/different_message_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:provider/provider.dart';

class AIChatRoomPage extends StatelessWidget {
  AIChatRoomPage({super.key});
  final FocusNode focusNode = FocusNode();
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aiData = AIData(
      firebaseFirestore: FirebaseFirestore.instance,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_outlined,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            kWidth5,
            imageContainer(size: 40),
            kWidth5,
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AIChatInfoPage(),
                      ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boxAITitle(),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              commonPopUpMenuItem(
                context: context,
                menuText: "Clear chat",
                onTap: () {
                  context.read<BoxAIBloc>().add(ClearChatEvent());
                },
              ),
              commonPopUpMenuItem(
                context: context,
                menuText: "Info",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AIChatInfoPage(),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth(context: context),
            height: screenHeight(context: context),
            child: Image.asset(
              fit: BoxFit.cover,
              Provider.of<ThemeManager>(context).isDark ? bgImage : bgImage,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: BlocConsumer<BoxAIBloc, BoxAIState>(
                  listener: (context, state) {
                    if (state is BoxAIErrorState) {
                      commonSnackBarWidget(
                        context: context,
                        contentText: state.errorMessage,
                      );
                    }
                  },
                  builder: (context, state) {
                    return StreamBuilder<List<MessageModel>>(
                        stream: state.aiChatMessages,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return zeroMeasureWidget;
                          }
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              scrollController.jumpTo(
                                scrollController.position.maxScrollExtent,
                              );
                            });
                          }
                          return ListView.separated(
                            controller: scrollController,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            itemBuilder: (context, index) {
                              final message = snapshot.data![index];
                              final isCurrentUser = message.senderID ==
                                  firebaseAuth.currentUser?.uid;

                              return Row(
                                mainAxisAlignment: isCurrentUser
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25.sp),
                                          topLeft: Radius.circular(25.sp),
                                        )),
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(25.sp),
                                                  topLeft:
                                                      Radius.circular(25.sp),
                                                )),
                                            width:
                                                screenWidth(context: context),
                                            height:
                                                screenHeight(context: context) /
                                                    8,
                                            child: ListTile(
                                              onTap: () {
                                                message.messageId != null
                                                    ? context
                                                        .read<BoxAIBloc>()
                                                        .add(
                                                          DeleteMessageEvent(
                                                            messageId: message
                                                                .messageId!,
                                                          ),
                                                        )
                                                    : null;
                                              },
                                              leading: Icon(
                                                Icons.delete_outline,
                                                size: 30.sp,
                                              ),
                                              title: TextWidgetCommon(
                                                text: "Delete",
                                                textColor: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 20.sp,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.sp),
                                        gradient: isCurrentUser
                                            ? LinearGradient(
                                                colors: [
                                                  darkSwitchColor,
                                                  lightLinearGradientColorTwo,
                                                ],
                                              )
                                            : LinearGradient(
                                                colors: [
                                                  kBlack,
                                                  darkSwitchColor,
                                                ],
                                              ),
                                      ),
                                      child: textMessageWidget(
                                        message: message,
                                        context: context,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => kHeight10,
                            itemCount: snapshot.data!.length,
                          );
                        });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth(context: context) / 1.29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.sp),
                        color: const Color.fromARGB(255, 39, 52, 78),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              width: 25.w,
                              height: 25.h,
                              colorFilter: ColorFilter.mode(
                                  iconGreyColor, BlendMode.srcIn),
                              smileIcon,
                            ),
                          ),
                          kWidth10,
                          Expanded(
                            child: TextFieldCommon(
                              focusNode: focusNode,
                              style: fieldStyle(context: context).copyWith(
                                fontWeight: FontWeight.w400,
                                color: kWhite,
                              ),
                              hintText: "Type message...",
                              maxLines: 5,
                              controller: messageController,
                              textAlign: TextAlign.start,
                              border: InputBorder.none,
                              cursorColor: buttonSmallTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        color: buttonSmallTextColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () async {
                            if (messageController.text.isNotEmpty) {
                              context.read<BoxAIBloc>().add(
                                    SendMessageEvent(
                                      message: messageController.text,
                                    ),
                                  );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              });
                              messageController.clear();
                            }
                          },
                          icon: Icon(
                            Icons.send_rounded,
                            size: 30.sp,
                          ),
                          color: kBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
