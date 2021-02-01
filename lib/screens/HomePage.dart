import 'package:ContactsManagerApp/data/blocs/view_contact_bloc.dart';
import 'package:ContactsManagerApp/models/contact.dart';
import './view_contact.dart';
import 'package:ContactsManagerApp/screens/fav_contact.dart';
import 'package:flutter/material.dart';
import './ContactsList.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  void _pushAddContactScreen(BuildContext context) async {
    Contact contact = new Contact(
        id: 0, name: '', mobile: 0, landline: 0, img: '', isFav: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) => ViewContactBloc(contact: contact),
            child: ViewContactPage(
              isEditing: false,
            ),
          );
        },
      ),
    );
  }

  void _pushFavoriteContactScreen(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return FavoriteContactPage();
        },
      ),
    );
  }

  Widget buildListTileForDrawer(
      String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              buildListTileForDrawer('Contact list screen', Icons.contacts, () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
              Divider(
                thickness: 2,
              ),
              buildListTileForDrawer('Favorite contacts', Icons.favorite, () {
                _pushFavoriteContactScreen(context);
              }),
              Divider(
                thickness: 2,
              ),
              buildListTileForDrawer('Add New Contact', Icons.person_add, () {
                _pushAddContactScreen(context);
              }),
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ContactsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pushAddContactScreen(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
