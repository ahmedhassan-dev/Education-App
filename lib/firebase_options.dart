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
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDIOA5lceD2iUPSJO4jMafw12sVO-FwzVA',
    appId: '1:893761268354:web:15d015e9b76d6be74e229b',
    messagingSenderId: '893761268354',
    projectId: 'education-app-ece7a',
    authDomain: 'education-app-ece7a.firebaseapp.com',
    storageBucket: 'education-app-ece7a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjlb1OzUzFdUpyrd2_DxZ2kBYEUlqcUOU',
    appId: '1:893761268354:android:f194addf2a2c76d64e229b',
    messagingSenderId: '893761268354',
    projectId: 'education-app-ece7a',
    storageBucket: 'education-app-ece7a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTUQVeU-pNQNW64HE75ok5mTA9zeAijV8',
    appId: '1:893761268354:ios:1200a5d429a038da4e229b',
    messagingSenderId: '893761268354',
    projectId: 'education-app-ece7a',
    storageBucket: 'education-app-ece7a.appspot.com',
    iosBundleId: 'com.example.educationApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTUQVeU-pNQNW64HE75ok5mTA9zeAijV8',
    appId: '1:893761268354:ios:888cecf6f93008e34e229b',
    messagingSenderId: '893761268354',
    projectId: 'education-app-ece7a',
    storageBucket: 'education-app-ece7a.appspot.com',
    iosBundleId: 'com.example.educationApp.RunnerTests',
  );
}
