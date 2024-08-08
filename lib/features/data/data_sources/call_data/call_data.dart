import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/data/models/call_model/call_model.dart';

class CallData {
  final FirebaseFirestore firebaseFirestore;
  CallData({
    required this.firebaseFirestore,
  });

  Future<void> saveCallInfo({required CallModel callModel}) async {
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
    } on FirebaseException catch (e) {
      log("Firebase Error on save call ${e.message}");
    } catch (e) {
      log("Error on save call ${e.toString()}");
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
    } catch (e) {
      log("Error on save call ${e.toString()}");
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
      return null;
    } catch (e) {
      log("Error on get call logs ${e.toString()}");
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
      log("Firebase Error on delete call log ${e.message}");
      return false;
    } catch (e) {
      log("Error on get delete call log ${e.toString()}");
      return false;
    }
  }

  
}
