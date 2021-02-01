import 'package:ContactsManagerApp/data/blocs/contact_bloc.dart';
import 'package:ContactsManagerApp/data/blocs/view_contact_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import '../models/contact.dart';
import 'package:image_picker/image_picker.dart';

class ViewContactPage extends StatelessWidget {
  ViewContactPage({
    Key key,
    this.isEditing,
  }) : super(key: key);

  final bool isEditing;

  static const routeName = '/viewContact';

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final landlineController = TextEditingController();
  bool inputValidationError = false;

  

  void _addContact(BuildContext ctx) async {
    

    BlocProvider.of<ViewContactBloc>(ctx).add(CreateContact());

  }

  void _updateContact(BuildContext ctx) async {
    
    BlocProvider.of<ViewContactBloc>(ctx).add(UpdateViewContact());
  }

  void _deleteContact(BuildContext context) {
    
    BlocProvider.of<ViewContactBloc>(context).add(DeleteViewContact());
  }

  void showAlertDialog(BuildContext cntxt, String title, String message) {
    showDialog(
      context: cntxt,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(
          message,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    return this.isEditing ? 'Update Contact' : 'Add New Contact';
  }

 

  @override
  Widget build(BuildContext context) {
    return BlocListener<ViewContactBloc, ViewContactState>(
        listener: (context, state) {
          if (state.status.isInvalid) {
            showAlertDialog(context, 'Missing required fields!',
                'Name and mobile can\'t be blank.');
            return;
          } else if (state.status.isSubmissionInProgress) {
            if (this.isEditing) {
              BlocProvider.of<ContactsBloc>(context)
                  .add(UpdateContact(contact: state.contact));
            } else {
              BlocProvider.of<ContactsBloc>(context)
                  .add(AddContact(contact: state.contact));
            }

            Navigator.of(context).pop(true);
          } else if (state.status.isSubmissionFailure) {
            BlocProvider.of<ContactsBloc>(context)
                .add(DeleteContact(contact: state.contact));
            Navigator.of(context).pop(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(_getPageTitle()),
              actions: <Widget>[
                FavIcon(),
              ],
            ),
            body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      AvatarImage(),
                      SizedBox(
                        height: 50,
                      ),
                      NameInput(),
                      SizedBox(
                        height: 10,
                      ),
                      MobileInput(),
                      SizedBox(
                        height: 10,
                      ),
                      LandlineInput(),
                      Spacer(),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: this.isEditing
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                    FlatButton(
                                        child: Text(
                                          'Update',
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                        textColor: Colors.blue,
                                        onPressed: () =>
                                            _updateContact(context)),
                                    Spacer(),
                                    FlatButton(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                        textColor: Colors.blue,
                                        onPressed: () {
                                          _deleteContact(context);
                                        }),
                                  ])
                            : FlatButton(
                                child: Text(
                                  'Save',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                textColor: Colors.blue,
                                onPressed: () => _addContact(context),
                              ),
                      ),
                    ],
                  )),
                ))));
  }
}

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewContactBloc, ViewContactState>(
        buildWhen: (previous, current) =>
            (previous.contact.img != current.contact.img ||
                (previous.contact.name != current.contact.name &&
                    current.contact.img.length == 0)),
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              //do what you want here
              _showPhotoLibrary(context);
            },
            child: CircleAvatar(
              radius: 100.0,
              child: ClipRRect(
                  borderRadius: new BorderRadius.circular(96.0),
                  child: state.contact.img.length > 0
                      ? Utility.imageFromBase64String(state.contact.img)
                      : Text(
                          state.contact.name.length > 0
                              ? state.contact.name[0].toUpperCase()
                              : "",
                          style: TextStyle(
                            fontSize: 100,
                          ),
                        )),
              backgroundColor: Colors.pink,
            ),
          );
        });
  }

  void _showPhotoLibrary(BuildContext context) async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      String imgString = Utility.base64String(file.readAsBytesSync());
      BlocProvider.of<ViewContactBloc>(context)
          .add(ImageChanged(image: imgString));
    }
  }
}

class FavIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewContactBloc, ViewContactState>(
      buildWhen: (previous, current) =>
          previous.contact.isFav != current.contact.isFav,
      builder: (context, state) {
        return IconButton(
          icon: state.contact.isFav
              ? Icon(Icons.favorite, color: Colors.black)
              : Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {
            BlocProvider.of<ViewContactBloc>(context)
                .add(FavStatusChanged(isFav: !state.contact.isFav));
          },
        );
      },
    );
  }
}

class MobileInput extends StatelessWidget {
  final String initialText;

  const MobileInput({Key key, this.initialText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewContactBloc, ViewContactState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return Row(children: <Widget>[
          Container(
              width: 100,
              height: 24,
              margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Text('Mobile',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ))),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Container(
                height: 28,
                width: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                ),
                child: TextField(
                  onChanged: (value) {
                    BlocProvider.of<ViewContactBloc>(context)
                        .add(MobileChanged(mobileNumber: int.parse(value)));
                  },
                  controller: TextEditingController(
                      text: state.contact.mobile == 0
                          ? ""
                          : state.contact.mobile.toString()),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}

class LandlineInput extends StatelessWidget {
  final String initialText;

  const LandlineInput({Key key, this.initialText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewContactBloc, ViewContactState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return Row(children: <Widget>[
          Container(
              width: 100,
              height: 24,
              margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Text('Landline',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ))),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Container(
                height: 28,
                width: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                ),
                child: TextField(
                  onChanged: (value) {
                    print(value + "  on chnged");

                    BlocProvider.of<ViewContactBloc>(context).add(
                        LandlineChanged(landline: int.tryParse(value) ?? (0)));
                  },
                  controller: TextEditingController(
                      text: state.contact.landline == 0
                          ? ""
                          : state.contact.landline.toString()),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}

class NameInput extends StatelessWidget {
  final String initialText;

  const NameInput({Key key, this.initialText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewContactBloc, ViewContactState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return Row(children: <Widget>[
          Container(
              width: 100,
              height: 24,
              margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Text('Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ))),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Container(
                height: 28,
                width: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                ),
                child: TextField(
                  onChanged: (value) {
                    BlocProvider.of<ViewContactBloc>(context)
                        .add(NameChanged(name: value));
                  },
                  controller: TextEditingController(text: state.contact.name),
                  keyboardType: TextInputType.name,
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
