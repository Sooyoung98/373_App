import 'package:shim_app/locator.dart';
import 'package:shim_app/models/shimuser.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shim_app/services/firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  late ShimUser _currentUser;
  ShimUser get currentUser => _currentUser;

  Future loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user!);
      return authResult.user != null;
    } catch (e) {
      return e.toString();
    }
  }

  Future signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required DateTime birthday,
    required String phoneNumber,
    required String role,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = ShimUser(
          id: authResult.user!.uid,
          email: email,
          fullName: fullName,
          birthday: birthday,
          phoneNumber: phoneNumber,
          userRole: role,
          events: []);

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> isUserLoggedIn() async {
    User? user = await _firebaseAuth.currentUser;
    if (user != null) {
      await _populateCurrentUser(user);
    }

    return user != null;
  }

  ShimUser getUser() {
    return _currentUser;
  }

  Future updateCurrentUser() async {
    var user = await _firebaseAuth.currentUser;
    await _populateCurrentUser(user!);
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }

  Future<bool> signOutWithEmail() async {
    try {
      var authResult = await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
