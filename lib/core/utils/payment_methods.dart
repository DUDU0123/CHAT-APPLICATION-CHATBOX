import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/service_keys/razorpay_key.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentMethods {
  static void openCheckOut({
  required ContactModel contactModel,
  required int amountToSend,
  required Razorpay razorPay,
  required BuildContext context,
}) {
  var options = {
    'key': RazorPayFields.razorpayKey,
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
}
