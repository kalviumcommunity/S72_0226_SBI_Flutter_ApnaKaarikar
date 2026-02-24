# Firebase Setup Guide

## Overview

This guide will help you set up Firebase for the ApnaKaarikar app to enable Firestore database integration.

---

## Prerequisites

- Firebase account (free tier is sufficient)
- Flutter project
- Internet connection

---

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `apnakaarikar` (or your choice)
4. Disable Google Analytics (optional for now)
5. Click "Create project"

---

## Step 2: Register Your App

### For Android:

1. In Firebase Console, click "Add app" → Android icon
2. Enter Android package name: `com.example.client` (or your package name)
3. Download `google-services.json`
4. Place it in `android/app/` directory

### For iOS:

1. In Firebase Console, click "Add app" → iOS icon
2. Enter iOS bundle ID: `com.example.client` (or your bundle ID)
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

### For Web:

1. In Firebase Console, click "Add app" → Web icon
2. Register app and copy the configuration
3. Update `web/index.html` with Firebase config

---

## Step 3: Enable Firestore

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location (closest to your users)
5. Click "Enable"

---

## Step 4: Configure Firebase in App

### Update `lib/services/firebase_service.dart`:

```dart
static FirebaseOptions _getFirebaseOptions() {
  return const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',              // From Firebase Console
    appId: 'YOUR_APP_ID',                // From Firebase Console
    messagingSenderId: 'YOUR_SENDER_ID', // From Firebase Console
    projectId: 'YOUR_PROJECT_ID',        // From Firebase Console
    storageBucket: 'YOUR_BUCKET',        // From Firebase Console
  );
}
```

Get these values from:
- Firebase Console → Project Settings → General → Your apps

---

## Step 5: Add Sample Data

### Option 1: Using the App

The app includes a method to add sample data:

```dart
final firestoreService = FirestoreService();
await firestoreService.addSampleData();
```

### Option 2: Manual Entry in Firebase Console

1. Go to Firestore Database
2. Create collection: `artists`
3. Add document with fields:
   ```
   name: "Rajesh Kumar"
   craftType: "Traditional Pottery"
   location: "Jaipur, Rajasthan"
   profilePhoto: "placeholder"
   rating: 4.5
   reviewCount: 23
   createdAt: [timestamp]
   ```

4. Create collection: `products`
5. Add documents with fields:
   ```
   artistId: [artist document ID]
   name: "Handcrafted Clay Pot"
   price: 450
   imageUrl: "placeholder"
   inStock: true
   description: "Beautiful handcrafted clay pot..."
   createdAt: [timestamp]
   ```

---

## Step 6: Update Firestore Rules

For development, use these rules (Firebase Console → Firestore → Rules):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read access to all
    match /{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

⚠️ **Warning:** These rules are for development only. Update for production!

---

## Step 7: Test the Integration

### Enable Firestore in App:

In `lib/screens/artist_catalog_screen.dart`, change:

```dart
bool _useMockData = true;  // Change to false
```

to:

```dart
bool _useMockData = false;  // Use Firestore
```

### Run the App:

```bash
flutter pub get
flutter run
```

---

## Firestore Collections Structure

### Artists Collection

```
artists/
  {artistId}/
    - name: string
    - craftType: string
    - location: string
    - profilePhoto: string
    - rating: number
    - reviewCount: number
    - createdAt: timestamp
```

### Products Collection

```
products/
  {productId}/
    - artistId: string (reference to artist)
    - name: string
    - price: number
    - imageUrl: string
    - inStock: boolean
    - description: string
    - createdAt: timestamp
```

---

## Troubleshooting

### Issue: Firebase not initializing

**Solution:** Check if `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in the correct location.

### Issue: Firestore permission denied

**Solution:** Update Firestore rules to allow read access.

### Issue: No data showing

**Solution:** 
1. Check if data exists in Firestore Console
2. Verify `artistId` matches in products
3. Check console for error messages

### Issue: App crashes on startup

**Solution:** 
1. Ensure Firebase is properly initialized
2. Check if all dependencies are installed: `flutter pub get`
3. Try running with mock data first (`_useMockData = true`)

---

## Development Mode

For development without Firebase:

1. Keep `_useMockData = true` in `artist_catalog_screen.dart`
2. App will use mock data instead of Firestore
3. All features work without Firebase connection

---

## Production Checklist

Before deploying to production:

- [ ] Update Firestore security rules
- [ ] Add proper authentication
- [ ] Enable Firebase App Check
- [ ] Set up proper indexes
- [ ] Configure backup and recovery
- [ ] Monitor usage and costs
- [ ] Add error tracking (Firebase Crashlytics)

---

## Useful Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Clean build
flutter clean
flutter pub get
flutter run

# Check Firebase connection
# (Add debug logs in firebase_service.dart)
```

---

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Console](https://console.firebase.google.com/)

---

## Next Steps

After Firebase is set up:

1. Test reading data from Firestore
2. Implement authentication (Day 11)
3. Add product CRUD operations (Day 12)
4. Integrate Firebase Storage for images (Day 13)

---

## Support

If you encounter issues:

1. Check Firebase Console for errors
2. Review app logs for error messages
3. Verify all configuration files are in place
4. Test with mock data first
5. Check Firestore rules and permissions
