import 'dart:ffi';

import 'package:shim_app/models/event.dart';

class User {
  final String? id;
  final String? fullName;
  final String? email;
  final String? userRole;
  List<dynamic>? myEvents;

  User({this.id, this.fullName, this.email, this.userRole, this.myEvents});

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        userRole = data['userRole'],
        myEvents = data['events'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
      'myEvents': myEvents
    };
  }
}
