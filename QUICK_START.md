# ID Express - Quick Start Checklist

## ✅ Completed Setup
- [x] Flutter project initialized
- [x] Firebase dependencies added
- [x] Service layer created (Auth, Firestore, Storage)
- [x] UI screens implemented (Login, Signup, Upload, Document List)
- [x] App structure configured with routing

## 📋 Next Steps - Firebase Configuration

### 1. Get Firebase Credentials
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project (or use existing)
3. Go to **Project Settings** → **Your Apps**
4. Select Android (for initial demo)
5. Copy credentials:
   - API Key
   - App ID
   - Messaging Sender ID
   - Project ID
   - Storage Bucket

### 2. Update `lib/firebase_options.dart`
Replace the placeholders in the android section with your actual credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaS...',  // Your API Key
  appId: '1:123456789:android:abc...', // Your App ID
  messagingSenderId: '123456789', // Your Sender ID
  projectId: 'your-project-id', // Your Project ID
  storageBucket: 'your-project-id.appspot.com', // Your Storage Bucket
);
```

### 3. Enable Firebase Services
In Firebase Console, enable these services:
- ✅ Authentication (Email/Password)
- ✅ Firestore Database (Start in test mode for development)
- ✅ Cloud Storage

### 4. Configure Security Rules

**Firestore Rules:**
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    match /documents/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
      allow create: if request.auth.uid == request.resource.data.uid;
    }
  }
}
```

**Storage Rules:**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{uid}/{allPaths=**} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

### 5. Android Permissions
The app already has camera permissions configured. Check `android/app/src/main/AndroidManifest.xml` has:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### 6. Run the App
```bash
# Get latest dependencies
flutter pub get

# Run on Android device/emulator
flutter run

# Or specify a device
flutter devices  # List available devices
flutter run -d <device-id>
```

## 📝 Testing Workflow

1. **Sign Up**
   - Enter email, password, and full name
   - Click "Sign Up"
   - Should redirect to upload screen

2. **Upload Document**
   - Select document type (National ID, Passport, Driver License)
   - Enter full name
   - Enter ID number
   - Tap to take a photo
   - Click "Upload Document"
   - Should see success message

3. **View Documents**
   - Click menu → "My Documents"
   - Should see uploaded documents with images and status

4. **Logout**
   - Click menu → "Logout"
   - Should return to login screen

## 🐛 Troubleshooting

### Firebase Not Initializing
- Check `firebase_options.dart` credentials are correct
- Verify project ID matches Firebase Console
- Ensure internet connection

### Camera Not Working
- Test on actual Android device (emulator may have issues)
- Check app permissions in phone settings
- Ensure `image_picker` permissions are granted

### Images Not Uploading
- Check Firebase Storage bucket name in `firebase_options.dart`
- Verify storage security rules are set correctly
- Check file size (very large files may timeout)

### Firestore Collection Not Created
- Collections are auto-created when first document is added
- Try uploading a document to trigger collection creation
- Check Firestore in Firebase Console under **Data** tab

## 📂 Project Structure

```
lib/
├── main.dart                      # App entry, routing, auth wrapper
├── firebase_options.dart          # Firebase configuration (EDIT THIS)
├── services/
│   ├── auth_service.dart          # Firebase Auth logic
│   ├── firestore_service.dart     # Firestore operations
│   └── storage_service.dart       # File upload logic
└── screens/
    ├── login_screen.dart          # User login
    ├── signup_screen.dart         # User registration
    ├── upload_screen.dart         # Document upload
    └── documents_list_screen.dart # View uploaded documents
```

## 🚀 Next Phase Features (Optional)

- Cloud Functions for document processing
- Admin dashboard for verification
- Push notifications
- OCR for automatic data extraction
- Email confirmations
- Two-factor authentication
- Document history and analytics

---

**Status**: Ready for Firebase configuration and testing
**Last Updated**: February 2026
