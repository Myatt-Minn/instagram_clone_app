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
    apiKey: 'AIzaSyCBlMX12TBjuxvoOuKrhHJ5hO9SkgLwICk',
    appId: '1:520212686883:web:1d5a9f547b86599364e996',
    messagingSenderId: '520212686883',
    projectId: 'coffeeorderapp-d1b69',
    authDomain: 'coffeeorderapp-d1b69.firebaseapp.com',
    storageBucket: 'coffeeorderapp-d1b69.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvAqoukZGSClTpweyPK3RQKDNv0I3BzTw',
    appId: '1:520212686883:android:2ac5199f5b3516a964e996',
    messagingSenderId: '520212686883',
    projectId: 'coffeeorderapp-d1b69',
    storageBucket: 'coffeeorderapp-d1b69.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHjLnO17oSVdVHOowH8qY6Z9uwuGRI_SY',
    appId: '1:520212686883:ios:34c73ce6c08f916664e996',
    messagingSenderId: '520212686883',
    projectId: 'coffeeorderapp-d1b69',
    storageBucket: 'coffeeorderapp-d1b69.appspot.com',
    iosBundleId: 'com.example.firebaseproj',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHjLnO17oSVdVHOowH8qY6Z9uwuGRI_SY',
    appId: '1:520212686883:ios:34c73ce6c08f916664e996',
    messagingSenderId: '520212686883',
    projectId: 'coffeeorderapp-d1b69',
    storageBucket: 'coffeeorderapp-d1b69.appspot.com',
    iosBundleId: 'com.example.firebaseproj',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCBlMX12TBjuxvoOuKrhHJ5hO9SkgLwICk',
    appId: '1:520212686883:web:35702df22db7cf9b64e996',
    messagingSenderId: '520212686883',
    projectId: 'coffeeorderapp-d1b69',
    authDomain: 'coffeeorderapp-d1b69.firebaseapp.com',
    storageBucket: 'coffeeorderapp-d1b69.appspot.com',
  );
}
