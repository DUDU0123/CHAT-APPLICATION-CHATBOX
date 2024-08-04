import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_gradient_tile_widget.dart';

Widget buildMemberPermissionSwitch({
  required BuildContext context,
  required String title,
  required MembersGroupPermission permission,
  required GroupState state,
  required PageTypeEnum? pageType,
  required GroupModel? groupModel,
}) {
  return CommonGradientTileWidget(
    trailing: Switch(
      value: state.memberPermissions[permission] ?? false,
      onChanged: (value) {
        context.read<GroupBloc>().add(UpdateMemberPermissionEvent(
              groupModel: groupModel,
              pageTypeEnum: pageType ?? PageTypeEnum.groupDetailsAddPage,
              permission: permission,
              isEnabled: value,
            ));
      },
    ),
    isSwitchTile: true,
    rootContext: context,
    isSmallTitle: false,
    title: title,
  );
}

Widget buildAdminPermissionSwitch({
  required BuildContext context,
  required String title,
  required AdminsGroupPermission permission,
  required GroupState state,
  required PageTypeEnum? pageType,
  required GroupModel? groupModel,
}) {
  return CommonGradientTileWidget(
    trailing: Switch(
      value: state.adminPermissions[permission] ?? false,
      onChanged: (value) {
        context.read<GroupBloc>().add(UpdateAdminPermissionEvent(
              groupModel: groupModel,
              pageTypeEnum: pageType ?? PageTypeEnum.groupDetailsAddPage,
              permission: permission,
              isEnabled: value,
            ));
      },
    ),
    rootContext: context,
    isSmallTitle: false,
    title: title,
  );
}
