import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shim_app/constants/route_names.dart';
import 'package:shim_app/locator.dart';
import 'package:shim_app/services/authentication_service.dart';
import 'package:shim_app/services/dialog_service.dart';
import 'package:shim_app/services/firestore_service.dart';
import 'package:shim_app/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shim_app/ui/views/main_view.dart';

import 'base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String _selectedRole = 'Select a User Role';
  String get selectedRole => _selectedRole;

  void setSelectedRole(dynamic role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future signUp(
      {required String email,
      required String password,
      required String fullName,
      required DateTime birthday,
      required String phoneNumber}) async {
    setBusy(true);
    print("AM I HERE?");
    var result = await _authenticationService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        birthday: birthday,
        phoneNumber: phoneNumber,
        role: "User");

    setBusy(false);

    if (result is bool) {
      if (result) {
        firebaseMessaging.getToken().then((token) async {
          try {
            await FirebaseFirestore.instance.collection('tokens').add({
              'token': token,
            });
          } catch (e) {
            print(e);
          }
        });
        _navigationService.pop();
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }

  Future editProfile(
      {required String fullName,
      required DateTime birthday,
      required String phoneNumber}) async {
    setBusy(true);

    var user = _authenticationService.getUser();
    var result = await _firestoreService.editUserProfile(
        user, fullName, birthday, phoneNumber);

    setBusy(false);

    if (result is bool) {
      if (result) {
        await _authenticationService.updateCurrentUser();
        var user = _authenticationService.getUser();
        var msg = "Successfully Edited your Profile!";
        _navigationService.navigateTo(MainViewRoute,
            arguments: MainView(user: user, msg: msg));
      } else {
        await _dialogService.showDialog(
          title: 'Event Delete Failure',
          description: 'An Error occurred so the event cannot be deleted.',
        );
      }
    }
  }
}
