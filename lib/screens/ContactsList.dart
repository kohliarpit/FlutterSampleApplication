import 'package:ContactsManagerApp/data/blocs/contact_bloc.dart';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ContactsManagerApp/data/blocs/view_contact_bloc.dart';
import 'view_contact.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({
    Key key,
    this.showFavourites = false,
  }) : super(key: key);
  final bool showFavourites;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        // Make sure data exists and is actually loaded
        if (state is ContactsInitial) {
          BlocProvider.of<ContactsBloc>(context).add(ContactsRequested());
        }
        if (state is ContactsLoadFailure) {
          return Center(
            child:
                Text('Error loading Contacts', style: TextStyle(fontSize: 24)),
          );
        }
        if (state is ContactsLoadSuccess) {
          // If there are no contacts (data), display this message.
          if (state.contacts.length == 0) {
            return Center(
              child: Text('No Contacts', style: TextStyle(fontSize: 24)),
            );
          }

          List<Contact> contacts = state.contacts;
          if (showFavourites) {
            contacts = state.favContacts;
          }

          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 2,
            ),
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int index) {
              Contact contact = contacts[index];

              return _buildListTile(contact, () {
                print(context);
                _navigateToContact(contact, true, context);
              });
            },
          );
        }
        print("ContactsLoadInProgress");

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildListTile(Contact contact, Function tapHandler) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30.0,
        child: ClipRRect(
            borderRadius: new BorderRadius.circular(30.0),
            child: contact.img.length > 0
                ? Utility.imageFromBase64String(contact.img)
                : Text(
                    contact.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 38,
                    ),
                  )),
        backgroundColor: Colors.pink,
      ),
      title: Text(
        contact.name,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
      contentPadding: EdgeInsets.all(20),
    );
  }

  void _navigateToContact(
      Contact contact, bool isEditing, BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return BlocProvider(
            create: (_) => ViewContactBloc(contact: contact),
            child: ViewContactPage(
              isEditing: isEditing,
            ));
      }),
    );
  }
}
