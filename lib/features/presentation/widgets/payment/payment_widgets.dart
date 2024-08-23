// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
// import 'package:official_chatbox_application/features/presentation/bloc/payment/payment_bloc.dart';
// import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
// import 'package:upi_india/upi_app.dart';

// Widget displayUpiApps({
//   required String upiId,
//   required double amountToPay,
//   required String receiverName,
// }) {
//   return BlocBuilder<PaymentBloc, PaymentState>(
//     builder: (context, state) {
//       if (state.upiApps == null) {
//         return emptyShowWidget(
//             context: context, text: "No Upi Apps found on device");
//       }
//       if (state.upiApps!.isEmpty) {
//         return emptyShowWidget(
//             context: context, text: "No Upi Apps found on device");
//       }
//       return Wrap(
//         children: state.upiApps!.map<Widget>((UpiApp app) {
//           return GestureDetector(
//             onTap: () {
//               context.read<PaymentBloc>().add(
//                     TransactionInitiateEvent(
//                       upiId: upiId,
//                       app: app,
//                       amountToPay: amountToPay,
//                       receiverName: receiverName,
//                     ),
//                   );
//             },
//             child: SizedBox(
//               height: 100,
//               width: 100,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.memory(
//                     app.icon,
//                     width: 60,
//                     height: 60,
//                   ),
//                   TextWidgetCommon(
//                     text: app.name,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       );
//     },
//   );
// }
// displayTransactionData({
//   required String title,
//   required String body,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8),
//     child: Row(
//       children: [
//         TextWidgetCommon(
//           text: "$title: ",
//         ),
//         Flexible(
//           child: TextWidgetCommon(
//             text: body,
//           ),
//         ),
//       ],
//     ),
//   );
// }
