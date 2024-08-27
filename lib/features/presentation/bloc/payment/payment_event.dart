part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class GetAllPaymentHistoryEvent extends PaymentEvent {}

class GetAllUpiAppsEvent extends PaymentEvent {}

class AddPaymentOnDBEvent extends PaymentEvent {
  final PaymentModel paymentModel;
  const AddPaymentOnDBEvent({
    required this.paymentModel,
  });
  @override
  List<Object> get props => [
        paymentModel,
      ];
}

class TransactionInitiateEvent extends PaymentEvent {
  final String upiId;
  final String amountToPay;
  final String receiverName;
  final String? profilePhoto;
  final String? contactNumber;
  const TransactionInitiateEvent({
    required this.upiId,
    required this.amountToPay,
    required this.receiverName,
    required this.profilePhoto,
    required this.contactNumber,
  });
  @override
  List<Object> get props => [
        upiId,
        amountToPay,
        receiverName,
        contactNumber??'',
        profilePhoto??'',
      ];
}
