import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/data/models/payment_model/payment_model.dart';

class PaymentData {
  final FirebaseFirestore firebaseFirestore;
  PaymentData({
    required this.firebaseFirestore,
  });
  Stream<List<PaymentModel>>? getAllPaymentHistory() {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      return firebaseFirestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(paymentHistoryCollection)
          .snapshots()
          .map((paymentHistorySnapshot) {
        return paymentHistorySnapshot.docs
            .map(
              (paymentHistoryDoc) => PaymentModel.fromJson(
                map: paymentHistoryDoc.data(),
              ),
            )
            .toList();
      });
    } on FirebaseException catch (e) {
      log("Payment history get firebase error: ${e.message}");
      return null;
    } catch (e) {
      log("Payment history get error: ${e.toString()}");
      return null;
    }
  }

  Future<bool> addToPaymentHistory({
    required PaymentModel paymentModel,
  }) async {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      final paymentDocRef = await fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(paymentHistoryCollection)
          .add(paymentModel.toJson());

      final paymentDocId = paymentDocRef.id;

      final updatedPaymentModel = paymentModel.copyWith(
        id: paymentDocId,
      );

      await fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(paymentHistoryCollection)
          .doc(paymentDocId)
          .update(
            updatedPaymentModel.toJson(),
          );
      return true;
    } on FirebaseException catch (e) {
      log("Payment history add firebase error: ${e.message}");
      return false;
    } catch (e) {
      log("Payment history add error: $e");
      return false;
    }
  }
}
