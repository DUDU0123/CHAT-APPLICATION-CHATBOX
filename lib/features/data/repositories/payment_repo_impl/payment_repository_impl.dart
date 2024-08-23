import 'package:official_chatbox_application/features/data/data_sources/payment_data/payment_data.dart';
import 'package:official_chatbox_application/features/data/models/payment_model/payment_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/payment_repo/payment_repository.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final PaymentData paymentData;
  PaymentRepositoryImpl({
    required this.paymentData,
  });
  @override
  Future<bool> addToPaymentHistory({required PaymentModel paymentModel}) {
    return paymentData.addToPaymentHistory(paymentModel: paymentModel);
  }

  @override
  Stream<List<PaymentModel>>? getAllPaymentHistory() {
    return paymentData.getAllPaymentHistory();
  }
}
