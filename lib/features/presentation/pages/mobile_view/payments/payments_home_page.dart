import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:official_chatbox_application/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentsHomePage extends StatelessWidget {
  const PaymentsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<ContactBloc>().state.contactList?.length == 0 ||
        context.watch<ContactBloc>().state.contactList?.length == null) {
      context.read<ContactBloc>().add(GetContactsEvent());
    }
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Payments"),
      ),
      body: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state.contactList == null) {
            return emptyShowWidget(context: context, text: "No contacts");
          }
          if (state.contactList!.isEmpty) {
            return emptyShowWidget(context: context, text: "No contacts");
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: smallGreyMediumBoldTextWidget(text: "Send money to: "),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: state.contactList!.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendMoneyPage(
                              contact: state.contactList![index],
                            ),
                          ));
                    },
                    leading: buildProfileImage(
                      userProfileImage:
                          state.contactList![index].userProfilePhotoOnChatBox,
                      context: context,
                    ),
                    title: TextWidgetCommon(
                      text: state.contactList![index].userContactName ?? "",
                    ),
                  ),
                  separatorBuilder: (context, index) => kHeight10,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({
    super.key,
    required this.contact,
  });
  final ContactModel contact;

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  late Razorpay razorPay;
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    super.dispose();
    razorPay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Enter amount"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 40.h),
        child: Column(
          children: [
            widget.contact.userProfilePhotoOnChatBox != null
                ? userProfileImageShowWidget(
                    context: context,
                    imageUrl: widget.contact.userProfilePhotoOnChatBox!)
                : nullImageReplaceWidget(containerRadius: 50, context: context),
            TextWidgetCommon(
              text:
                  "Send money to ${widget.contact.userContactName ?? widget.contact.userContactNumber}",
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
            kHeight20,
            TextFieldCommon(
              hintText: "Enter amount",
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              controller: amountController,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(
                  color: buttonSmallTextColor,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (amountController.text.isNotEmpty) {
             int amount = int.parse(amountController.text);
            if (amount <= 20000) {
              openCheckOut(
                contactModel: widget.contact,
                amountToSend: amount,
                razorPay: razorPay,
                context: context,
              );
            } else {
              commonSnackBarWidget(
                  context: context, contentText: "Amount exceeded");
            }
          } else {
            commonSnackBarWidget(
                context: context, contentText: "Please enter an amount");
          }
        },
        label: const TextWidgetCommon(
          text: "Done",
        ),
      ),
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    commonSnackBarWidget(context: context, contentText: "Payment Successful: ${response.paymentId}");
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    commonSnackBarWidget(context: context, contentText: "Payment Unsuccessful: ${response.message}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    commonSnackBarWidget(context: context, contentText: "Payment Wallet selected: ${response.walletName}");
  }
}

void openCheckOut({
  required ContactModel contactModel,
  required int amountToSend,
  required Razorpay razorPay,
  required BuildContext context,
}) {
  var options = {
    'key': 'rzp_test_pA3bxMDyEvDSbu',
    'amount': amountToSend * 100,
    'name': contactModel.userContactName,
    'description': 'Payment to ${contactModel.userContactName}',
    'prefill': {
      'contact': contactModel.userContactNumber,
      'email': 'test@razorpay.com',
    },
  };
  try {
    razorPay.open(options);
  } catch (e) {
    commonSnackBarWidget(context: context, contentText: "Error occured: $e");
  }
}
