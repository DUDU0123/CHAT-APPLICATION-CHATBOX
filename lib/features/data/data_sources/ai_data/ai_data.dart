import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/core/enums/enums.dart';
import 'package:official_chatbox_application/core/service/dialog_helper.dart';
import 'package:official_chatbox_application/features/data/models/message_model/message_model.dart';

class AIData {
  final FirebaseFirestore firebaseFirestore;

  AIData({
    required this.firebaseFirestore,
  });

  final senderID = FirebaseAuth.instance.currentUser?.uid;
  final boxAIId = 'boxAI1234';
  Gemini gemini = Gemini.instance;

  Future<bool> sendMessageInAIChat({
    required String messageText,
  }) async {
    try {
      // Create message model for user's message
      MessageModel userMessage = MessageModel(
        isDeletedMessage: false,
        isEditedMessage: false,
        isPinnedMessage: false,
        message: messageText,
        messageType: MessageType.text,
        messageStatus: MessageStatus.read,
        messageTime: DateTime.now().toString(),
        receiverID: boxAIId,
        senderID: senderID,
      );
      // Save user's message to Firestore
      final userMessageDoc = await firebaseFirestore
          .collection(usersCollection)
          .doc(senderID)
          .collection(aiChatMessagesCollection)
          .add(userMessage.toJson());
      final docId = userMessageDoc.id;
      final updatedUserMessageModel = userMessage.copyWith(
        messageId: docId,
      );
      await firebaseFirestore
          .collection(usersCollection)
          .doc(senderID)
          .collection(aiChatMessagesCollection)
          .doc(docId)
          .update(updatedUserMessageModel.toJson());
      // Send the message to the AI and get a response
      final String aiResponse = await getAIResponse(messageText);
      // Create message model for AI's response
      MessageModel aiMessageModel = MessageModel(
        isDeletedMessage: false,
        isEditedMessage: false,
        isPinnedMessage: false,
        message: aiResponse,
        messageType: MessageType.text,
        messageStatus: MessageStatus.read,
        messageTime: DateTime.now().toString(),
        receiverID: senderID,
        senderID: boxAIId,
      );
      final aiMessageDoc = await firebaseFirestore
          .collection(usersCollection)
          .doc(senderID)
          .collection(aiChatMessagesCollection)
          .add(aiMessageModel.toJson());

      final aiDocId = aiMessageDoc.id;
      final updateAIMessageModel = aiMessageModel.copyWith(
        messageId: aiDocId,
      );
      await firebaseFirestore
          .collection(usersCollection)
          .doc(senderID)
          .collection(aiChatMessagesCollection)
          .doc(aiDocId)
          .update(updateAIMessageModel.toJson());
      return true;
    } on FirebaseException catch (e) {
      log("Chat AI messaging Firebase error: ${e.message}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
      return false;
    }on SocketException catch (e) {
      DialogHelper.showDialogMethod(
        title: "Network Error",
        contentText: "Please check your network connection",
      );
      return false;
    } catch (e) {
      DialogHelper.showSnackBar(
          title: "Error Occured", contentText: e.toString());
      return false;
    }
  }

  Future<String> getAIResponse(String message) async {
    try {
      final completer = Completer<String>();
      String geminiResponseMessage = '';

      gemini.streamGenerateContent(message).listen(
        (data) {
          // Accumulate response parts
          geminiResponseMessage += data.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              '';

          log(geminiResponseMessage.toString());
        },
        onError: (error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
        onDone: () {
          // Complete the completer with the accumulated response
          geminiResponseMessage = geminiResponseMessage.replaceAll('*', '');
          if (!completer.isCompleted) {
            completer.complete(geminiResponseMessage);
          }
        },
      );

      // Await the full response before returning it
      return await completer.future;
    } catch (e) {
      log("Error getting AI response: $e");
      return "Sorry, I couldn't understand that.";
    }
  }

  Stream<List<MessageModel>>? getAllAIChatMessages() {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      return fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(aiChatMessagesCollection)
          .orderBy(
            dbMessageSendTime,
            descending: false,
          )
          .snapshots()
          .map((snapData) {
        return snapData.docs
            .map((doc) => MessageModel.fromJson(map: doc.data()))
            .toList();
      });
    } on FirebaseException catch (e) {
      log("Chat AI get message Firebase error: ${e.message}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
      return null;
    }on SocketException catch (e) {
      DialogHelper.showDialogMethod(
        title: "Network Error",
        contentText: "Please check your network connection",
      );
    } catch (e) {
      DialogHelper.showSnackBar(
          title: "Error Occured", contentText: e.toString());
      return null;
    }
  }

  Future<bool> deleteMessage({
    required String messageId,
  }) async {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      await fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(aiChatMessagesCollection)
          .doc(messageId)
          .delete();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
      return false;
    }on SocketException catch (e) {
      DialogHelper.showDialogMethod(
        title: "Network Error",
        contentText: "Please check your network connection",
      );
      return false;
    } catch (e) {
      DialogHelper.showSnackBar(
          title: "Error Occured", contentText: e.toString());
      return true;
    }
  }

  Future<bool> clearChat() async {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      final messagesSnapshot = await fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(aiChatMessagesCollection)
          .get();
      for (var messageDoc in messagesSnapshot.docs) {
        await messageDoc.reference.delete();
      }
      return true;
    } on FirebaseException catch (e) {
      log("Chat AI clear chat Firebase error: ${e.message}");
      if (e.code == 'unavailable') {
        DialogHelper.showDialogMethod(
          title: "Network Error",
          contentText: "Please check your network connection",
        );
      }
      return false;
    }on SocketException catch (e) {
      DialogHelper.showDialogMethod(
        title: "Network Error",
        contentText: "Please check your network connection",
      );
      return false;
    } catch (e) {
      log("Chat AI clear chat error: $e");
      DialogHelper.showSnackBar(
          title: "Error Occured", contentText: e.toString());
      return false;
    }
  }
}
