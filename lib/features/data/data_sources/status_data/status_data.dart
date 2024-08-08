import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
import 'package:official_chatbox_application/features/data/models/status_model/status_model.dart';
import 'package:official_chatbox_application/features/data/models/status_model/uploaded_status_model.dart';
import 'package:rxdart/rxdart.dart';

class StatusData {
  final FirebaseFirestore firebaseFireStore;
  final FirebaseAuth fireBaseAuth;
  final FirebaseStorage fireBaseStorage;
  StatusData({
    required this.firebaseFireStore,
    required this.fireBaseAuth,
    required this.fireBaseStorage,
  });

  Future<String?> uploadToStorage({
    required StatusModel statusModel,
    required File? file,
  }) async {
    final String statusFileUrl;
    if (file != null) {
      statusFileUrl = await CommonDBFunctions.saveUserFileToDataBaseStorage(
        ref: "user_statuses/${statusModel.statusId}",
        file: file,
      );
      return statusFileUrl;
    }
    return null;
  }

  // method to upload a status
  Future<bool> uploadStatus({required StatusModel statusModel}) async {
    try {
      final currentUser = firebaseAuth.currentUser?.uid;
      if (currentUser == null) {
        log("No current user found.");
        return false;
      }
      log("Uploading status !!!!!!!!!!!!*(IIIOUIUO)");
      // Save the status model to Firestore
      if (statusModel.statusId == null) {
        final statusDocumentReference = await fireStore
            .collection(usersCollection)
            .doc(firebaseAuth.currentUser?.uid)
            .collection(statusCollection)
            .add(statusModel.toJson()
              ..[dbStatusModelTimeStamp] = FieldValue.serverTimestamp());
        statusModel = statusModel.copyWith(
          statusId: statusDocumentReference.id,
        );
        await statusDocumentReference.update(statusModel.toJson());
      } else {
        await fireStore
            .collection(usersCollection)
            .doc(firebaseAuth.currentUser?.uid)
            .collection(statusCollection)
            .doc(statusModel.statusId)
            .update(statusModel.toJson());
      }
      log("Uploaded status !!!!!!!!!!!!*(IIIOUIUO)");
      return true;
    } on FirebaseException catch (e) {
      log("Firebase Auth exception on upload status: ${e.message}");
      return false;
    } catch (e, stackTrace) {
      log("Error while uploading status: $e", stackTrace: stackTrace);
      return false;
    }
  }

  Stream<List<StatusModel>>? getAllStatus() {
    try {
      final currentUser = firebaseAuth.currentUser?.uid;
      if (currentUser == null) {
        log("No current user found.");
        return null;
      }

      // Fetch the contacts of the current user
      final contactsStream = firebaseFireStore
          .collection(usersCollection)
          .doc(currentUser)
          .collection(contactsCollection)
          .snapshots()
          .map((contactsSnapshot) {
        // Get the list of contact IDs
        return contactsSnapshot.docs.map((doc) => doc.id).toList();
      });
      // Combine the contacts stream with status streams
      return contactsStream.switchMap((contactIds) {
        // Create a stream for each contact's status
        final statusStreams = contactIds.map((contactId) {
          return firebaseFireStore
              .collection(usersCollection)
              .doc(contactId)
              .collection(statusCollection)
              .snapshots()
              .map((statusSnapShot) {
            return statusSnapShot.docs
                .map(
                  (statusDoc) => StatusModel.fromJson(
                    map: statusDoc.data(),
                  ),
                )
                .toList();
          });
        }).toList();

        // Combine the streams into one
        return CombineLatestStream.list(statusStreams).map((statusLists) {
          // Flatten the list of lists into a single list
          return statusLists.expand((statusList) => statusList).toList();
        });
      });
    } on FirebaseException catch (e) {
      log("Firebase Auth exception on get status: ${e.message}");
      return null;
    } catch (e, stackTrace) {
      log("Error while getting status: $e", stackTrace: stackTrace);
      return null;
    }
  }

  // method to delete a status
  Future<bool> deleteStatus(
      {required String statusModelId, required String uploadedStatusId}) async {
    final currentUser = firebaseAuth.currentUser?.uid;
    try {
      if (currentUser == null) {
        log("No current user found.");
        return false;
      }
      final statusDocRef = FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(currentUser)
          .collection(statusCollection)
          .doc(statusModelId);
      final docSnapshot = await statusDocRef.get();
      if (!docSnapshot.exists) {
        log("StatusModel document not found.");
        return false;
      }
      final statusModel =
          StatusModel.fromJson(map: docSnapshot.data() as Map<String, dynamic>);
      final updatedStatusList = statusModel.statusList
          ?.where((status) => status.uploadedStatusId != uploadedStatusId)
          .toList();
      if (updatedStatusList == null) {
        log("No statuses found in statusList.");
        return false;
      }
      // Update the StatusModel with the new statusList
      final updatedStatusModel = statusModel.copyWith(
        statusList: updatedStatusList,
      );

      await statusDocRef.update(updatedStatusModel.toJson());
      return true;
    } on FirebaseException catch (e) {
      log("Firebase Auth exception on deleting status: ${e.message}");
      return false;
    } catch (e, stackTrace) {
      log("Error while deleting status: $e", stackTrace: stackTrace);
      return false;
    }
  }

  Future<void> updateStatusViewersList({
    required StatusModel statusModel,
    required UploadedStatusModel uploadedStatusModel,
    required String viewerId,
  }) async {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      final statusDocRef = await firebaseFireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(statusCollection)
          .doc(statusModel.statusId)
          .get();

      if (statusDocRef.exists) {
        // Deserialize the StatusModel
        final data = statusDocRef.data() as Map<String, dynamic>;
        final fetchedStatusModel = StatusModel.fromJson(map: data);

        // Find the specific UploadedStatusModel and update its viewer list
        final updatedStatusList =
            fetchedStatusModel.statusList?.map((uploadedStatus) {
          if (uploadedStatus.uploadedStatusId ==
              uploadedStatusModel.uploadedStatusId) {
            final updatedViewersList =
                List<String>.from(uploadedStatus.viewers ?? []);
            if (!updatedViewersList.contains(viewerId)) {
              updatedViewersList.add(viewerId);
            }
            return uploadedStatus.copyWith(viewers: updatedViewersList);
          }
          return uploadedStatus;
        }).toList();

        final updatedStatusModel =
            fetchedStatusModel.copyWith(statusList: updatedStatusList);

        await firebaseFireStore
            .collection(usersCollection)
            .doc(currentUserId)
            .collection(statusCollection)
            .doc(statusModel.statusId)
            .update(updatedStatusModel.toJson());
      }
    } on FirebaseException catch (e) {
      log("Firebase Auth exception on updating status viewers list: ${e.message}");
    } catch (e, stackTrace) {
      log("Error while updating status viewers list: $e",
          stackTrace: stackTrace);
    }
  }
}
