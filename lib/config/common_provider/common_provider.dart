import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';

class CommonProvider extends ChangeNotifier {
  bool isExpanded = false;
  bool isEmptyList = false;
  String appStorage = '';
  double deviceFreeStorage = 0.0;
  bool isEmojiPickerOpened = false;
  void setEmojiPickerStatus(){
    isEmojiPickerOpened =!isEmojiPickerOpened;
    notifyListeners();
  }
  void setStorage({required int storage}) {
    appStorage = (storage ~/ (1024 * 1024)).toString();
    notifyListeners();
  }

  void setDeviceFreeStorage({required double deviceFreeSpace}) {
    deviceFreeStorage = deviceFreeSpace;
    notifyListeners();
  }

  MessageModel? replyMessage;
  Set<String> expandedMessages = {};
  void setReplyMessage({required MessageModel replyMsg}) {
    replyMessage = replyMsg;
    notifyListeners();
  }

  void cancelReply() {
    replyMessage = null;
    notifyListeners();
  }

  void changeIsEmpty() {
    isEmptyList = !isEmptyList;
    notifyListeners();
  }

  void changeExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  void toggleExpand({required String messageID}) {
    if (expandedMessages.contains(messageID)) {
      expandedMessages.remove(messageID);
    } else {
      expandedMessages.add(messageID);
    }
    notifyListeners();
  }

  bool isExpandedMessage(String messageId) {
    return expandedMessages.contains(messageId);
  }
}
