# Firebase Security Rules - Testing Mode

## Step 1: Go to Firebase Console
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Click your project
3. Go to **Build** → **Firestore Database**
4. Click the **Rules** tab

## Step 2: Replace with TEST Rules (for debugging only)
Copy and paste this:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // TEMPORARILY ALLOW EVERYTHING FOR TESTING
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Step 3: Publish Rules
Click **Publish** button

## Step 4: Test in App
1. **Hot Reload** or **Restart** your Flutter app (Ctrl+S to hot reload)
2. Go to **Profile** → **Edit Profile**
3. Change any field (e.g., phone number)
4. Click **Save**
5. **CHECK DEBUG CONSOLE** for log messages
6. Go back to **Firebase Console → Firestore** and refresh
7. You should now see the `users` collection with data

## Step 5: Once it works, use SECURE Rules

Once data appears in Firebase, replace with secure rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{uid} {
      allow read: if request.auth.uid == uid;
      allow write: if request.auth.uid == uid;
    }
    
    // Public collections (news, vacancies, training materials)
    match /news/{document=**} {
      allow read: if request.auth != null;
    }
    
    match /vacancies/{document=**} {
      allow read: if request.auth != null;
    }
    
    match /training_materials/{document=**} {
      allow read: if request.auth != null;
    }
  }
}
```

## Checklist Before Testing:
- [ ] App is hot-reloaded with latest changes
- [ ] You are logged in to the app
- [ ] Security rules are set to TEST mode (allowing all writes)
- [ ] You clicked the "Save Changes" button in Edit Profile
- [ ] You can see log messages in the console (like `[AuthProvider] updateProfile:`)
- [ ] Firebase Console Firestore is refreshed
