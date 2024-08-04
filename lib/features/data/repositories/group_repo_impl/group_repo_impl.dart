import 'dart:io';
import 'package:official_chatbox_application/features/data/data_sources/group_data/group_data.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/group_repo/group_repository.dart';

class GroupRepoImpl extends GroupRepository {
  final GroupData groupData;
  GroupRepoImpl({
    required this.groupData,
  });

  @override
  Future<bool?> createGroup(
      {required GroupModel newGroupData, required File? groupImageFile}) async {
    return await groupData.createNewGroup(
      newGroupData: newGroupData,
      groupImageFile: groupImageFile,
    );
  }

  @override
  Stream<List<GroupModel>>? getAllGroups() {
    return groupData.getAllGroups();
  }

  @override
  Future<bool> updateGroupData({required GroupModel updatedGroupData, required File? groupImageFile,}) async {
    return await groupData.updateGroupData(updatedGroupModel: updatedGroupData, groupImageFile: groupImageFile,);
  }

  @override
  Future<String> deleteAGroupOnlyForCurrentUser(
      {required String groupID}) async {
    return await groupData.deleteAgroupFromGroupsCurrentUser(groupID: groupID);
  }
  
  @override
  Future<void> groupClearChatMethod({required String groupID}) async{
    await groupData.clearGroupChat(groupID: groupID);
  }
}
