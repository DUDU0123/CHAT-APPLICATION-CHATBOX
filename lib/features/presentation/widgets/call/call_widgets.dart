import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';

void callLogDeleteActionMethod({
  required BuildContext context,
  required CallModel callModel,
}) {
  return normalDialogBoxWidget(
    context: context,
    title: "Delete call log",
    subtitle: "Do you want to delete this call log?",
    onPressed: () {
      callModel.callId != null
          ? context.read<CallBloc>().add(
                DeleteACallLogEvent(
                  callId: callModel.callId!,
                ),
              )
          : null;
      Navigator.pop(context);
    },
    actionButtonName: "Delete",
  );
}

Widget recentCallTextWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 25.w,
      vertical: 5.h,
    ),
    child: smallGreyMediumBoldTextWidget(text: "Recent calls"),
  );
}

Widget getTimeOfCallDoneWidget(CallModel callModel) {
  return TextWidgetCommon(
    text: TimeProvider.getRelativeTime(callModel.callStartTime!),
    fontSize: 10.sp,
    textColor: iconGreyColor,
  );
}

Widget callTrailingIconWidget(CallModel callModel, BuildContext context) {
  return SvgPicture.asset(
    callModel.callType == CallType.audio ? call : videoCall,
    width: 26.w,
    height: 26.h,
    colorFilter: ColorFilter.mode(
      Theme.of(context).colorScheme.onPrimary,
      BlendMode.srcIn,
    ),
  );
}
Widget callTileSubTitleWidget(CallModel callModel) {
    return Row(
      children: [
        Transform.rotate(
          angle: pi / 180 * -40,
          child: Icon(
            callModel.callerId == firebaseAuth.currentUser?.uid
                ? Icons.arrow_forward_outlined
                : Icons.arrow_back_outlined,
            color: callModel.callStatus != null
                ? callModel.callStatus == 'not_accepted'
                    ? kRed
                    : kGreen
                : kRed,
            size: 16.sp,
          ),
        ),
        getTimeOfCallDoneWidget(callModel)
      ],
    );
  }

  