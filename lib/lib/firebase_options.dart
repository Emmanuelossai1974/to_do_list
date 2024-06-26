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
    apiKey: 'AIzaSyAxd-1HUs9_lb34IxGKX6DqWGX5F8t4PG0',
    appId: '1:1062667719909:web:2d033bf0f7224751ba700c',
    messagingSenderId: '1062667719909',
    projectId: 'to-do-123-a995e',
    authDomain: 'to-do-123-a995e.firebaseapp.com',
    storageBucket: 'to-do-123-a995e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADoaRTqHSWdkExjukvZibJzkTmdohVRtE',
    appId: '1:1062667719909:android:854d0c6afe4156a6ba700c',
    messagingSenderId: '1062667719909',
    projectId: 'to-do-123-a995e',
    storageBucket: 'to-do-123-a995e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtVg5AK27A8X0LQBOtQCk_9IsesPV3qzU',
    appId: '1:1062667719909:ios:9ef5279b2d3d59beba700c',
    messagingSenderId: '1062667719909',
    projectId: 'to-do-123-a995e',
    storageBucket: 'to-do-123-a995e.appspot.com',
    iosBundleId: 'com.example.toDoList',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtVg5AK27A8X0LQBOtQCk_9IsesPV3qzU',
    appId: '1:1062667719909:ios:9ef5279b2d3d59beba700c',
    messagingSenderId: '1062667719909',
    projectId: 'to-do-123-a995e',
    storageBucket: 'to-do-123-a995e.appspot.com',
    iosBundleId: 'com.example.toDoList',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxd-1HUs9_lb34IxGKX6DqWGX5F8t4PG0',
    appId: '1:1062667719909:web:df7c29e97e2edc97ba700c',
    messagingSenderId: '1062667719909',
    projectId: 'to-do-123-a995e',
    authDomain: 'to-do-123-a995e.firebaseapp.com',
    storageBucket: 'to-do-123-a995e.appspot.com',
  );
}
