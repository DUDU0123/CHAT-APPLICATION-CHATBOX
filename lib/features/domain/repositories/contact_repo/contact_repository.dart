import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';

abstract class ContactRepository{
  Future<List<ContactModel>> getAccessToUserContacts({required BuildContext context});
}