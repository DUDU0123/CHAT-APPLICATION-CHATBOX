import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/box_ai/boxai_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/ai_chat_room/inner_pages/ai_chat_info_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme/theme_manager.dart';

Widget aiRoomBg({
  required BuildContext context,
}) {
  return SizedBox(
    width: screenWidth(context: context),
    height: screenHeight(context: context),
    child: Image.asset(
      fit: BoxFit.cover,
      Provider.of<ThemeManager>(context).isDark ? bgImage : bgImage,
    ),
  );
}

PopupMenuButton<dynamic> appBarActions() {
  return PopupMenuButton(
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
  );
}

Widget aiAppBarTitle({
  required BuildContext context,
  required ThemeData theme,
}) {
  return Row(
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
  );
}

Widget boxAITitle({double? fontSize}) {
  return TextWidgetCommon(
    overflow: TextOverflow.ellipsis,
    text: "BOX AI",
    fontWeight: FontWeight.bold,
    fontSize: fontSize ?? 20.sp,
  );
}

Widget imageContainer({
  required double size,
}) {
  return Container(
    height: size.h,
    width: size.w,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(appLogo),
          fit: BoxFit.cover,
        )),
  );
}
