part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class CreateANewChatEvent extends ChatEvent {
  final String recieverContactName;
  final String receiverId;
  // final ContactModel contactModel;
  const CreateANewChatEvent({
    required this.recieverContactName,
    required this.receiverId,
  });
  @override
  List<Object> get props => [
        receiverId,
        recieverContactName,
      ];
}

class GetAllChatsEvent extends ChatEvent {}

class DeletAChatEvent extends ChatEvent {
  final ChatModel? chatModel;
  const DeletAChatEvent({
    required this.chatModel,
  });
  @override
  List<Object> get props => [
        chatModel ?? const ChatModel(),
      ];
}
class ClearChatEvent extends ChatEvent {
  final String chatId;
  const ClearChatEvent({
    required this.chatId,
  });
  @override
  List<Object> get props => [chatId];
}

class PickImageEvent extends ChatEvent {
  final File? pickedFile;
  const PickImageEvent({
    this.pickedFile,
  });
  @override
  List<Object> get props => [pickedFile ?? File('')];
}

class ClearAllChatsEvent extends ChatEvent {}

class ChatUpdateEvent extends ChatEvent {
  final ChatModel chatModel;
  const ChatUpdateEvent({
    required this.chatModel,
  });
  @override
  List<Object> get props => [chatModel];
}

class ReportAccountEvent extends ChatEvent {
  final ReportModel reportModel;
  final BuildContext context;
  const ReportAccountEvent({
    required this.reportModel,
    required this.context,
  });
  @override
  List<Object> get props => [
        reportModel,
      ];
}

class CheckIsBlockedUserEvent extends ChatEvent {
  final String? currentUserId;
  final String? receiverID;
  const CheckIsBlockedUserEvent({
    required this.currentUserId,
    required this.receiverID,
  });
  @override
  List<Object> get props => [
        currentUserId??'',
        receiverID??"",
      ];
}
