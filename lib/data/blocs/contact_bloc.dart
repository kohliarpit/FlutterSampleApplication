import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/contact.dart';

import '../database.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();
}

class ContactsRequested extends ContactEvent {
  const ContactsRequested();

  @override
  List<Object> get props => [];
}

class AddContact extends ContactEvent {
  final Contact contact;

  const AddContact({@required this.contact}) : assert(contact != null);

  @override
  List<Object> get props => [contact];
}

class DeleteContact extends ContactEvent {
  final Contact contact;

  const DeleteContact({@required this.contact}) : assert(contact != null);

  @override
  List<Object> get props => [contact];
}

class UpdateContact extends ContactEvent {
  final Contact contact;

  const UpdateContact({@required this.contact}) : assert(contact != null);

  @override
  List<Object> get props => [contact];
}

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoadInProgress extends ContactsState {}

class ContactsLoadSuccess extends ContactsState {
  final List<Contact> contacts;
  final List<Contact> favContacts;

  const ContactsLoadSuccess(
      {@required this.contacts, @required this.favContacts})
      : assert(contacts != null),
        assert(favContacts != null);

  @override
  List<Object> get props => [contacts, favContacts];
}

class ContactsLoadFailure extends ContactsState {}

class ContactsBloc extends Bloc<ContactEvent, ContactsState> {
  final DBProvider database;

  ContactsBloc({@required this.database})
      : assert(database != null),
        super(ContactsInitial());

  @override
  Stream<ContactsState> mapEventToState(ContactEvent event) async* {
    print("map event to state");
    if (event is UpdateContact) {
      await database.updateContact(event.contact);
    } else if (event is DeleteContact) {
      await database.deleteContact(event.contact.id);
    } else if (event is AddContact) {
      await database.newContact(event.contact);
    }
    print("fetching contacts 1");
    yield ContactsLoadInProgress();
    try {
      print("fetching contacts 2");
      final List<Contact> contacts = await database.getContacts();
      final List<Contact> favContacts = await database.getFavoriteContacts();
      yield ContactsLoadSuccess(contacts: contacts, favContacts: favContacts);
    } catch (_) {
      print("fetching contacts failure");
      yield ContactsLoadFailure();
    }
  }
}
