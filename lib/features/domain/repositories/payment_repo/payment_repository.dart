import 'package:official_chatbox_application/features/data/models/payment_model/payment_model.dart';

abstract class PaymentRepository{
  Stream<List<PaymentModel>>? getAllPaymentHistory();
  Future<bool> addToPaymentHistory({
    required PaymentModel paymentModel,
  });
}