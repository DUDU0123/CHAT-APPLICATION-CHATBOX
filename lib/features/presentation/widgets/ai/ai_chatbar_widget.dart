import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/emoji_select.dart';
import 'package:official_chatbox_application/features/presentation/bloc/box_ai/boxai_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:provider/provider.dart';

class AIChatBarWidget extends StatelessWidget {
  AIChatBarWidget({
    super.key,
    required this.focusNode,
    required this.scrollController,
  });

  final FocusNode focusNode;
  final messageController = TextEditingController();
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
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
                      onPressed: () {
                        focusNode.unfocus();
                        Provider.of<CommonProvider>(context, listen: false)
                            .setEmojiPickerStatus();
                      },
                      icon: SvgPicture.asset(
                        width: 25.w,
                        height: 25.h,
                        colorFilter:
                            ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
                        smileIcon,
                      ),
                    ),
                    kWidth10,
                    Expanded(
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (hasFocus &&
                              Provider.of<CommonProvider>(context,
                                      listen: false)
                                  .isEmojiPickerOpened) {
                            Provider.of<CommonProvider>(context, listen: false)
                                .setEmojiPickerStatus();
                          }
                        },
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
        Provider.of<CommonProvider>(context).isEmojiPickerOpened
            ? emojiSelect(
                textEditingController: messageController,
              )
            : zeroMeasureWidget,
      ],
    );
  }
}
