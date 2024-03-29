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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCXDT04M79hEgG_fTgIFzY4Wp8vbf3aBMs',
    appId: '1:556672856671:web:337e192a7e88c5d8e921ea',
    messagingSenderId: '556672856671',
    projectId: 'livetap-891da',
    authDomain: 'livetap-891da.firebaseapp.com',
    storageBucket: 'livetap-891da.appspot.com',
    measurementId: 'G-2J54HMC2ET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfE-wmXKDn-Rvg0kfr504zgdscPqAau6Y',
    appId: '1:556672856671:android:955d1b73535a8f2fe921ea',
    messagingSenderId: '556672856671',
    projectId: 'livetap-891da',
    storageBucket: 'livetap-891da.appspot.com',
  );
}
