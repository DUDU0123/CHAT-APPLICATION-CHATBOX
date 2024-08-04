part of 'contact_bloc.dart';

class ContactState extends Equatable {
  List<ContactModel>? contactList;
  final List<ContactModel>? selectedContactList;
  ContactState({this.contactList, this.selectedContactList = const [],});

  @override
  List<Object> get props => [contactList??[], selectedContactList??[]];
}

class ContactInitial extends ContactState {
  ContactInitial() : super(contactList: []);
}

class ContactsLoadingState extends ContactState {

  ContactsLoadingState() : super(contactList: []);
}

class ContactsErrorState extends ContactState {
  final String message;
  ContactsErrorState({
    required this.message,
  }) : super(contactList: []);
  @override
  List<Object> get props => [message,];
}
