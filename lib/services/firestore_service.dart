// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shim_app/models/user.dart';
import 'package:shim_app/models/event.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _eventsCollectionReference =
      Firestore.instance.collection('events');

  Future createUser(User user) async {
    try {
      print(user.toJson());
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
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
      await _eventsCollectionReference
          .document(id)
          .updateData({"active": false});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future addSelectedEvent(User user, DocumentReference event) async {
    try {
      await _usersCollectionReference.document(user.id).updateData({
        "events": FieldValue.arrayUnion([event])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future undoSelectedEvent(User user, DocumentReference event) async {
    try {
      await _usersCollectionReference.document(user.id).updateData({
        "events": FieldValue.arrayRemove([event])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
