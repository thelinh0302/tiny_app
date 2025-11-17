import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase for Web is not configured in this project.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        // If you plan to support macOS, ensure a Firebase macOS app is created
        // and update these options accordingly. Using iOS options by default.
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // From android/app/google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqgDAYBPnIjfglte-Eba0o-YRrtfO8eow',
    appId: '1:822867620295:android:bf557f03ad090a42a529e2',
    messagingSenderId: '822867620295',
    projectId: 'finly-9144e',
    storageBucket: 'finly-9144e.firebasestorage.app',
  );

  // From ios/Runner/GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcU3QTiNRrtoVjWqlAzqvQWU4UDFaKoTc',
    appId: '1:822867620295:ios:56e1fb2c285e63eda529e2',
    messagingSenderId: '822867620295',
    projectId: 'finly-9144e',
    storageBucket: 'finly-9144e.firebasestorage.app',
    iosBundleId: 'com.example.finlyApp',
    iosClientId:
        '822867620295-hcnfqlgq7thhapn0uuq7659uqj8ho964.apps.googleusercontent.com',
  );
}
