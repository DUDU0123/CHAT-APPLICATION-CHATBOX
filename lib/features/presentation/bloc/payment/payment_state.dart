part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  const PaymentState(
    // {
    // this.upiApps,
    // this.upiResponse,
  
  // }
  );
  // final List<UpiApp>? upiApps;
  // final TransactionDetailModel? upiResponse;
  // PaymentState copyWith({
  //   // List<UpiApp>? upiApps,
  //   // TransactionDetailModel? upiResponse,
  // }) {
  //   return PaymentState(
  //     // upiApps: upiApps ?? this.upiApps,
  //     // upiResponse: upiResponse ?? this.upiResponse,
  //   );
  // }

  @override
  List<Object> get props => [
        // upiApps ?? [],
        // upiResponse ??
      ];
}

class PaymentInitial extends PaymentState {}

class GetAllPaymentHistoryState extends PaymentState {
  final Stream<List<PaymentModel>>? paymentHistoryList;
  const GetAllPaymentHistoryState({
    this.paymentHistoryList,
  });
}

class PaymentLoadingState extends PaymentState {}

class PaymentErrorState extends PaymentState {
  final String errorMessage;
  const PaymentErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [
        errorMessage,
      ];
}
