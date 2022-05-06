import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shim_app/constants/route_names.dart';
import 'package:shim_app/locator.dart';
import 'package:shim_app/models/event.dart';
import 'package:shim_app/services/authentication_service.dart';
import 'package:shim_app/services/dialog_service.dart';
import 'package:shim_app/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shim_app/ui/views/main_view.dart';

import '../services/firestore_service.dart';
import 'base_model.dart';

class AddEventViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future addEvent(
      {required String title,
      required String location,
      required DateTime date,
      required int color,
      required String endTime,
      required String startTime,
      required String repeatType,
      required String description,
      required BuildContext context}) async {
    setBusy(true);
    var _newEvent = Event(
        title: title,
        location: location,
        date: date,
        color: color,
        endTime: endTime,
        startTime: startTime,
        repeatType: repeatType,
        description: description,
        active: true,
        users: []);

    var result = await _firestoreService.uploadEvent(_newEvent);

    Navigator.pop(context);

    setBusy(false);
  }

  Future deleteEvent(
      {required String id, required BuildContext context}) async {
    setBusy(true);

    var result = await _firestoreService.deleteEvent(id);

    setBusy(false);

    if (result is bool) {
      if (result) {
        Navigator.pop(context);
      } else {
        await _dialogService.showDialog(
          title: 'Event Delete Failure',
          description: 'An Error occurred so the event cannot be deleted.',
        );
      }
    }
  }

  Future editEvent(
      {required String id,
      required String title,
      required String location,
      required DateTime date,
      required int color,
      required String endTime,
      required String startTime,
      required String repeatType,
      required String description}) async {
    setBusy(true);
    var _changedEvent = Event(
        title: title,
        location: location,
        date: date,
        color: color,
        endTime: endTime,
        startTime: startTime,
        repeatType: repeatType,
        description: description,
        active: true);

    var result = await _firestoreService.changeEvent(id, _changedEvent);

    setBusy(false);
  }

  Future addEventToUser({required DocumentReference e}) async {
    setBusy(true);

    var user = _authenticationService.getUser();
    var result = await _firestoreService.addSelectedEvent(user, e);
    var result2 = await _firestoreService.addSelectedUser(user, e);

    setBusy(false);

    if (result is bool) {
      if (result && result2) {
        await _authenticationService.updateCurrentUser();
        var user = _authenticationService.getUser();
        var msg = "Successfully added new Going Event!";
        _navigationService.navigateTo(MainViewRoute,
            arguments: MainView(user: user, msg: msg));
        // await _dialogService.showDialog(
        //   title: 'Event Addition Success',
        //   description: 'The selected event has been added to your list!',
        // );
      } else {
        await _dialogService.showDialog(
          title: 'Event Delete Failure',
          description: 'An Error occurred so the event cannot be deleted.',
        );
      }
    }
  }

  Future undoEventToUser({required DocumentReference e}) async {
    setBusy(true);

    var user = _authenticationService.getUser();
    var result = await _firestoreService.undoSelectedEvent(user, e);
    var result2 = await _firestoreService.undoSelectedUser(user, e);
    setBusy(false);

    if (result is bool) {
      if (result && result2) {
        await _authenticationService.updateCurrentUser();
        var user = _authenticationService.getUser();
        var msg = "Successfully deleted the event from going events!";
        _navigationService.navigateTo(MainViewRoute,
            arguments: MainView(user: user, msg: msg));
        // await _dialogService.showDialog(
        //   title: 'Event Addition Success',
        //   description: 'The selected event has been added to your list!',
        // );
      } else {
        await _dialogService.showDialog(
          title: 'Event Delete Failure',
          description: 'An Error occurred so the event cannot be deleted.',
        );
      }
    }
  }
}
