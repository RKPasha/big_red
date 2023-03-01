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
    apiKey: 'AIzaSyAmWZTLypNt3HuZc_QgWIv0aju6QLjNj1Y',
    appId: '1:101724279513:web:67eed4810e18f8d022a4c8',
    messagingSenderId: '101724279513',
    projectId: 'big-red-auth',
    authDomain: 'big-red-auth.firebaseapp.com',
    databaseURL: 'https://big-red-auth-default-rtdb.firebaseio.com',
    storageBucket: 'big-red-auth.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQ27w02YnzGqn23TWIZNn-ARR_IldbXvQ',
    appId: '1:101724279513:android:bd3fbac0a09fdbbe22a4c8',
    messagingSenderId: '101724279513',
    projectId: 'big-red-auth',
    databaseURL: 'https://big-red-auth-default-rtdb.firebaseio.com',
    storageBucket: 'big-red-auth.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKZYDqQ0Pki6s4J5tEie6GpapOsy2iLkQ',
    appId: '1:101724279513:ios:12961f2c647fb5d922a4c8',
    messagingSenderId: '101724279513',
    projectId: 'big-red-auth',
    databaseURL: 'https://big-red-auth-default-rtdb.firebaseio.com',
    storageBucket: 'big-red-auth.appspot.com',
    androidClientId: '101724279513-43h5ljts5dbrf1prvvi9qbp7ivs7k3jh.apps.googleusercontent.com',
    iosClientId: '101724279513-9gktoau5ccae3cb4ic0saq32s8tin9sh.apps.googleusercontent.com',
    iosBundleId: 'com.bigResAutoDeals.bigRed',
  );
}
