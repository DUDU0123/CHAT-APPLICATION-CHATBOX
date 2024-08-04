import 'package:flutter_contacts/flutter_contacts.dart';

class ContactData {
  Future<List<Contact>> getContactsInUserDevice() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        return FlutterContacts.getContacts(withProperties: true);
      }else{
        throw Exception("Error occured while requesting permission");
      }
    } catch (e) {
      throw Exception("Error occured on request contact persmission $e");
    }
  }
}