// File: frontend/lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDfA7GMEq6K22IUJBFxWSLhtED5zLok60I',
    appId: '1:436190527075:web:ee13070cff673bfbe98256',
    messagingSenderId: '436190527075',
    projectId: 'multi-pro-services',
    authDomain: 'multi-pro-services.firebaseapp.com',
    storageBucket: 'multi-pro-services.firebasestorage.app',
    measurementId: 'G-2QZZCDMYY3',
  );
}
