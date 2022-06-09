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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTjs6nPWmrx0IjObnJUmL0l0N6ln-FXD0',
    appId: '1:326664895837:android:bfd9b964080a51f434fcb4',
    messagingSenderId: '326664895837',
    projectId: 'drp27-e4b6f',
    databaseURL: 'https://drp27-e4b6f-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'drp27-e4b6f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7yGVq3EWx6hWNgSfya7EGAY22sKHayK8',
    appId: '1:326664895837:ios:dd8465c0cbb657b834fcb4',
    messagingSenderId: '326664895837',
    projectId: 'drp27-e4b6f',
    databaseURL: 'https://drp27-e4b6f-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'drp27-e4b6f.appspot.com',
    iosClientId: '326664895837-d8l2848maihq84o06l33h2ivfdnhiujn.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );
}
