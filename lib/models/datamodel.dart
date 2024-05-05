// import 'dart:html';
// import 'package:flutter/material.dart';

class LoginDataModel {
  String email;
  String password;
  LoginDataModel({required this.email, required this.password});
}

class PromptDataModel {
  String prompt;
  String res;
  PromptDataModel({required this.prompt, required this.res});
}

class QueryModel {
  int counter = 0;
  late String dttm;
  final List<dynamic> data;
  QueryModel({required this.counter, required this.dttm, required this.data});
  factory QueryModel.fromJson(Map<String, dynamic> json) {
    return QueryModel(
        counter: json['counter'],
        dttm: json['dttm'],
        data: json['data']
            .map((value) => QueryModel.fromJson(value))
            .toList());
  }
}

class InboxModel {
  late String dttm;
  String from;
  String to;
  String message;
  bool readReceipt;
  String fileURL;
  InboxModel({required this.dttm, required this.from, required this.to,
             required this.message, required this.readReceipt, required this.fileURL});
  factory InboxModel.fromJson(Map<String, dynamic> json) {
    return InboxModel(
        dttm: json['dttm'],
        from: json['from'],
        to: json['to'],
        message: json['message'],
        readReceipt: json['readReceipt'],
        fileURL: json['fileURL']);
  }
}

class UserDataModel {
  String objectId;
  String uid;
  String userName;
  String userType;
  String name;
  String email;
  String phone;
  String address;
  UserDataModel({required this.objectId, required this.uid, 
  required this.userName, required this.userType,
  required this.name, required this.email,
  required this.phone, required this.address});
}

class RideModel {
  String objectId;
  String requestor;
  String dttm;
  String from;
  String to;
  String message;
  String loadType;
  String status;
  String fileURL;
  RideModel({required this.objectId, required this.requestor,
            required this.dttm, required this.from, required this.to,
             required this.message, required this.loadType,
             required this.status, required this.fileURL});
  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
        objectId: json['objectId'],
        requestor: json['requestor'],
        dttm: json['dttm'],
        from: json['from'],
        to: json['to'],
        message: json['message'],
        loadType: json['loadType'],
        status: json['status'],
        fileURL: json['fileURL']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['objectId'] = objectId;
    _data['requestor'] = requestor;
    _data['dttm'] = dttm;
    _data['from'] = from;
    _data['to'] = to;
    _data['message'] = message;
    _data['loadType'] = loadType;
    _data['status'] = status;
    _data['fileURL'] = fileURL;
    return _data;
  }
}