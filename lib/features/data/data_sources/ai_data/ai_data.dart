// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
// import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
// import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';

// const aiChatsCollection = 'ai_chats_collection';

// class AIData {
//   final FirebaseFirestore firebaseFirestore;
//   AIData({
//     required this.firebaseFirestore,
//   });

//   createAIChat({
//     required ChatModel chatModel,
//   }) async {
//     final currentUserId = firebaseAuth.currentUser?.uid;
//     ChatModel chatModel = ChatModel(
//       chatID: ,
//       receiverProfileImage: ,
//       receiverID: ,
//       receiverName: ,
//       senderID: currentUserId,
//     );
//     await firebaseFirestore
//         .collection(usersCollection)
//         .doc(firebaseAuth.currentUser?.uid)
//         .collection(aiChatsCollection)
//         .add(chatModel.toJson());
//   }
// }
