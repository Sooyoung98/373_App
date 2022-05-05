// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shim_app/models/shimuser.dart';
import 'package:shim_app/models/event.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _eventsCollectionReference =
      FirebaseFirestore.instance.collection('events');

  Future createUser(ShimUser user) async {
    try {
      print(user.toJson());
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return ShimUser.fromData(userData.data() as Map<String, dynamic>);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future uploadEvent(Event event) async {
    try {
      await _eventsCollectionReference.add(event.toJson());
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteEvent(String id) async {
    try {
      await _eventsCollectionReference.doc(id).update({"active": false});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future changeEvent(String id, Event event) async {
    try {
      await _eventsCollectionReference.doc(id).update({
        "title": event.title,
        "description": event.description,
        "location": event.location,
        "date": event.date,
        "startTime": event.startTime,
        "endTime": event.endTime,
        "repeatType": event.repeatType,
        "color": event.color
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future addSelectedEvent(ShimUser user, DocumentReference event) async {
    try {
      await _usersCollectionReference.doc(user.id).update({
        "events": FieldValue.arrayUnion([event])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future undoSelectedEvent(ShimUser user, DocumentReference event) async {
    try {
      await _usersCollectionReference.doc(user.id).update({
        "events": FieldValue.arrayRemove([event])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future addSelectedUser(ShimUser user, DocumentReference event) async {
    try {
      DocumentReference uRef = _usersCollectionReference.doc(user.id);
      await _eventsCollectionReference.doc(event.id).update({
        "users": FieldValue.arrayUnion([uRef])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future undoSelectedUser(ShimUser user, DocumentReference event) async {
    try {
      DocumentReference uRef = _usersCollectionReference.doc(user.id);
      await _eventsCollectionReference.doc(event.id).update({
        "users": FieldValue.arrayRemove([uRef])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future editUserProfile(ShimUser user, String fullName, DateTime birthday,
      String phoneNumber) async {
    try {
      await _usersCollectionReference.doc(user.id).update({
        "fullName": fullName,
        "birthday": birthday,
        "phoneNumber": phoneNumber
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
