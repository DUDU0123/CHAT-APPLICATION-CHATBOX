import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/core/utils/date_provider.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/uploaded_status_model.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/status/status_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/status/status_appbar.dart';

StreamBuilder<UserModel?> statusAppBarShowWidget({
  required int currentIndex,
  required String? statusUploaderId,
  required bool isCurrentUser,
  required List<UploadedStatusModel>? statusList,
  required StatusModel statusModel,
}) {
  return StreamBuilder<UserModel?>(
      stream: statusUploaderId != null
          ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
              userId: statusUploaderId)
          : null,
      builder: (context, snapshot) {
        return statusAppBar(
          isCurrentUser: isCurrentUser,
          context: context,
          statusUploaderImage: snapshot.data?.userProfileImage,
          userName: statusUploaderId == firebaseAuth.currentUser?.uid
              ? "My status"
              : snapshot.data?.contactName ?? snapshot.data?.userName ?? '',
          howHours: statusList != null
              ? TimeProvider.getRelativeTime(
                  statusList[currentIndex].statusUploadedTime.toString())
              : '',
          deleteMethod: () {
            final uploadedStatusId = statusList?[currentIndex].uploadedStatusId;
            statusModel.statusId != null
                ? uploadedStatusId != null
                    ? context.read<StatusBloc>().add(StatusDeleteEvent(
                          statusModelId: statusModel.statusId!,
                          uploadedStatusId: uploadedStatusId,
                        ))
                    : null
                : null;
            // Remove the deleted status from the list
            statusList!.removeAt(currentIndex);
            Navigator.pop(context);
          },
          shareMethod: () {
            Navigator.pop(context);
            statusList != null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectContactPage(
                        isGroup: false,
                        pageType: PageTypeEnum.toSendPage,
                        uploadedStatusModel: statusList[currentIndex],
                        statusModel: statusModel,
                        uploadedStatusModelID: statusModel
                            .statusList![currentIndex].uploadedStatusId,
                      ),
                    ))
                : null;
          },
        );
      });
}
