import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String? id;
  final String? transactionID;
  final String? amountSended;
  final String? paymentReceiverName;
  final String? paymentReceiverProfilePhoto;
  final String? paymentReceiverContactNumber;
  const PaymentEntity({
    this.id,
    this.transactionID,
    this.paymentReceiverName,
    this.paymentReceiverProfilePhoto,
    this.amountSended,
    this.paymentReceiverContactNumber,
  });

  @override
  List<Object?> get props {
    return [
      id,
      transactionID,
      amountSended,
      paymentReceiverName,
      paymentReceiverProfilePhoto,
      paymentReceiverContactNumber,
    ];
  }
}
