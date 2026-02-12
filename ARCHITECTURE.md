# ID Express - App Architecture

## 📱 App Flow

```
┌─────────────┐
│   App Start │
└──────┬──────┘
       │
       ▼
┌──────────────────────┐
│  Firebase Init       │
│  & Auth Check        │
└──────┬───────────────┘
       │
       ├─ User Logged In → Upload Screen
       │
       └─ User Not Logged In
                │
                ▼
        ┌───────────────┐
        │ Login Screen  │
        └───────┬───────┘
                │
        ┌───────┴──────┐
        │              │
        ▼              ▼
    [Login]       [Sign Up]
        │              │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │Upload Screen │
        └──────┬───────┘
               │
        ┌──────┴──────┐
        │             │
        ▼             ▼
   [Upload Doc] [View Documents]
        │             │
        └──────┬──────┘
               │
               ▼
        ┌──────────────────────┐
        │ Firestore & Storage  │
        │ (Data Persistence)   │
        └──────────────────────┘
```

## 🏗️ Component Architecture

### Frontend Layer (Screens)
- **LoginScreen**: Email/password authentication
- **SignupScreen**: New user registration with profile
- **UploadScreen**: Document capture and submission
- **DocumentsListScreen**: View and manage uploaded documents

### Business Logic Layer (Services)
- **AuthService**: Firebase Auth operations
  - Sign up
  - Login
  - Logout
  - Error handling

- **StorageService**: Firebase Storage operations
  - Upload images
  - Delete images
  - URL retrieval

- **FirestoreService**: Firestore database operations
  - Save user profiles
  - Save document records
  - Retrieve user documents
  - Retrieve user profile

### Data Layer (Firebase)
```
Firebase Project
├── Authentication
│   └── Email/Password auth
├── Firestore Database
│   ├── users collection
│   │   ├── uid (doc ID)
│   │   ├── email
│   │   ├── fullName
│   │   └── createdAt
│   │
│   └── documents collection
│       ├── uid (user ID)
│       ├── documentType
│       ├── idNumber
│       ├── fullName
│       ├── imageUrl
│       ├── createdAt
│       └── status
│
└── Cloud Storage
    └── users/
        └── {uid}/
            └── documents/
                ├── National ID/
                │   └── [images]
                ├── Passport/
                │   └── [images]
                └── Driver License/
                    └── [images]
```

## 🔄 Data Flow

### Sign Up Flow
```
User Input (Email, Password, Name)
    ↓
AuthService.signUp()
    ↓
Firebase Auth (Create User)
    ↓
FirestoreService.saveUserProfile()
    ↓
Firestore (Save User Data)
    ↓
Navigate to Upload Screen
```

### Document Upload Flow
```
User Input (Type, Name, ID Number)
    ↓
User Selects Image
    ↓
StorageService.uploadDocumentImage()
    ↓
Firebase Storage (Upload File)
    ↓
Get Download URL
    ↓
FirestoreService.saveDocumentRecord()
    ↓
Firestore (Save Metadata)
    ↓
Show Success Message
```

### View Documents Flow
```
User Opens Document List
    ↓
FirestoreService.getUserDocuments()
    ↓
Query Firestore (uid == currentUser)
    ↓
Return Document List
    ↓
Display with Images (from Storage URLs)
```

## 🔐 Security Model

### Authentication
- Firebase Auth (email/password)
- User ID tied to all documents
- Automatic session management

### Firestore Security Rules
```
users collection:
  → Read/Write: Only by document owner (uid)

documents collection:
  → Read/Write: Only by document owner (uid)
  → Create: Only by authenticated users
```

### Storage Security Rules
```
users/{uid}/* :
  → Read/Write: Only by {uid}
  → Prevents cross-user file access
```

## 📊 Dependencies

### Firebase Packages
- `firebase_core` - Core Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `firebase_storage` - File storage

### UI Packages
- `flutter` - Core framework
- `image_picker` - Camera/gallery access

### Utilities
- Built-in Flutter widgets (Material Design)
- Text controllers for form input
- Future builders for async operations

## 🎯 State Management Strategy

**No external state management** (as requested)

Using:
- `setState()` for local UI state
- Service classes for business logic
- Singleton pattern (single instance of services)
- FutureBuilder for async data

Benefits:
- Simple architecture
- Easy to understand
- Low overhead
- Suitable for demo/MVP

## 📱 Platform Support

**Implemented for**:
- ✅ Android (Primary)

**Optional**:
- iOS (requires GoogleService-Info.plist)
- Web (requires web configuration)

## 🚀 Performance Considerations

1. **Image Upload**
   - Compress images to 80% quality
   - Async upload prevents UI freezing

2. **Database Queries**
   - Query by uid for user-specific data
   - Server-side filtering (Firestore)

3. **Error Handling**
   - Try-catch blocks in services
   - User-friendly error messages

## 🔧 Configuration Files

- `android/app/src/main/AndroidManifest.xml` - Permissions
- `android/app/build.gradle.kts` - Android build config
- `lib/firebase_options.dart` - Firebase credentials (NEEDS UPDATE)
- `pubspec.yaml` - Dependencies

## 📈 Scalability Path

For production:
1. Add Cloud Functions for document processing
2. Implement admin dashboard
3. Add OCR for automatic data extraction
4. Implement notification system
5. Add analytics
6. Database backups and disaster recovery
