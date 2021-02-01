import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';

class Contact {
 final int id;
 final String name;
 final int mobile;
 final int landline;
 final String img;
 final bool isFav;

  const Contact(
      {this.id,
      @required this.name,
      @required this.mobile,
      this.landline,
      this.img,
      this.isFav});

  factory Contact.fromJson(Map<String, dynamic> json) => new Contact(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        landline: json["landline"],
        img: json["img"],
        isFav: json["isFav"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "landline": landline,
        "img": img,
        "isFav": isFav ? 1 : 0,
      };
}

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      height: 190,
      width: 190,
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
