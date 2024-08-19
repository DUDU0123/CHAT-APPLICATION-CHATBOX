import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String? id;
  final String? transactionID;
  final String? receiverName;
  final String? recieverPhoneNumber;
  final String? amountSended;
  final String? receiverProfileImage;
  const PaymentEntity({
    this.id,
    this.transactionID,
    this.receiverName,
    this.recieverPhoneNumber,
    this.amountSended,
    this.receiverProfileImage,
  });

  @override
  List<Object?> get props {
    return [
      id,
      transactionID,
      receiverName,
      recieverPhoneNumber,
      amountSended,
      receiverProfileImage,
    ];
  }
}
