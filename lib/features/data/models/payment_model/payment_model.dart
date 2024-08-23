import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/domain/entities/payment_entity/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    super.id,
    super.transactionID,
    super.receiverID,
    super.amountSended,
  });

  factory PaymentModel.fromJson({
    required Map<String, dynamic> map,
  }) {
    return PaymentModel(
      id: map[paymentDBId] as String?,
      transactionID: map[paymentTransactionId] as String?,
      amountSended: map[paymentAmountSended] as String?,
      receiverID: map[paymentReceiverId] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      paymentDBId: id,
      paymentTransactionId: transactionID,
      paymentAmountSended: amountSended,
      paymentReceiverId: receiverID,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? transactionID,
    String? receiverID,
    String? amountSended,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      transactionID: transactionID ?? this.transactionID,
      receiverID: receiverID ?? this.receiverID,
      amountSended: amountSended ?? this.amountSended,
    );
  }
}