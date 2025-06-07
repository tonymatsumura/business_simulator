// This file contains the Firebase configuration for your project.
// Use this for web and mobile. Do NOT commit secrets to public repos.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // For mobile, use the default options from google-services.json/GoogleService-Info.plist
    return const FirebaseOptions(
      apiKey: 'AIzaSyA8IytufarAxdkeTK03I26rDmnNcxtAIcQ',
      appId: '1:601863123234:web:d2227f9e0aad8f97c6757b',
      messagingSenderId: '601863123234',
      projectId: 'vorteix',
      authDomain: 'vorteix.firebaseapp.com',
      storageBucket: 'vorteix.firebasestorage.app',
      measurementId: 'G-8XWDXTB9J8',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA8IytufarAxdkeTK03I26rDmnNcxtAIcQ',
    appId: '1:601863123234:web:d2227f9e0aad8f97c6757b',
    messagingSenderId: '601863123234',
    projectId: 'vorteix',
    authDomain: 'vorteix.firebaseapp.com',
    storageBucket: 'vorteix.firebasestorage.app',
    measurementId: 'G-8XWDXTB9J8',
  );
}
