import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/box_ai/boxai_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat/different_message_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

StreamBuilder<List<MessageModel>> aiMessagesStreamWidget({
  required BoxAIState state,
  required ScrollController scrollController,
}) {
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
            final messageDate = DateProvider.formatMessageDateTime(
              isInsideChat: true,
              messageDateTimeString: message.messageTime.toString(),
            );
            final isCurrentUser =
                message.senderID == firebaseAuth.currentUser?.uid;

            return Row(
              mainAxisAlignment: isCurrentUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25.sp),
                        topLeft: Radius.circular(25.sp),
                      )),
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25.sp),
                                topLeft: Radius.circular(25.sp),
                              )),
                          width: screenWidth(context: context),
                          height: screenHeight(context: context) / 8,
                          child: ListTile(
                            onTap: () {
                              message.messageId != null
                                  ? context.read<BoxAIBloc>().add(
                                        DeleteMessageEvent(
                                          messageId: message.messageId!,
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
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              fontSize: 20.sp,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
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
}