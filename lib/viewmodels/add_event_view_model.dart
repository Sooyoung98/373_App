import 'package:firebase_auth/firebase_auth.dart';
import 'package:shim_app/constants/route_names.dart';
import 'package:shim_app/locator.dart';
import 'package:shim_app/models/event.dart';
import 'package:shim_app/services/authentication_service.dart';
import 'package:shim_app/services/dialog_service.dart';
import 'package:shim_app/services/navigation_service.dart';
import 'package:flutter/foundation.dart';

import '../services/firestore_service.dart';
import 'base_model.dart';

class AddEventViewModel extends BaseModel {
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
      required String description}) async {
    setBusy(true);
    print("HEEEEEE");
    var _newEvent = Event(
        title: title,
        location: location,
        date: date,
        color: color,
        endTime: endTime,
        startTime: startTime,
        repeatType: repeatType,
        description: description);

    var result = await _firestoreService.uploadEvent(_newEvent);

    setBusy(false);

    // if (result is bool) {
    //   if (result) {
    //     _navigationService.navigateTo(MainViewRoute);
    //   } else {
    //     await _dialogService.showDialog(
    //       title: 'Unable to add new Event',
    //       description: 'Cannot add new events..',
    //     );
    //   }
    // } else {
    //   await _dialogService.showDialog(
    //     title: 'Not able to add event',
    //     description: result,
    //   );
    // }
  }
}
