// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBOHowtCWWzkVn0o2HYUwbeGLoiyVNgNts',
    appId: '1:371389960847:web:6c7c7811207fad45ef96fa',
    messagingSenderId: '371389960847',
    projectId: 'shim-e4f1b',
    authDomain: 'shim-e4f1b.firebaseapp.com',
    storageBucket: 'shim-e4f1b.appspot.com',
    measurementId: 'G-MZ4TVJGCD3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxwFAJdRwwCAThWrszPqIvi3H6e0G9Ks0',
    appId: '1:371389960847:android:9b76d7d55fe43b97ef96fa',
    messagingSenderId: '371389960847',
    projectId: 'shim-e4f1b',
    storageBucket: 'shim-e4f1b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAiq08K5hh_tHnnGRBgaK1pZtGiEoD1z_Q',
    appId: '1:371389960847:ios:ca5fdb55adf81a06ef96fa',
    messagingSenderId: '371389960847',
    projectId: 'shim-e4f1b',
    storageBucket: 'shim-e4f1b.appspot.com',
    iosClientId: '371389960847-9ivc35g2r5cp8ivo71rbs3u82ogbgpp0.apps.googleusercontent.com',
    iosBundleId: 'com.shim.app',
  );
}
