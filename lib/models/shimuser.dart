import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shim_app/models/event.dart';

class ShimUser {
  final String? id;
  final String? fullName;
  final String? email;
  final DateTime? birthday;
  final String? phoneNumber;
  final String? userRole;
  List<dynamic>? events;

  ShimUser(
      {this.id,
      this.fullName,
      this.email,
      this.birthday,
      this.phoneNumber,
      this.userRole,
      this.events});

  ShimUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        birthday = (data['birthday'] as Timestamp).toDate(),
        phoneNumber = data['phoneNumber'],
        userRole = data['userRole'],
        events = data['events'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'birthday': birthday,
      'phoneNumber': phoneNumber,
      'userRole': userRole,
      'events': events
    };
  }
}
