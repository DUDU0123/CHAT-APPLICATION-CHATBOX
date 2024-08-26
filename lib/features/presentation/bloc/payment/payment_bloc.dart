import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/features/data/models/payment_model/payment_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/payment_repo/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;
  PaymentBloc({
    required this.paymentRepository,
  }) : super(PaymentInitial()) {
    on<GetAllPaymentHistoryEvent>(getAllPaymentHistoryEvent);
    on<AddPaymentOnDBEvent>(addPaymentOnDBEvent);
    on<TransactionInitiateEvent>(transactionInitiateEvent);
  }

  FutureOr<void> getAllPaymentHistoryEvent(
      GetAllPaymentHistoryEvent event, Emitter<PaymentState> emit) {
    try {
      final paymentHistoryList = paymentRepository.getAllPaymentHistory();
      emit(GetAllPaymentHistoryState(paymentHistoryList: paymentHistoryList));
    } catch (e) {
      emit(PaymentErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> addPaymentOnDBEvent(
      AddPaymentOnDBEvent event, Emitter<PaymentState> emit) async {
    try {
      final value = await paymentRepository.addToPaymentHistory(
          paymentModel: event.paymentModel);
      if (value) {
        add(GetAllPaymentHistoryEvent());
      } else {
        emit(const PaymentErrorState(
            errorMessage: 'Unable to add payment history'));
      }
    } catch (e) {
      emit(PaymentErrorState(errorMessage: e.toString()));
    }
  }

  // FutureOr<void> getAllUpiAppsEvent(
  //     GetAllUpiAppsEvent event, Emitter<PaymentState> emit) async {
  //   try {
  //     final List<UpiApp> upiApps =
  //         await upiIndia.getAllUpiApps(mandatoryTransactionId: false);
  //     emit(state.copyWith(upiApps: upiApps));
  //   } catch (e) {
  //     emit(PaymentErrorState(errorMessage: e.toString()));
  //   }
  // }

  Future<FutureOr<void>> transactionInitiateEvent(
      TransactionInitiateEvent event, Emitter<PaymentState> emit) async {
    try {
    } catch (e) {
      emit(PaymentErrorState(errorMessage: e.toString()));
    }
  }
}
