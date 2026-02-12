# ID Express - Document Registration App

A Flutter application for registering national IDs and passports using Firebase backend.

## Features

- **User Authentication**: Sign up and login with Firebase Auth
- **Document Upload**: Capture and upload document images
- **Cloud Storage**: Store documents securely in Firebase Storage
- **Database**: Store document metadata in Firestore
- **Document List**: View all uploaded documents with verification status

## Project Structure

```
lib/
├── main.dart                 # App entry point and routing
├── firebase_options.dart     # Firebase configuration (REQUIRES UPDATE)
├── services/
│   ├── auth_service.dart      # Authentication logic
│   ├── firestore_service.dart # Firestore database operations
│   └── storage_service.dart   # Firebase Storage operations
└── screens/
    ├── login_screen.dart        # Login screen
    ├── signup_screen.dart       # Sign up screen
    ├── upload_screen.dart       # Document upload screen
    └── documents_list_screen.dart # View uploaded documents
```

## Firestore Collections Structure

### users
- `uid` (document ID)
- `email` (string)
- `fullName` (string)
- `createdAt` (timestamp)

### documents
- `uid` (string) - User ID
- `documentType` (string) - National ID, Passport, etc.
- `idNumber` (string) - Document number
- `fullName` (string) - User name
- `imageUrl` (string) - URL to image in Firebase Storage
- `createdAt` (timestamp)
- `status` (string) - pending, approved, rejected

## Setup Instructions

### 1. Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or use existing one
3. Enable the following services:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage
4. Copy your project credentials

### 2. Update Firebase Configuration

Update `lib/firebase_options.dart` with your Firebase project credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_STORAGE_BUCKET',
);
```

### 3. Android Setup

1. Go to `android/app/build.gradle.kts`
2. Ensure `minSdkVersion` is at least 21
3. Add Google Services plugin (already configured)

### 4. iOS Setup (Optional)

1. Generate iOS configuration from Firebase Console
2. Download `GoogleService-Info.plist`
3. Place in `ios/Runner/` directory
4. Add to Xcode project

### 5. Firestore Security Rules

Set these security rules in Firebase Console:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Users can read/write their own documents
    match /documents/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
      allow create: if request.auth.uid == request.resource.data.uid;
    }
  }
}
```

### 6. Firebase Storage Rules

Set these security rules in Firebase Console:

```firestore
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{uid}/{allPaths=**} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

## Running the App

```bash
# Get dependencies
flutter pub get

# Run on Android device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>
```

## Testing

1. **Sign Up**: Create a new account with email and password
2. **Login**: Login with created credentials
3. **Upload Document**: 
   - Select document type
   - Enter name and ID number
   - Take a photo of the document
   - Click "Upload Document"
4. **View Documents**: Click "My Documents" to see uploaded documents

## Dependencies

- `firebase_core` - Firebase initialization
- `firebase_auth` - User authentication
- `cloud_firestore` - Database
- `firebase_storage` - File storage
- `image_picker` - Camera/gallery access

## Next Steps

1. **Cloud Functions**: Set up Cloud Functions for automated document processing
2. **Admin Dashboard**: Create admin interface for document verification
3. **Push Notifications**: Notify users when documents are verified
4. **OCR Integration**: Automatically extract data from document images
5. **Payment Integration**: Add payment processing if required

## Troubleshooting

### Firebase not initializing
- Ensure `firebase_options.dart` has correct credentials
- Check Firebase Console for correct project selected

### Camera permission denied (Android)
- Add camera permission to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### Images not uploading
- Check Firebase Storage security rules
- Verify Firebase project ID in `firebase_options.dart`
- Check network connectivity

## Support

For issues or questions, please refer to:
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase CLI Setup](https://firebase.google.com/docs/cli)
