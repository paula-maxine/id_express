# ID Express - Complete Setup & Implementation Guide

## 📋 Overview

ID Express is a Flutter app for registering national IDs and passports using Firebase. This guide covers the complete setup from Firebase configuration to testing.

## ✅ Implementation Status

| Component | Status | Notes |
|-----------|--------|-------|
| Flutter Project Structure | ✅ Complete | All screens and services created |
| Firebase Integration | ✅ Complete | Dependencies added, services implemented |
| Authentication Flow | ✅ Complete | Login/Signup with Firebase Auth |
| Document Upload | ✅ Complete | Image capture + Firebase Storage |
| Database Schema | ✅ Complete | Firestore collections defined |
| Security Rules | ⚠️ Pending | Requires Firebase Console setup |
| Error Handling | ✅ Complete | User-friendly error messages |
| Code Quality | ✅ Complete | No linting errors, follows best practices |

## 🔴 Critical Setup Required

Before running the app, you **MUST** complete these Firebase steps:

### Step 1: Create Firebase Project
1. Visit [Firebase Console](https://console.firebase.google.com)
2. Click "Create Project"
3. Name it "id-express" (or your choice)
4. Accept Firebase terms, choose location
5. Click "Create Project" and wait for completion

### Step 2: Add Android App to Project
1. In Firebase Console, click "Add App" → "Android"
2. Package name: `com.example.id_express`
3. Download `google-services.json`
4. Copy to `android/app/` directory

### Step 3: Get Firebase Credentials
1. Go to **Project Settings** (gear icon)
2. Select **Your Apps** → **Android**
3. Copy these values:
   - **API Key** (under "Web API key")
   - **App ID** (from Your apps section)
   - **Project ID**
   - **Storage Bucket** (format: `project-id.appspot.com`)

### Step 4: Update Firebase Options
Edit `lib/firebase_options.dart` and replace the Android section:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyC_YOUR_API_KEY_HERE',
  appId: '1:123456789:android:abcdef123456',
  messagingSenderId: '123456789',
  projectId: 'id-express-xxxxx',
  storageBucket: 'id-express-xxxxx.appspot.com',
);
```

### Step 5: Enable Firebase Services

In Firebase Console, enable:

**1. Authentication**
- Go to **Build** → **Authentication**
- Click **Sign-up method**
- Enable **Email/Password**
- Click **Save**

**2. Firestore Database**
- Go to **Build** → **Firestore Database**
- Click **Create Database**
- Location: Choose closest region
- Start in **Test mode** (for development)
- Click **Create**

**3. Cloud Storage**
- Go to **Build** → **Storage**
- Click **Get Started**
- Default location: OK
- Click **Done**

### Step 6: Set Firestore Security Rules

1. In Firestore, go to **Rules** tab
2. Replace all content with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User profiles - only user can read/write own profile
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Documents - user can read/write their own documents
    match /documents/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
      allow create: if request.auth.uid == request.resource.data.uid;
    }
  }
}
```

3. Click **Publish**

### Step 7: Set Storage Security Rules

1. In Storage, go to **Rules** tab
2. Replace all content with:

```firestore
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can only access their own folder
    match /users/{uid}/{allPaths=**} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

3. Click **Publish**

## 🚀 Running the App

### Prerequisites
- Android device or emulator with API 21+
- Internet connection (for Firebase)
- Flutter SDK installed

### Start App

```bash
# Navigate to project
cd e:\Apps-Paula\id_express

# Get dependencies (already done, but ensures latest)
flutter pub get

# Run app
flutter run

