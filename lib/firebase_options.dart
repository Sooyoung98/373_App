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
    apiKey: 'AIzaSyDNnL0uDA_ANnElY3hzAZgSa-IgS957yBg',
    appId: '1:313503001980:web:bf3f2bfa50a1bcdc3808f9',
    messagingSenderId: '313503001980',
    projectId: 'shimapp-cbf8f',
    authDomain: 'shimapp-cbf8f.firebaseapp.com',
    storageBucket: 'shimapp-cbf8f.appspot.com',
    measurementId: 'G-V09GC5Y5DN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDr_vVbsmWu78ht-39STaTDVnp1MSKvbO0',
    appId: '1:313503001980:android:4a6eae770307056b3808f9',
    messagingSenderId: '313503001980',
    projectId: 'shimapp-cbf8f',
    storageBucket: 'shimapp-cbf8f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVm4QHkEIx_5d-gRsirib90SDHzdW8Zlo',
    appId: '1:313503001980:ios:e440b83a8d93fcfe3808f9',
    messagingSenderId: '313503001980',
    projectId: 'shimapp-cbf8f',
    storageBucket: 'shimapp-cbf8f.appspot.com',
    iosClientId: '313503001980-9dl1cc1sv70i7n8ch4b6chuovac2cgq3.apps.googleusercontent.com',
    iosBundleId: 'com.shim.app',
  );
}
