import 'dart:io';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';

abstract class GroupRepository {
  Future<bool?> createGroup(
      {required GroupModel newGroupData, required File? groupImageFile});
  Stream<List<GroupModel>>? getAllGroups();
  Future<bool> updateGroupData({
    required GroupModel updatedGroupData,
    required File? groupImageFile,
  });
  Future<String> deleteAGroupOnlyForCurrentUser({
    required String groupID,
  });
  Future<void> groupClearChatMethod({required String groupID});
}
