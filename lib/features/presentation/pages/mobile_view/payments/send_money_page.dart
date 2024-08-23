// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:official_chatbox_application/core/constants/colors.dart';
// import 'package:official_chatbox_application/core/constants/height_width.dart';
// import 'package:official_chatbox_application/core/utils/snackbar.dart';
// import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
// import 'package:official_chatbox_application/features/presentation/bloc/payment/payment_bloc.dart';
// import 'package:official_chatbox_application/features/presentation/pages/mobile_view/payments/upi_pay_page.dart';
// import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
// import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
// import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
// import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';

// class SendMoneyPage extends StatefulWidget {
//   const SendMoneyPage({
//     super.key,
//     required this.contact,
//   });
//   final ContactModel contact;

//   @override
//   State<SendMoneyPage> createState() => _SendMoneyPageState();
// }

// class _SendMoneyPageState extends State<SendMoneyPage> {
//   TextEditingController amountController = TextEditingController();
//   TextEditingController upiIdController = TextEditingController();

//   @override
//   void dispose() {
//     amountController.dispose();
//     upiIdController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 40.h),
//         child: Column(
//           children: [
//             widget.contact.userProfilePhotoOnChatBox != null
//                 ? userProfileImageShowWidget(
//                     context: context,
//                     imageUrl: widget.contact.userProfilePhotoOnChatBox!)
//                 : nullImageReplaceWidget(containerRadius: 50, context: context),
//             TextWidgetCommon(
//               text:
//                   "Send money to ${widget.contact.userContactName ?? widget.contact.userContactNumber}",
//               fontWeight: FontWeight.bold,
//               fontSize: 20.sp,
//             ),
//             kHeight20,
//             textFieldSendMoney(
//               enabled: false,
//               context: context,
//               controller: TextEditingController(
//                   text:
//                       "${widget.contact.userContactName ?? widget.contact.userContactNumber}"),
//               keyboardType: TextInputType.text,
//             ),
//             kHeight10,
//             textFieldSendMoney(
//               context: context,
//               controller: upiIdController,
//               hintText: "Enter UPI ID",
//               keyboardType: TextInputType.text,
//             ),
//             kHeight10,
//             textFieldSendMoney(
//               context: context,
//               controller: amountController,
//               hintText: "Enter amount",
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           if (upiIdController.text.isNotEmpty) {
//             if (amountController.text.isNotEmpty) {
//               int amount = int.parse(amountController.text);
//               if (amount <= 20000) {
//                 context.read<PaymentBloc>().add(TransactionInitiateEvent(
//                     upiId: upiIdController.text,
//                     amountToPay: double.parse(amount.toString()),
//                     receiverName: widget.contact.userContactName ??
//                         widget.contact.userContactNumber ??
//                         ""));
//                 // context.read<PaymentBloc>().add(GetAllUpiAppsEvent());
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) => UpiPage(
//                 //       upiId: upiIdController.text,
//                 //       amountToPay: double.parse(amount.toString()),
//                 //       receiverName: widget.contact.userContactName ??
//                 //           widget.contact.userContactNumber!,
//                 //     ),
//                 //   ),
//                 // );
//               } else {
//                 commonSnackBarWidget(
//                     context: context, contentText: "Amount exceeded");
//               }
//             } else {
//               commonSnackBarWidget(
//                   context: context, contentText: "Please enter an amount");
//             }
//           } else {
//             commonSnackBarWidget(context: context, contentText: "Enter upi id");
//           }
//         },
//         label: const TextWidgetCommon(
//           text: "Done",
//         ),
//       ),
//     );
//   }

//   Widget textFieldSendMoney({
//     bool? enabled = true,
//     required BuildContext context,
//     required TextEditingController controller,
//     TextInputType? keyboardType,
//     String? hintText,
//   }) {
//     return TextFieldCommon(
//       enabled: enabled ?? true,
//       hintText: hintText,
//       keyboardType: keyboardType ?? TextInputType.text,
//       style: TextStyle(
//         color: Theme.of(context).colorScheme.onPrimary,
//         fontSize: 18.sp,
//         fontWeight: FontWeight.w500,
//       ),
//       textAlign: TextAlign.center,
//       controller: controller,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.sp),
//         borderSide: BorderSide(
//           color: buttonSmallTextColor,
//         ),
//       ),
//     );
//   }
// }
