// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCOHqwYvlX2RdR5OXuZ0r_v5Bx93Xn_Ftw',
    appId: '1:1060702300492:web:8d3f86d6baa8e3870dc7e9',
    messagingSenderId: '1060702300492',
    projectId: 'flutter-test-82f40',
    authDomain: 'flutter-test-82f40.firebaseapp.com',
    storageBucket: 'flutter-test-82f40.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWhNf64qFxQRmn6HFZQ7lv1yVavlaHMBw',
    appId: '1:1060702300492:android:f1d1df38f8b595a10dc7e9',
    messagingSenderId: '1060702300492',
    projectId: 'flutter-test-82f40',
    storageBucket: 'flutter-test-82f40.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBa6h_oW2uE2vGOqUFVilBs8b2TZKD3gI4',
    appId: '1:1060702300492:ios:9196777855bef51a0dc7e9',
    messagingSenderId: '1060702300492',
    projectId: 'flutter-test-82f40',
    storageBucket: 'flutter-test-82f40.firebasestorage.app',
    iosBundleId: 'com.jenni.crudFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBa6h_oW2uE2vGOqUFVilBs8b2TZKD3gI4',
    appId: '1:1060702300492:ios:9196777855bef51a0dc7e9',
    messagingSenderId: '1060702300492',
    projectId: 'flutter-test-82f40',
    storageBucket: 'flutter-test-82f40.firebasestorage.app',
    iosBundleId: 'com.jenni.crudFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCOHqwYvlX2RdR5OXuZ0r_v5Bx93Xn_Ftw',
    appId: '1:1060702300492:web:cfbc00f98d87b1c50dc7e9',
    messagingSenderId: '1060702300492',
    projectId: 'flutter-test-82f40',
    authDomain: 'flutter-test-82f40.firebaseapp.com',
    storageBucket: 'flutter-test-82f40.firebasestorage.app',
  );
}
