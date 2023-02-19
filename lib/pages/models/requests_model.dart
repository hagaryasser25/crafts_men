import 'package:flutter/cupertino.dart';

class Requests {
  Requests({
    String? id,
    String? description,
    String? date,
    String? userName,
    String? userPhone,
    String? workerUid,
    String? userUid,
  }) {
    _id = id;
    _description = description;
    _date = date;
    _userName = userName;
    _userPhone = userPhone;
    _workerUid = workerUid;
    _userUid = userUid;
  }

  Requests.fromJson(dynamic json) {
    _id = json['id'];
    _description = json['description'];
    _date = json['date'];
    _userName = json['userName'];
    _userPhone = json['userPhone'];
    _workerUid = json['workerUid'];
    _userUid = json['userUid'];
  }

  String? _id;
  String? _description;
  String? _date;
  String? _userName;
  String? _userPhone;
  String? _workerUid;
  String? _userUid;

  String? get id => _id;
  String? get description => _description;
  String? get date => _date;
  String? get userName => _userName;
  String? get userPhone => _userPhone;
  String? get workerUid => _workerUid;
  String? get userUid => _userUid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['description'] = _description;
    map['date'] = _date;
    map['userName'] = _userName;
    map['userPhone'] = _userPhone;
    map['workerUid'] = _workerUid;
    map['userUid'] = _userUid;

    return map;
  }
}