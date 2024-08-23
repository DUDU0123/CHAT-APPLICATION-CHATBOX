import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String? id;
  final String? transactionID;
  final String? amountSended;
  final String? receiverID;
  const PaymentEntity({
    this.id,
    this.transactionID,
    this.receiverID,
    this.amountSended,
  });

  @override
  List<Object?> get props {
    return [
      id,
      transactionID,
      amountSended,
      receiverID,
    ];
  }
}
