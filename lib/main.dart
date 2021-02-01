import 'package:ContactsManagerApp/data/blocs/contact_bloc.dart';
import 'package:flutter/material.dart';
import './data/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './screens/HomePage.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            ContactsBloc(database: DBProvider.sharedInstance),
        child: MaterialApp(
          title: 'Contact List',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          home: HomePage(
            title: "Contact LIst",
          ),
        ));
  }
}

