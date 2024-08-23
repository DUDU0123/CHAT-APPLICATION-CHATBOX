import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/payment_methods.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/payment/payment_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/payment/payment_widgets.dart';

class UpiPage extends StatefulWidget {
  final String upiId;
  final double amountToPay;
  final String receiverName;
  const UpiPage({
    super.key,
    required this.upiId,
    required this.amountToPay,
    required this.receiverName,
  });

  @override
  State<UpiPage> createState() => _UpiPageState();
}

class _UpiPageState extends State<UpiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Send using"),
      ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: displayUpiApps(
      //         amountToPay: widget.amountToPay,
      //         receiverName: widget.receiverName,
      //         upiId: widget.upiId,
      //       ),
      //     ),
      //     Expanded(
      //       child: BlocBuilder<PaymentBloc, PaymentState>(
      //         builder: (context, state) {
      //           return FutureBuilder(
      //             future: state.upiResponse,
      //             builder: (context, snapshot) {
      //               if (snapshot.hasError || snapshot.data == null) {
      //                 return emptyShowWidget(
      //                   text: snapshot.error.toString(),
      //                   context: context,
      //                 );
      //               }
      //               // UpiResponse upiResponse = snapshot.data!;
      //               // String transactionId = upiResponse.transactionId ?? 'N/A';
      //               // String resCode = upiResponse.responseCode ?? 'N/A';
      //               // String transactionRef =
      //               //     upiResponse.transactionRefId ?? 'N/A';
      //               // String status = upiResponse.status ?? 'N/A';
      //               // String approvalRef = upiResponse.approvalRefNo ?? 'N/A';
      //               // PaymentMethods.checkStatus(status);
      //               // return Padding(
      //               //   padding: const EdgeInsets.all(8),
      //               //   child: Column(
      //               //     mainAxisAlignment: MainAxisAlignment.center,
      //               //     children: [
      //               //       displayTransactionData(
      //               //         title: 'transaction id',
      //               //         body: transactionId,
      //               //       ),
      //               //       displayTransactionData(
      //               //         title: 'transaction ref',
      //               //         body: transactionRef,
      //               //       ),
      //               //       displayTransactionData(
      //               //         title: 'transaction rescode',
      //               //         body: resCode,
      //               //       ),
      //               //       displayTransactionData(
      //               //         title: 'transaction status',
      //               //         body: status,
      //               //       ),
      //               //       displayTransactionData(
      //               //         title: 'transaction approval ref',
      //               //         body: approvalRef,
      //               //       ),
      //               //     ],
      //               //   ),
      //               // );
      //               return zeroMeasureWidget;
      //             },
      //           );
      //         },
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
