import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'Only web is configured. Android and iOS are added later.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB5_mlfccWF5w61UWCXiSB_NI8KwQt43U4',
    appId: '1:546134714366:web:d3f8e27e3a655f8b3b02af',
    messagingSenderId: '546134714366',
    projectId: 'campus-lost-found-7fa43',
    authDomain: 'campus-lost-found-7fa43.firebaseapp.com',
    storageBucket: 'campus-lost-found-7fa43.firebasestorage.app',
  );
}