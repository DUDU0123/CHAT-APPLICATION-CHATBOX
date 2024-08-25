import 'dart:io';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:official_chatbox_application/core/service/dialog_helper.dart';

class ContactData {
  Future<List<Contact>> getContactsInUserDevice() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        return FlutterContacts.getContacts(withProperties: true);
      }else{
        return [];
      }
    }on SocketException catch (e) {
      DialogHelper.showDialogMethod(title: "Netwok Error", contentText: "$e");
      return [];
    } on HttpException catch (e) {
      DialogHelper.showDialogMethod(title: "Invalid response", contentText: "$e");
      return [];
    } on FormatException catch (e) {
      DialogHelper.showDialogMethod(title: "Invalid Fromat", contentText: "$e");
      return [];
    } catch (e) {
      DialogHelper.showDialogMethod(title: "Error", contentText: "$e");
      return [];
    }
  }
}