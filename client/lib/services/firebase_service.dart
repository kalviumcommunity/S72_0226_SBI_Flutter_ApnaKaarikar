import 'package:firebase_core/firebase_core.dart';

/// Firebase Service
/// Handles Firebase initialization
class FirebaseService {
  static bool _initialized = false;

  /// Initialize Firebase
  /// Call this before using any Firebase services
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp(
        options: _getFirebaseOptions(),
      );
      _initialized = true;
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization failed: $e');
      // Continue without Firebase for development
      _initialized = false;
    }
  }

  /// Get Firebase options based on platform
  static FirebaseOptions _getFirebaseOptions() {
    // TODO: Replace with your Firebase project configuration
    // Get these values from Firebase Console > Project Settings
    return const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      projectId: 'YOUR_PROJECT_ID',
      // For Android
      // storageBucket: 'YOUR_STORAGE_BUCKET',
      // For iOS
      // iosBundleId: 'YOUR_IOS_BUNDLE_ID',
    );
  }

  /// Check if Firebase is initialized
  static bool get isInitialized => _initialized;
}
