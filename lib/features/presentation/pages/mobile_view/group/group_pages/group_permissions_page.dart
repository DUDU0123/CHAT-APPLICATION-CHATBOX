import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/group_permission_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
class GroupPermissionsPage extends StatelessWidget {
  const GroupPermissionsPage({
    super.key,
    this.pageType = PageTypeEnum.groupDetailsAddPage,
    this.groupModel,
  });
  final PageTypeEnum? pageType;
  final GroupModel? groupModel;
  @override
  Widget build(BuildContext context) {
    if (pageType == PageTypeEnum.groupInfoPage && groupModel != null) {
      context.read<GroupBloc>().add(LoadGroupPermissionsEvent(
          groupModel: groupModel!, pageTypeEnum: pageType!));
    } else {
      context.read<GroupBloc>().add(LoadGroupPermissionsEvent(
          groupModel: const GroupModel(), pageTypeEnum: pageType!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Group Permission"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallGreyMediumBoldTextWidget(
                  text: "Members can:",
                ),
                kHeight10,
                buildMemberPermissionSwitch(
                  context: context,
                  groupModel: groupModel,
                  pageType: pageType,
                  state: state,
                  title: "Edit group settings",
                  permission: MembersGroupPermission.editGroupSettings,
                ),
                kHeight10,
                buildMemberPermissionSwitch(
                  context: context,
                  groupModel: groupModel,
                  pageType: pageType,
                  state: state,
                  title: "Send messages",
                  permission: MembersGroupPermission.sendMessages,
                ),
                kHeight10,
                buildMemberPermissionSwitch(
                  context: context,
                  groupModel: groupModel,
                  pageType: pageType,
                  state: state,
                  title: "Add members",
                  permission: MembersGroupPermission.addMembers,
                ),
                kHeight20,
                smallGreyMediumBoldTextWidget(
                  text: "Only Admins can:",
                ),
                kHeight10,
                buildAdminPermissionSwitch(
                  context: context,
                  groupModel: groupModel,
                  pageType: pageType,
                  state: state,
                  title: "Approve members",
                  permission: AdminsGroupPermission.approveMembers,
                ),
                kHeight10,
                buildAdminPermissionSwitch(
                  context: context,
                  groupModel: groupModel,
                  pageType: pageType,
                  state: state,
                  title: "View members",
                  permission: AdminsGroupPermission.viewMembers,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}