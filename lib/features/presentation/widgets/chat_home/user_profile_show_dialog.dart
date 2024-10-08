import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_info_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/photo_view_section.dart';

Future<void> userProfileShowDialog({
  required String? userProfileImage,
  required BuildContext context,
   ChatModel? chatModel,
   GroupModel? groupModel,
   String? userName,
   bool? isGroup,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.sp),
      ),
      backgroundColor: kTransparent,
      content: GestureDetector(
        onTap: () {
          userProfileImage != null
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PhotoViewSection(imageToShow: userProfileImage),
                  ),
                )
              : null;
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.sp)),
          height: 200.h,
          // width: 200.w,
          child: userProfileImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.sp),
                  child: Image.network(
                    userProfileImage,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 40.sp,
                ),
        ),
      ),
      actions: [
        Container(
          color: kBlack,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              commonSvgIconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomPage(
                        userName: userName??'',
                        isGroup: isGroup??false,
                        chatModel: chatModel,
                        groupModel: groupModel,
                      ),
                    ),
                  );
                },
                iconName: chatsIcon,
              ),
              commonSvgIconButton(
                onPressed: () async {
                  UserModel? recieverData;
                  if (chatModel != null) {
                    recieverData =
                        await CommonDBFunctions.getOneUserDataFromDBFuture(
                            userId: chatModel.receiverID);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatInfoPage(
                        rootContext: context,
                        isGroup: isGroup??false,
                        chatModel: chatModel,
                        groupData: groupModel,
                        receiverContactName: recieverData?.contactName,
                        receiverData: recieverData,
                      ),
                    ),
                  );
                },
                iconName: info,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

IconButton commonSvgIconButton({
  required String iconName,
  Color? iconColor,
  required void Function()? onPressed,
}) {
  return IconButton(
    onPressed: onPressed,
    icon: SvgPicture.asset(
      iconName,
      width: 30.w,
      height: 30.w,
      colorFilter: ColorFilter.mode(
        iconColor ?? buttonSmallTextColor,
        BlendMode.srcIn,
      ),
    ),
  );
}
