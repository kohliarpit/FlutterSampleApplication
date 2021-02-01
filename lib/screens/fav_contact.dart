
import 'package:ContactsManagerApp/screens/ContactsList.dart';
import 'package:flutter/material.dart';
import '../models/contact.dart';

class FavoriteContactPage extends StatefulWidget {
  FavoriteContactPage({
    Key key,
    this.docDirectoryPath,
  }) : super(key: key);

  final docDirectoryPath;

  static const routeName = '/favoriteContact';

  @override
  _FavoriteContactPageState createState() => _FavoriteContactPageState();
}

class _FavoriteContactPageState extends State<FavoriteContactPage> {
  List<Contact> favContacts = <Contact>[];
  @override
  void initState() {
    super.initState();

  }

  

  // Widget _buildListTile(Contact contact) {
  //   return ListTile(
  //     leading: contact.imgPath.length > 0
  //         ? Image.file(
  //             File(
  //               '${widget.docDirectoryPath}/${contact.imgPath}',
  //             ),
  //             width: 48,
  //             height: 48)
  //         : Image.asset('assets/images/user_icon.png', width: 48, height: 48),
  //     title: Text(
  //       contact.name,
  //       style: TextStyle(
  //         fontFamily: 'RobotoCondensed',
  //         fontSize: 24,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     onTap: null,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorite Contact List'),
        ),
        body: ContactsList(
          showFavourites: true,
        ));
  }
}
