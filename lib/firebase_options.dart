import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCWbf2uqbvfSP8fxGO-hOSilG9l_8AJhMc',
    appId: '1:95235618414:web:a70053241ac2aebec6d87f',
    messagingSenderId: '95235618414',
    projectId: 'id-express-paula',
    authDomain: 'id-express-paula.firebaseapp.com',
    storageBucket: 'id-express-paula.firebasestorage.app',
    measurementId: 'G-CPLMW0BEYV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBC_TMc5n5MEmw95B0G7W1tFFAM1ghVWHA',
    appId: '1:95235618414:android:f981d02a9d908af5c6d87f',
    messagingSenderId: '95235618414',
    projectId: 'id-express-paula',
    storageBucket: 'id-express-paula.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtN3CX65AmeqszU4tuPFpzNLAf1JBHiE8',
    appId: '1:95235618414:ios:c3a1c5564058142ec6d87f',
    messagingSenderId: '95235618414',
    projectId: 'id-express-paula',
    storageBucket: 'id-express-paula.firebasestorage.app',
    iosBundleId: 'com.example.idExpress',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: 'com.example.idExpress',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCWbf2uqbvfSP8fxGO-hOSilG9l_8AJhMc',
    appId: '1:95235618414:web:672b7d99abc1f3b7c6d87f',
    messagingSenderId: '95235618414',
    projectId: 'id-express-paula',
    authDomain: 'id-express-paula.firebaseapp.com',
    storageBucket: 'id-express-paula.firebasestorage.app',
    measurementId: 'G-327YNSNGDL',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY',
    appId: 'YOUR_LINUX_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}