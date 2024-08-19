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



