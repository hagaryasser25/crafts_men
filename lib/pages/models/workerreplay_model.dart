import 'package:flutter/cupertino.dart';

class WorkerReplays {
  WorkerReplays({
    String? id,
    String? userUid,
    String? price,
    String? userRequest,
    String? adminReplay,
  }) {
    _id = id;
    _userUid = userUid;
    _price = price;
    _userRequest = userRequest;
    _adminReplay = adminReplay;
  }

  WorkerReplays.fromJson(dynamic json) {
    _id = json['id'];
    _userUid = json['userUid'];
    _price = json['price'];
    _userRequest = json['userRequest'];
    _adminReplay = json['adminReplay'];
  }

  String? _id;
  String? _userUid;
  String? _price;
  String? _userRequest;
  String? _adminReplay;

  String? get id => _id;
  String? get userUid => _userUid;
  String? get price => _price;
  String? get userRequest => _userRequest;
  String? get adminReplay => _adminReplay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userUid'] = _userUid;
    map['price'] = _price;
    map['userRequest'] = _userRequest;
    map['adminReplay'] = _adminReplay;

    return map;
  }
}