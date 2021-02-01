import 'dart:async';
import 'package:ContactsManagerApp/data/blocs/contact_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ContactsManagerApp/models/contact.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

// enum ViewContactFormStatus {
//   editing,

//   /// The form has been completely validated.
//   valid,

//   /// The form contains one or more invalid inputs.
//   invalid,

//   /// The form is in the process of being submitted.
//   submissionInProgress,

//   /// The form has been submitted successfully.
//   submissionSuccess,

//   /// The form submission failed.
//   submissionFailure
// }

abstract class ViewContactEvent extends Equatable {
  const ViewContactEvent();

  @override
  List<Object> get props => [];
}

// class ContactInitialize extends ViewContactEvent {
//   const ContactInitialize({@required this.contact});

//   final Contact contact;

//   @override
//   List<Object> get props => [contact];
// }

class NameChanged extends ViewContactEvent {
  const NameChanged({@required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class MobileChanged extends ViewContactEvent {
  const MobileChanged({@required this.mobileNumber});

  final int mobileNumber;

  @override
  List<Object> get props => [mobileNumber];
}

class LandlineChanged extends ViewContactEvent {
  const LandlineChanged({@required this.landline});

  final int landline;

  @override
  List<Object> get props => [landline];
}

class FavStatusChanged extends ViewContactEvent {
  const FavStatusChanged({@required this.isFav});

  final bool isFav;

  @override
  List<Object> get props => [isFav];
}

class ImageChanged extends ViewContactEvent {
  const ImageChanged({@required this.image});

  final String image;

  @override
  List<Object> get props => [image];
}

class CreateContact extends ViewContactEvent {
  const CreateContact();

  @override
  List<Object> get props => [];
}

class UpdateViewContact extends ViewContactEvent {
  const UpdateViewContact();

  @override
  List<Object> get props => [];
}

class DeleteViewContact extends ViewContactEvent {}

class ViewContactState extends Equatable {
  const ViewContactState(
      {this.contact = const Contact(
          id: 0, name: '', mobile: 0, landline: 0, img: '', isFav: false),
      this.status = FormzStatus.pure});

  final Contact contact;
  final FormzStatus status;
  ViewContactState copyWith(
      {int id,
      String name,
      int mobile,
      int landline,
      bool isFav,
      String image,
      FormzStatus status}) {
    return ViewContactState(
        contact: Contact(
            name: name ?? this.contact.name,
            landline: landline ?? this.contact.landline,
            mobile: mobile ?? this.contact.mobile,
            img: image ?? this.contact.img,
            isFav: isFav ?? this.contact.isFav,
            id: id ?? this.contact.id),
        status: status ?? status);
  }

  @override
  List<Object> get props => [contact];
}

class ViewContactBloc extends Bloc<ViewContactEvent, ViewContactState> {
  ViewContactBloc({@required Contact contact})
      : super(ViewContactState(contact: contact));

  @override
  void onTransition(Transition<ViewContactEvent, ViewContactState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<Transition<ViewContactEvent, ViewContactState>> transformEvents(
    Stream<ViewContactEvent> events,
    TransitionFunction<ViewContactEvent, ViewContactState> transitionFn,
  ) {
    final debounced = events
        .where((event) => event is! CreateContact)
        .debounceTime(const Duration(milliseconds: 300));
    return events
        .where((event) => event is CreateContact)
        .mergeWith([debounced]).switchMap(transitionFn);
  }

  @override
  Stream<ViewContactState> mapEventToState(ViewContactEvent event) async* {
    // if (event is ContactInitialize) {
    //   final contact = event.contact;
    //   yield ViewContactState(contact: contact);
    // }
    if (event is MobileChanged) {
      final mobile = event.mobileNumber;
      yield state.copyWith(mobile: mobile);
    } else if (event is LandlineChanged) {
      var landline = event.landline;
      if (landline == null) {
        landline = 0;
      }
      print(landline.toString() + "  map event to state");
      yield state.copyWith(landline: landline);
    } else if (event is NameChanged) {
      final name = event.name;
      yield state.copyWith(name: name);
    } else if (event is FavStatusChanged) {
      final isFav = event.isFav;
      yield state.copyWith(isFav: isFav);
    } else if (event is ImageChanged) {
      yield state.copyWith(image: event.image);
    } else if (event is CreateContact) {
      if (state.contact.name.length == 0 ||
          state.contact.mobile == 0 ||
          state.contact.mobile.toString().length == 0) {
        yield state.copyWith(status: FormzStatus.invalid);
        return;
      }
      yield state.copyWith(
          status: FormzStatus.submissionInProgress,
          id: DateTime.now().millisecondsSinceEpoch);
    } else if (event is UpdateViewContact) {
      if (state.contact.name.length == 0 ||
          state.contact.mobile == 0 ||
          state.contact.mobile.toString().length == 0) {
        yield state.copyWith(status: FormzStatus.invalid);
        return;
      }
      yield state.copyWith(status: FormzStatus.submissionInProgress);
    } else if (event is DeleteViewContact) {
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}

// enum FormStatus {
//   case editing,

// }
