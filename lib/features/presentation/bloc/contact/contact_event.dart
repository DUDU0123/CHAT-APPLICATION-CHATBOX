part of 'contact_bloc.dart';

sealed class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

class GetContactsEvent extends ContactEvent {
  final BuildContext context;
  const GetContactsEvent({
    required this.context,
  });
  @override
  List<Object> get props => [context];
}

class SelectUserEvent extends ContactEvent {
  final ContactModel contact;
  const SelectUserEvent({
    required this.contact,
  });
   @override
  List<Object> get props => [contact];
}

class ClearListEvent extends ContactEvent{}