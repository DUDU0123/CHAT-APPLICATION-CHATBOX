// import 'dart:developer';
// import 'package:official_chatbox_application/features/data/models/payment_model/payment_model.dart';
// import 'package:upi_india/upi_india.dart';

// class PaymentMethods {
//   static Future<UpiResponse> initiateTransaction({
//     required UpiApp app,
//     required UpiIndia upiIndia,
//     required String upiId,
//     required String receiverName,
//     required double amountToPay,
//   }) async {
//     return upiIndia.startTransaction(
//       app: app,
//       receiverUpiId: upiId,
//       receiverName: receiverName,
//       transactionRefId: 'TestingUpiIndiaPlugin',
//       transactionNote: 'ChatBox Payment',
//       amount: amountToPay,
//     );
//   }

//   static upiErrorHandler({required snapshot}) {
//     if (snapshot.hasError) {
//       switch (snapshot.error.runtimeType) {
//         case UpiIndiaAppNotInstalledException:
//           print("Requested app not installed on device");
//           break;
//         case UpiIndiaUserCancelledException:
//           print("You cancelled the transaction");
//           break;
//         case UpiIndiaNullResponseException:
//           print("Requested app didn't return any response");
//           break;
//         case UpiIndiaInvalidParametersException:
//           print("Requested app cannot handle the transaction");
//           break;
//         default:
//           print("An Unknown error has occurred");
//           break;
//       }
//     }
//   }

//   static void checkStatus(String status) {
//     switch (status) {
//       case UpiPaymentStatus.SUCCESS:
//         // PaymentModel(
//         //   amountSended: amountSended,
//         //   receiverName: receiverName,
//         //   receiverProfileImage: re
//         // );
//         log("Success");
//         break;
//       case UpiPaymentStatus.SUBMITTED:
//         log("Submitted");
//         break;
//       case UpiPaymentStatus.FAILURE:
//         log("Failure");
//         break;
//       default:
//         log("Nothing happened");
//     }
//   }
// }
