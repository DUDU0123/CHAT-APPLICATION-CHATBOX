import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/data/models/contact_model/contact_model.dart';
import 'package:official_chatbox_application/features/domain/repositories/contact_repo/contact_repository.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository contactRepository;
  ContactBloc({required this.contactRepository}) : super(ContactInitial()) {
    on<GetContactsEvent>(getContactsEvent);
    on<SelectUserEvent>(selectUserEvent);
    on<ClearListEvent>(clearListEvent);
  }

  Future<FutureOr<void>> getContactsEvent(
      GetContactsEvent event, Emitter<ContactState> emit) async {
    emit(ContactsLoadingState());
    try {
      log("Hello");
      final List<ContactModel> contacts = await contactRepository
          .getAccessToUserContacts(context: event.context);
      log(contacts.length.toString());
      emit(ContactState(contactList: contacts));
    } catch (e) {
      log("Error $e");
      emit(ContactsErrorState(message: e.toString()));
    }
  }

  FutureOr<void> selectUserEvent(
      SelectUserEvent event, Emitter<ContactState> emit) {
    try {
      if (state.selectedContactList == null) {
        return null;
      }
      List<ContactModel> selectedContactList = [...state.selectedContactList!];
      if (selectedContactList.contains(event.contact)) {
        selectedContactList.remove(event.contact);
      } else {
        selectedContactList.add(event.contact);
      }

      emit(
        ContactState(
          contactList: state.contactList,
          selectedContactList: selectedContactList,
        ),
      );
    } catch (e) {
      log("Error $e");
      emit(ContactsErrorState(message: e.toString()));
    }
  }

  FutureOr<void> clearListEvent(
      ClearListEvent event, Emitter<ContactState> emit) {
    try {
      emit(ContactState(
          contactList: state.contactList, selectedContactList: const []));
    } catch (e) {
      emit(ContactsErrorState(message: e.toString()));
    }
  }
}
