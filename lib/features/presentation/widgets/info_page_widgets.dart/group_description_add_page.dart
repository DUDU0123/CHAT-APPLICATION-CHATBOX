
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class GroupDescriptionAddPage extends StatelessWidget {
  GroupDescriptionAddPage({super.key, required this.groupModel});
  TextEditingController groupDescriptionController = TextEditingController();
  final GroupModel groupModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidgetCommon(
          text: "Add Description",
          textColor: Theme.of(context).colorScheme.onPrimary,
          fontSize: 20.sp,
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: screenWidth(context: context),
          height: screenHeight(context: context) / 2.5,
          child: StreamBuilder<GroupModel?>(
              stream: groupModel.groupID != null
                  ? CommonDBFunctions.getOneGroupDataByStream(
                      userID: firebaseAuth.currentUser!.uid,
                      groupID: groupModel.groupID!,
                    )
                  : null,
              builder: (context, snapshot) {
                snapshot.data?.groupDescription != null
                    ? groupDescriptionController.text =
                        snapshot.data!.groupDescription!
                    : "";
                return TextFieldCommon(
                  hintText: "Enter description",
                  maxLines: 20,
                  controller: groupDescriptionController,
                  textAlign: TextAlign.start,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: buttonSmallTextColor,
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: lightLinearGradientColorTwo,
        onPressed: () {
          final updatedGroupData = groupModel.copyWith(
            groupDescription: groupDescriptionController.text,
          );
          context
              .read<GroupBloc>()
              .add(UpdateGroupEvent(updatedGroupData: updatedGroupData));
          Navigator.pop(context);
        },
        label: TextWidgetCommon(
          text: "Save",
          textColor: kWhite,
        ),
      ),
    );
  }
}
