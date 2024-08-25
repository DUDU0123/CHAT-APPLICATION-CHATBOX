import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/service/dialog_helper.dart';
import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:provider/provider.dart';

class CallData {
  final FirebaseFirestore firebaseFirestore;
  CallData({
    required this.firebaseFirestore,
  });

  Future<void> saveCallInfo({required CallModel callModel, required BuildContext context,}) async {
    try {
      final callersId = [
        firebaseAuth.currentUser?.uid,
        ...callModel.callrecieversId!
      ];
      final callId = firebaseFirestore.collection(usersCollection).doc().id;

      // Add callId to callModel
      final updatedCallModel = callModel.copyWith(callId: callId);

      for (var callerId in callersId) {
        await firebaseFirestore
            .collection(usersCollection)
            .doc(callerId)
            .collection(callsCollection)
            .doc(callId)
            .set(updatedCallModel.toJson());
      }
      log("Callers Id: $callersId, Call ID: $callId");
      Provider.of<CallBloc>(context, listen: false).add(
            GetCurrentCallIdAndCallersId(
              callId: callId,
              callersId: callersId,
            ),
          );
    } on FirebaseException catch (e) {
      log("Firebase Error on save call ${e.message}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    } on SocketException catch (e) {
      DialogHelper.showDialogMethod(
        title: "Network Error",
        contentText: "Please check your network connection",
      );
    } catch (e) {
      log("Error on save call ${e.toString()}");
      DialogHelper.showSnackBar(
          title: "Error Occured", contentText: e.toString());
    }
  }

  Future<void> updateCallInfo({required CallModel callModel}) async {
    try {
      if (callModel.callrecieversId != null) {
        for (var callerId in callModel.callrecieversId!) {
          await firebaseFirestore
              .collection(usersCollection)
              .doc(callerId)
              .collection(callsCollection)
              .doc(callModel.callId)
              .set(callModel.toJson());
        }
      }
    } on FirebaseException catch (e) {
      log("Firebase Error on save call ${e.message}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
    } on SocketException catch (e) {
      DialogHelper.showDialogMethod(
        title: "Network Error",
        contentText: "Please check your network connection",
      );
    } catch (e) {
      log("Error on save call ${e.toString()}");
      DialogHelper.showSnackBar(
          title: "Error Occured", contentText: e.toString());
    }
  }

  Stream<List<CallModel>>? getAllCallLogs() {
    try {
      final currentUser = firebaseAuth.currentUser;
      return firebaseFirestore
          .collection(usersCollection)
          .doc(currentUser?.uid)
          .collection(callsCollection)
          .orderBy(dbCallStartTime, descending: true)
          .snapshots()
          .map((callSnapShot) {
        return callSnapShot.docs
            .map((callDoc) => CallModel.fromJson(map: callDoc.data()))
            .toList();
      });
    } on FirebaseException catch (e) {
      log("Firebase Error on get call logs ${e.message}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
      return null;
    } on SocketException catch (e) {
      DialogHelper.showDialogMethod(
        title: "Network Error",
        contentText: "Please check your network connection",
      );
    } catch (e) {
      log("Error on get call logs ${e.toString()}");
      DialogHelper.showSnackBar(
          title: "Error Occured", contentText: e.toString());
      return null;
    }
  }

  Future<bool> deleteOneCallInfo({required String callModelId}) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      await firebaseFirestore
          .collection(usersCollection)
          .doc(currentUser?.uid)
          .collection(callsCollection)
          .doc(callModelId)
          .delete();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
      return false;
    } on SocketException catch (e) {
      DialogHelper.showDialogMethod(
        title: "Network Error",
        contentText: "Please check your network connection",
      );
      return false;
    } catch (e) {
      log("Error on get delete call log ${e.toString()}");
      DialogHelper.showSnackBar(
          title: "Error Occured", contentText: e.toString());
      return false;
    }
  }
}
