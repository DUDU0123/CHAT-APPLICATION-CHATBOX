import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/domain/entities/payment_entity/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    super.id,
    super.transactionID,
    super.paymentReceiverProfilePhoto,
    super.paymentReceiverContactNumber,
    super.amountSended,
    super.paymentReceiverName,
  });

  factory PaymentModel.fromJson({
    required Map<String, dynamic> map,
  }) {
    return PaymentModel(
      id: map[paymentDBId] as String?,
      transactionID: map[paymentTransactionDBId] as String?,
      amountSended: map[paymentDBAmountSended] as String?,
      paymentReceiverName: map[paymentReceiverDBName] as String?,
      paymentReceiverProfilePhoto: map[paymentReceiverDBProfilePhoto] as String?,
      paymentReceiverContactNumber: map[paymentReceiverDBContactNumber] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      paymentDBId: id,
      paymentTransactionDBId: transactionID,
      paymentDBAmountSended: amountSended,
      paymentReceiverDBName: paymentReceiverName,
      paymentReceiverDBProfilePhoto: paymentReceiverProfilePhoto,
      paymentReceiverDBContactNumber: paymentReceiverContactNumber,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? transactionID,
    String? amountSended,
    String? paymentReceiverName,
    String? paymentReceiverProfilePhoto,
    String? paymentReceiverContactNumber,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      transactionID: transactionID ?? this.transactionID,
      paymentReceiverContactNumber: paymentReceiverContactNumber ?? this.paymentReceiverContactNumber,
      paymentReceiverProfilePhoto: paymentReceiverProfilePhoto ?? this.paymentReceiverProfilePhoto,
      amountSended: amountSended ?? this.amountSended,
      paymentReceiverName: paymentReceiverName ?? this.paymentReceiverName
    );
  }
}