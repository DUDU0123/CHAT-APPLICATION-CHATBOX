import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:official_chatbox_application/features/data/models/payment_model/payment_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/payment_repo/payment_repository.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<FutureOr<void>> transactionInitiateEvent(
      TransactionInitiateEvent event, Emitter<PaymentState> emit) async {
    try {
     final url = 'upi://pay?pa=${event.upiId}&pn=${event.receiverName}&am=${event.amountToPay}&tn=ChatBoxPayment';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      PaymentModel paymentModel = PaymentModel(
        amountSended: event.amountToPay.toString(),
        paymentReceiverName: event.receiverName,
        paymentReceiverProfilePhoto: event.profilePhoto,
        paymentReceiverContactNumber: event.contactNumber,
      );
      add(AddPaymentOnDBEvent(paymentModel: paymentModel));
    } else {
      emit(const PaymentErrorState(errorMessage: 'Unable to make payment'));
    }
    } catch (e) {
      emit(PaymentErrorState(errorMessage: e.toString()));
    }
  }
}
