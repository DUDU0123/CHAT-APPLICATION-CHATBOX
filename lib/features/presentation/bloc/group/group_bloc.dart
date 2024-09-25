import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/group_repo/group_repository.dart';
import 'package:official_chatbox_application/main.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;
  GroupBloc({
    required this.groupRepository,
  }) : super(GroupInitial()) {
    on<GetAllGroupsEvent>(getAllGroupsEvent);
    on<CreateGroupEvent>(createGroupEvent);
    on<UpdateGroupEvent>(updateGroupEvent);
    on<ClearGroupChatEvent>(clearGroupChatEvent);
    on<DeleteGroupEvent>(deleteGroupEvent);
    on<GroupImagePickEvent>(groupImagePickEvent);
    on<RemoveOrExitFromGroupEvent>(removeOrExitFromGroupEvent);
    on<UpdateMemberPermissionEvent>(updateMemberPermissionEvent);
    on<UpdateAdminPermissionEvent>(updateAdminPermissionEvent);
    on<LoadGroupPermissionsEvent>(loadGroupPermissionsEvent);
  }

  FutureOr<void> getAllGroupsEvent(
      GetAllGroupsEvent event, Emitter<GroupState> emit) {
    emit(state.copyWith(isLoading: true));
    try {
      Stream<List<GroupModel>>? groupList = groupRepository.getAllGroups();
      emit(GroupState(
        groupList: groupList,
        isLoading: false,
        message: null,
      ));
    } catch (e) {
      emit(state.copyWith(message: e.toString(), isLoading: false));
    }
  }

  Future<FutureOr<void>> createGroupEvent(
      CreateGroupEvent event, Emitter<GroupState> emit) async {
    
    try {
      final File? groupImageFile = event.groupProfileImage;
      emit(state.copyWith(isLoading: true));
      final value = await groupRepository.createGroup(
        groupImageFile: groupImageFile,
        newGroupData: event.newGroupData,
      );
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);
      emit(state.copyWith(
        groupList: state.groupList,
        value: value,
        isLoading: false,
        message: null,
      ));
    } catch (e) {
      emit(state.copyWith(message: e.toString(), isLoading: false));
    }
  }

  Future<FutureOr<void>> updateGroupEvent(
      UpdateGroupEvent event, Emitter<GroupState> emit) async {
    try {
      final File? groupImageFile = event.groupProfileImage;
      final value = await groupRepository.updateGroupData(
        groupImageFile: groupImageFile,
        updatedGroupData: event.updatedGroupData,
      );
      emit(state.copyWith(
        groupList: state.groupList,
        isLoading: false,
        message: null,
      ));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  Future<FutureOr<void>> deleteGroupEvent(
      DeleteGroupEvent event, Emitter<GroupState> emit) async {
    try {
      final value = await groupRepository.deleteAGroupOnlyForCurrentUser(
        groupID: event.groupID,
      );
      emit(state.copyWith(
        groupList: state.groupList,
        isLoading: false,
        message: null,
      ));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  FutureOr<void> updateMemberPermissionEvent(
      UpdateMemberPermissionEvent event, Emitter<GroupState> emit) {
    final updatedPermissions =
        Map<MembersGroupPermission, bool>.from(state.memberPermissions)
          ..[event.permission] = event.isEnabled;
    if (event.pageTypeEnum == PageTypeEnum.groupInfoPage) {
      final enabledPermissions = updatedPermissions.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      final updatedGroupData =
          event.groupModel?.copyWith(membersPermissions: enabledPermissions);
      if (updatedGroupData != null) {
        add(UpdateGroupEvent(updatedGroupData: updatedGroupData));
      }
      emit(
        state.copyWith(memberPermissions: updatedPermissions),
      );
    }
    emit(
      state.copyWith(memberPermissions: updatedPermissions),
    );
  }

  FutureOr<void> updateAdminPermissionEvent(
      UpdateAdminPermissionEvent event, Emitter<GroupState> emit) {
    final updatedPermissions =
        Map<AdminsGroupPermission, bool>.from(state.adminPermissions)
          ..[event.permission] = event.isEnabled;
    if (event.pageTypeEnum == PageTypeEnum.groupInfoPage) {
      final enabledPermissions = updatedPermissions.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      final updatedGroupData =
          event.groupModel?.copyWith(adminsPermissions: enabledPermissions);
      if (updatedGroupData != null) {
        add(UpdateGroupEvent(updatedGroupData: updatedGroupData));
      }
      emit(state.copyWith(adminPermissions: updatedPermissions));
    }
    emit(state.copyWith(adminPermissions: updatedPermissions));
  }

  FutureOr<void> groupImagePickEvent(
      GroupImagePickEvent event, Emitter<GroupState> emit) async {
    try {
      emit(state.copyWith(
        groupList: state.groupList,
        groupPickedImageFile: event.pickedFile,
        message: null,
      ));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  FutureOr<void> loadGroupPermissionsEvent(
      LoadGroupPermissionsEvent event, Emitter<GroupState> emit) {
    if (event.pageTypeEnum == PageTypeEnum.groupInfoPage) {
      final Map<MembersGroupPermission, bool> initialMemberPermissions = {
        for (var permission in MembersGroupPermission.values)
          permission:
              event.groupModel.membersPermissions?.contains(permission) ??
                  false,
      };

      final Map<AdminsGroupPermission, bool> initialAdminPermissions = {
        for (var permission in AdminsGroupPermission.values)
          permission:
              event.groupModel.adminsPermissions?.contains(permission) ?? false,
      };

      emit(state.copyWith(
        memberPermissions: initialMemberPermissions,
        adminPermissions: initialAdminPermissions,
      ));
    } else {
      emit(state.copyWith(
        memberPermissions: {},
        adminPermissions: {},
      ));
    }
  }

  Future<FutureOr<void>> clearGroupChatEvent(
      ClearGroupChatEvent event, Emitter<GroupState> emit) async {
    try {
      await groupRepository.groupClearChatMethod(groupID: event.groupID);
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  Future<FutureOr<void>> removeOrExitFromGroupEvent(
      RemoveOrExitFromGroupEvent event, Emitter<GroupState> emit) async {
    try {
      await groupRepository.removeOrExitFromGroupMethod(
        oldGroupModel: event.oldGroupModel,
        updatedGroupModel: event.updatedGroupData,
      );
      emit(
        state.copyWith(
          groupList: state.groupList,
          adminPermissions: state.adminPermissions,
          groupPickedImageFile: state.groupPickedImageFile,
          memberPermissions: state.memberPermissions,
          isLoading: false,
          message: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }
}
