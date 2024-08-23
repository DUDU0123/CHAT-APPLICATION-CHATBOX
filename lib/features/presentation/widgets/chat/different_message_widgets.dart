import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/chat_asset_send_methods.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/camera_photo_pick/asset_show_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

Widget locationMessageWidget({required MessageModel message}) {
  return Center(
    child: Column(
      children: [
        SvgPicture.asset(
          location,
          width: 50.w,
          height: 50.w,
          colorFilter: ColorFilter.mode(
            kBlack,
            BlendMode.srcIn,
          ),
        ),
        TextButton(
          onPressed: () async {
            await canLaunchUrlString(message.message ?? '')
                ? await launchUrlString(message.message ?? '')
                : null;
          },
          child: TextWidgetCommon(
            text: "Open Location",
            textColor: kWhite,
            fontSize: 18.sp,
          ),
        ),
      ],
    ),
  );
}

Widget textMessageWidget({
  required MessageModel message,
  required BuildContext context,
}) {
  final commonProvider = Provider.of<CommonProvider>(context, listen: true);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      message.message != null
          ? readMoreTextWidget(
              commonProvider: commonProvider,
              message: message.message!,
              messageModel: message)
          : zeroMeasureWidget,
      message.message != null && message.message!.length > 1000
          ? readMoreButton(
              context: context,
              commonProvider: commonProvider,
              fontSize: 16,
              isInMessageList: true,
              messageID: message.messageId)
          : zeroMeasureWidget,
    ],
  );
}

Widget documentMessageWidget({
  required MessageModel message,
  required BuildContext context,
  required bool mounted,
}) {
  return GestureDetector(
    onTap: () async {
      if (await CommonDBFunctions.checkAssetExists(message.message!)) {
        openDocument(url: message.message ?? '');
      } else {
       if (mounted) {
          simpleDialogBox(
          context: context,
          title: "Can't open, it is deleted",
          buttonText: "Ok",
          onPressed: () {
            Navigator.pop(context);
          },
        );
       }
      }
    },
    child: Row(
      children: [
        SvgPicture.asset(
          document,
          width: 30.w,
          height: 30.h,
          colorFilter: ColorFilter.mode(
            kWhite,
            BlendMode.srcIn,
          ),
        ),
        Expanded(
          child: TextWidgetCommon(
            overflow: TextOverflow.ellipsis,
            text: message.name ?? '',
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
        )
      ],
    ),
  );
}

Widget photoMessageShowWidget({
  required MessageModel message,
  required ChatModel? chatModel,
  required BuildContext context,
  required String receiverID,
  required bool isGroup,
  required bool mounted,
  GroupModel? groupModel,
}) {
  final commonProvider = Provider.of<CommonProvider>(context, listen: true);
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.sp),
    child: Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (await CommonDBFunctions.checkAssetExists(message.message!)) {
              if (mounted) {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssetShowPage(
                    isGroup: isGroup,
                    groupModel: groupModel,
                    receiverID: receiverID,
                    messageType: MessageType.photo,
                    chatID: chatModel?.chatID ?? '',
                    message: message,
                  ),
                ),
              );
              }
            } else {
              if (mounted) {
                simpleDialogBox(
                context: context,
                title: "Can't open photo, it is deleted",
                buttonText: "Ok",
                onPressed: () {
                  Navigator.pop(context);
                },
              );
              }
            }
          },
          child: Container(
            height: 250.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  message.message ?? '',
                ),
              ),
            ),
          ),
          // child: Container(
          //   height: 250.h,
          //   child: Center(
          //     child: CachedNetworkImage(

          //       fit: BoxFit.cover,
          //       placeholder: (context, url) => commonAnimationWidget(
          //         context: context,
          //         isTextNeeded: false,
          //       ),
          //       imageUrl: message.message ?? '',
          //     ),
          //   ),
          // ),
        ),
        message.name != null
            ? captionWidget(
                message: message.name!,
                commonProvider: commonProvider,
                context: context,
                messageModel: message,
              )
            : zeroMeasureWidget
      ],
    ),
  );
}

Widget videoMessageShowWidget({
  required MessageModel message,
  required ChatModel? chatModel,
  required BuildContext context,
  required String receiverID,
  required final Map<String, VideoPlayerController> videoControllers,
  required bool isGroup,required bool mounted,
  GroupModel? groupModel,
}) {
  final commonProvider = Provider.of<CommonProvider>(context, listen: true);
  return SizedBox(
    height: null,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            if (await CommonDBFunctions.checkAssetExists(message.message!)) {
              if (mounted) {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssetShowPage(
                    isGroup: isGroup,
                    groupModel: groupModel,
                    receiverID: receiverID,
                    messageType: MessageType.video,
                    chatID: chatModel?.chatID ?? '',
                    controllers: videoControllers,
                    message: message,
                  ),
                ),
              );
              }
            } else {
              if (mounted) {
                simpleDialogBox(
                context: context,
                title: "Can't play video, it is deleted",
                buttonText: "Ok",
                onPressed: () {
                  Navigator.pop(context);
                },
              );
              }
            }
          },
          child: Stack(
            children: [
              SizedBox(
                height: 260.h,
                child: VideoPlayer(
                  videoControllers[message.message!]!,
                ),
              ),
              Positioned(
                bottom: 3,
                left: 5,
                child: TextWidgetCommon(
                  text: DateProvider.parseDuration(
                    videoControllers[message.message!]!
                        .value
                        .duration
                        .toString(),
                  ),
                  textColor: kWhite,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                top: (260.h / 2) - (60.sp / 2),
                left: (MediaQuery.of(context).size.width / 2) - (160.sp / 2),
                child: CircleAvatar(
                  radius: 30.sp,
                  backgroundColor: iconGreyColor.withOpacity(0.5),
                  child: Icon(
                    !videoControllers[message.message!]!.value.isPlaying
                        ? Icons.play_arrow_rounded
                        : Icons.pause,
                    size: 30.sp,
                    color: kBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
        message.name != null
            ? message.name!.isNotEmpty
                ? Flexible(
                    child: captionWidget(
                      message: message.name!,
                      commonProvider: commonProvider,
                      context: context,
                      messageModel: message,
                    ),
                  )
                : zeroMeasureWidget
            : zeroMeasureWidget
      ],
    ),
  );
}

Widget readMoreTextWidget({
  required CommonProvider commonProvider,
  required String message,
  required MessageModel messageModel,
}) {
  return TextWidgetCommon(
    fontSize: 16.sp,
    maxLines:
       messageModel.messageId!=null? !commonProvider.isExpandedMessage(messageModel.messageId!) ? 30 : null:null,
    text: message ?? '',
    textColor: kWhite,
  );
}

Widget captionWidget({
  required String message,
  required CommonProvider commonProvider,
  required BuildContext context,
  required MessageModel messageModel,
}) {
  return message.isNotEmpty
      ? Padding(
          padding: EdgeInsets.symmetric(
              vertical: message.isEmpty ? 0 : 10, horizontal: 0),
          child: Column(
            children: [
              readMoreTextWidget(
                commonProvider: commonProvider,
                message: message,
                messageModel: messageModel,
              ),
              messageModel.name != null && messageModel.name!.length > 1000
                  ? readMoreButton(
                      context: context,
                      commonProvider: commonProvider,
                      fontSize: 16,
                      isInMessageList: true,
                      messageID: messageModel.messageId)
                  : zeroMeasureWidget,
            ],
          ),
        )
      : zeroMeasureWidget;
}
