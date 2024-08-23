// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:official_chatbox_application/core/constants/colors.dart';
// import 'package:official_chatbox_application/core/constants/height_width.dart';
// import 'package:official_chatbox_application/core/utils/common_db_functions.dart';
// import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
// import 'package:official_chatbox_application/features/data/models/payment_model/payment_model.dart';
// import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';
// import 'package:official_chatbox_application/features/presentation/bloc/payment/payment_bloc.dart';
// import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
// import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

// class PaymentHistoryPage extends StatelessWidget {
//   const PaymentHistoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const TextWidgetCommon(text: "Payment History"),
//       ),
//       body: BlocBuilder<PaymentBloc, PaymentState>(
//         builder: (context, state) {
//           if (state is PaymentErrorState) {
//             emptyShowWidget(context: context, text: state.errorMessage);
//           }
//           if (state is GetAllPaymentHistoryState) {
//             return StreamBuilder<List<PaymentModel>>(
//                 stream: state.paymentHistoryList,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return commonAnimationWidget(
//                       context: context,
//                       isTextNeeded: false,
//                     );
//                   }
//                   if (!snapshot.hasData ||
//                       snapshot.data == null ||
//                       snapshot.hasError) {
//                     return emptyShowWidget(
//                       context: context,
//                       text: "No payments done",
//                     );
//                   }

//                   return ListView.separated(
//                     padding: EdgeInsets.symmetric(vertical: 10.h),
//                     itemCount: 10,
//                     separatorBuilder: (context, index) => kHeight10,
//                     itemBuilder: (context, index) {
//                       final PaymentModel paymentModel = snapshot.data![index];
//                       return StreamBuilder<UserModel?>(
//                           stream: paymentModel.receiverID != null
//                               ? CommonDBFunctions
//                                   .getOneUserDataFromDataBaseAsStream(
//                                       userId: paymentModel.receiverID!)
//                               : null,
//                           builder: (context, snapshot) {
//                             final UserModel? receiver = snapshot.data;
//                             if (receiver == null) {
//                               return zeroMeasureWidget;
//                             }
//                             return ListTile(
//                               leading: buildProfileImage(
//                                 userProfileImage: receiver.userProfileImage,
//                                 context: context,
//                               ),
//                               title: TextWidgetCommon(
//                                 text: receiver.contactName ??
//                                     receiver.phoneNumber ??
//                                     '',
//                               ),
//                               trailing: TextWidgetCommon(
//                                 text: "\u20B9${paymentModel.amountSended}",
//                                 textColor: iconGreyColor,
//                                 fontSize: 16.sp,
//                               ),
//                             );
//                           });
//                     },
//                   );
//                 });
//           }
//           return emptyShowWidget(
//             context: context,
//             text: "No Payments done",
//           );
//         },
//       ),
//     );
//   }
// }
