import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/domain/entities/payment_entity/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    super.id,
    super.transactionID,
    super.receiverName,
    super.receiverProfileImage,
    super.recieverPhoneNumber,
    super.amountSended,
  });

  factory PaymentModel.fromJson({
    required Map<String, dynamic> map,
  }) {
    return PaymentModel(
      id: map[paymentDBId] as String?,
      transactionID: map[paymentTransactionId] as String?,
      receiverName: map[paymentReceiverName] as String?,
      recieverPhoneNumber: map[paymentReceiverPhoneNumber] as String?,
      amountSended: map[paymentAmountSended] as String?,
      receiverProfileImage: map[paymentReceiverProfileImage] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      paymentDBId: id,
      paymentTransactionId: transactionID,
      paymentReceiverName: receiverName,
      paymentReceiverPhoneNumber: recieverPhoneNumber,
      paymentAmountSended: amountSended,
      paymentReceiverProfileImage: receiverProfileImage,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? transactionID,
    String? receiverName,
    String? recieverPhoneNumber,
    String? amountSended,
    String? receiverProfileImage,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      transactionID: transactionID ?? this.transactionID,
      receiverName: receiverName ?? this.receiverName,
      recieverPhoneNumber: recieverPhoneNumber ?? this.recieverPhoneNumber,
      amountSended: amountSended ?? this.amountSended,
      receiverProfileImage: receiverProfileImage ?? this.receiverProfileImage,
    );
  }
}