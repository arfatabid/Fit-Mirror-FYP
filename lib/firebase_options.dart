// File generated
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default
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
    apiKey: 'AIzaSyBP4p-hG8fu0_6qulOVDubpD1TtDD5MR1w',
    appId: '1:276799056898:web:e5cf215238a4bef74946b3',
    messagingSenderId: '276799056898',
    projectId: 'fitmirrorfyp',
    authDomain: 'fitmirrorfyp.firebaseapp.com',
    storageBucket: 'fitmirrorfyp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBP4p-hG8fu0_6qulOVDubpD1TtDD5MR1w',
    appId: '1:276799056898:android:fccc3c7d6ecae63f120b1b',
    messagingSenderId: '276799056898',
    projectId: 'fitmirrorfyp',
    storageBucket: 'fitmirrorfyp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBP4p-hG8fu0_6qulOVDubpD1TtDD5MR1w',
    appId: '1:276799056898:ios:1e7ea77e10b1e9fb4946b3',
    messagingSenderId: '276799056898',
    projectId: 'fitmirrorfyp',
    storageBucket: 'fitmirrorfyp.firebasestorage.app',
    iosBundleId: 'com.example.fitMirrorProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBP4p-hG8fu0_6qulOVDubpD1TtDD5MR1w',
    appId: '1:276799056898:ios:1e7ea77e10b1e9fb4946b3',
    messagingSenderId: '276799056898',
    projectId: 'fitmirrorfyp',
    storageBucket: 'fitmirrorfyp.firebasestorage.app',
    iosBundleId: 'com.example.fitMirrorProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBP4p-hG8fu0_6qulOVDubpD1TtDD5MR1w',
    appId: '1:276799056898:web:c2232a26b2222d4e4946b3',
    messagingSenderId: '276799056898',
    projectId: 'fitmirrorfyp',
    authDomain: 'fitmirrorfyp.firebaseapp.com',
    storageBucket: 'fitmirrorfyp.firebasestorage.app',
  );
}