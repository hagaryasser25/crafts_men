import 'package:flutter/cupertino.dart';

class CraftsMenV {
  CraftsMenV({
    String? id,
    String? address,
    int? rating,
    String? email,
    String? imageUrl,
    String? name,
    String? phoneNumber,
    String? type,
    String? uid,
    String? password,
  }) {
    _id = id;
    _address = address;
    _rating = rating;
    _email = email;
    _imageUrl = imageUrl;
    _name = name;
    _phoneNumber = phoneNumber;
    _type = type;
    _uid = uid;
    _password = password;
  }

  CraftsMenV.fromJson(dynamic json) {
    _id = json['id'];
    _address = json['address'];
    _rating = json['rating'];
    _email = json['email'];
    _imageUrl = json['imageUrl'];
    _name = json['name'];
    _phoneNumber = json['phoneNumber'];
    _type = json['type'];
    _uid = json['uid'];
    _password = json['password'];
  }

  String? _id;
  String? _address;
  int? _rating;
  String? _email;
  String? _imageUrl;
  String? _name;
  String? _phoneNumber;
  String? _type;
  String? _uid;
  String? _password;

  String? get id => _id;
  String? get address => _address;
  String? get email => _email;
  String? get imageUrl => _imageUrl;
  String? get name => _name;
  String? get phoneNumber => _phoneNumber;
  String? get type => _type;
  int? get rating => _rating;
  String? get uid => _uid;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['address'] = _address;
    map['email'] = _email;
    map['imageUrl'] = _imageUrl;
    map['name'] = _name;
    map['phoneNumber'] = _phoneNumber;
    map['type'] = _type;
    map['rating'] = _rating;
    map['uid'] = _uid;
    map['password'] = _password;

    return map;
  }
}