# Or on specific device
flutter devices
flutter run -d <device-id>
```

### First Time Run
- App will compile (takes 2-3 minutes)
- Might prompt for Android SDK components
- App launches to Login screen

## 🧪 Testing Workflow

### Test 1: User Registration
1. Click "Sign up"
2. Enter:
   - Full Name: `John Doe`
   - Email: `test@example.com`
   - Password: `Test123456` (min 6 chars)
   - Confirm Password: `Test123456`
3. Click "Sign Up"
4. Should see success and redirect to Upload screen

✅ Check Firebase:
- In Firebase Console → Authentication → Users
- Should see new user with your email

### Test 2: Document Upload
1. On Upload screen, select:
   - Document Type: `National ID`
   - Full Name: `John Doe`
   - ID Number: `123456789`
2. Tap image area to take photo
3. Take a photo or select from gallery
4. Click "Upload Document"
5. Should see success dialog

✅ Check Firebase:
- **Storage**: `users/{uid}/documents/National ID/{filename}.jpg`
- **Firestore**: `documents` collection should have new record
- **Firestore**: `users` collection should have user profile

### Test 3: View Documents
1. Click menu (⋮) → "My Documents"
2. Should see uploaded document with image
3. Status should be "Pending"

### Test 4: Logout & Login
1. Click menu (⋮) → "Logout"
2. Should return to Login screen
3. Click "Login"
4. Enter email and password
5. Should go back to Upload screen

### Test 5: Multiple Documents
1. Upload different document types:
   - Passport
   - Driver License
2. View in "My Documents"
3. All should appear with different statuses

## 🐛 Common Issues & Solutions

### Issue: "FirebaseException: Project ID is not set"
**Solution**: Update `firebase_options.dart` with correct credentials

### Issue: "Camera permission denied"
**Solution**:
1. Go to Phone Settings → Apps → ID Express → Permissions
2. Enable Camera and Storage

### Issue: "Image upload fails silently"
**Solution**:
1. Check Storage bucket name in firebase_options.dart
2. Ensure Storage security rules are published
3. Check internet connection
4. Try uploading smaller image

### Issue: "Can't see documents in list"
**Solution**:
1. Refresh app (hot restart: Ctrl+Shift+R)
2. Check Firestore has documents collection
3. Verify document has correct uid field

### Issue: "Firestore collection not created"
**Solution**:
- Collections auto-create on first write
- Try uploading a document
- Check Firestore in 30 seconds

### Issue: "App keeps redirecting to login"
**Solution**:
1. Check Firebase Auth is properly configured
2. Verify AuthWrapper in main.dart
3. Restart app completely

## 📁 Project Structure Reference

```
id_express/
├── lib/
│   ├── main.dart                 # App entry, routing
│   ├── firebase_options.dart     # EDIT: Firebase creds
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   └── storage_service.dart
│   └── screens/
│       ├── login_screen.dart
│       ├── signup_screen.dart
│       ├── upload_screen.dart
│       └── documents_list_screen.dart
│
├── android/
│   ├── app/
│   │   └── google-services.json  # ADD: Firebase config
│   └── ...
│
├── pubspec.yaml                  # Dependencies (done)
├── pubspec.lock                  # Locks versions
├── QUICK_START.md               # Quick reference
├── ARCHITECTURE.md              # System design
└── SETUP_GUIDE.md              # Detailed guide
```

## 📊 Firebase Data Models

### users collection
```json
{
  "email": "test@example.com",
  "fullName": "John Doe",
  "createdAt": "2026-02-12T10:30:00Z"
}
```

### documents collection
```json
{
  "uid": "user123",
  "documentType": "National ID",
  "idNumber": "123456789",
  "fullName": "John Doe",
  "imageUrl": "https://storage.googleapis.com/...",
  "createdAt": "2026-02-12T10:35:00Z",
  "status": "pending"
}
```

## 🔐 Security Checklist

- [x] User data encrypted in transit (Firebase HTTPS)
- [x] User-specific security rules in Firestore
- [x] Storage rules prevent cross-user access
- [x] Auth UI prevents anonymous access
- [x] Error messages don't leak sensitive info
- [ ] Enable two-factor auth (optional, future)
- [ ] Enable reCAPTCHA (optional, future)

## 📞 Support Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Auth Guide](https://firebase.google.com/docs/auth)
- [Firestore Guide](https://firebase.google.com/docs/firestore)
- [Storage Guide](https://firebase.google.com/docs/storage)

## 🎯 Next Steps After Testing

1. **Customize Branding**
   - Change app name in `android/app/AndroidManifest.xml`
   - Update app icon
   - Customize colors in main.dart theme

2. **Add More Features**
   - Email verification
   - Password reset
   - User profile screen
   - Document deletion

3. **Production Deployment**
   - Disable test mode in Firestore
   - Implement stricter security rules
   - Set up monitoring
   - Configure backups

4. **Advanced Features**
   - Cloud Functions for processing
   - Admin dashboard
   - OCR integration
   - Email notifications

## ⚡ Performance Tips

- Images are compressed to 80% quality
- Async operations prevent UI freezing
- Firestore queries filtered by user ID
- FutureBuilder for efficient loading

## 📝 Troubleshooting Checklist

Before reporting issues, verify:
- [ ] Firebase credentials correctly copied
- [ ] Security rules published in Firebase
- [ ] Internet connection working
- [ ] Android device has API 21+
- [ ] `google-services.json` in `android/app/`
- [ ] All Firebase services enabled

## ✨ Success Indicators

You'll know setup is complete when:
- [ ] App runs without crashes
- [ ] Sign up creates user in Firebase Auth
- [ ] Document upload creates Firestore record
- [ ] Images appear in Storage bucket
- [ ] Documents list shows uploaded items
- [ ] Can logout and login again

---

**Last Updated**: February 12, 2026
**App Version**: 1.0.0
**Status**: Ready for Firebase Setup & Testing
