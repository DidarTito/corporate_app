# Quick Start: Firebase Setup for Corporate App

## 1️⃣ Prerequisites
- Firebase project created
- Firebase enabled in pubspec.yaml (already done ✓)
- Android/iOS configured with Firebase

## 2️⃣ Initial Setup (One-Time)

### In Firebase Console:

```
1. Go to: https://console.firebase.google.com/
2. Select your project
3. Click on "Firestore Database"
4. Click "Create Database"
5. Choose "Start in production mode"
6. Select your region (e.g., "eur3" for Europe)
```

## 3️⃣ Add Sample Data (Development)

### Quick Method - Firebase Console UI:

**Create News Collection:**
```
1. Click "+ Create collection" 
2. Collection ID: news
3. Document ID: news1
4. Add these fields:
   - id: news1
   - title: "Company News"
   - content: "Lorem ipsum..."
   - publishDate: (current date)
   - author: "HR Team"
   - isCorporate: true
   - tags: ["company"]
```

**Create Vacancies Collection:**
```
1. Click "+ Create collection"
2. Collection ID: vacancies
3. Document ID: vac1
4. Add fields:
   - id: vac1
   - title: "Project Manager"
   - description: "Seeking experienced PM..."
   - location: "Almaty"
   - latitude: 43.2220
   - longitude: 76.8512
   - projectType: "construction"
   - publishDate: (current date)
```

**Create Training Materials:**
```
1. Click "+ Create collection"
2. Collection ID: training_materials
3. Document ID: tm1
4. Add fields:
   - id: tm1
   - title: "Safety Guide"
   - description: "Company safety procedures..."
   - category: "master"
   - publishDate: (current date)
   - isMemo: true
```

## 4️⃣ Update Firebase Rules

Go to: **Firestore Database → Rules**

Replace with:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
      match /{document=**} {
        allow read, write: if request.auth.uid == uid;
      }
    }
    
    // Public collections readable by authenticated users
    match /news/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    match /vacancies/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    match /training_materials/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

Click "Publish"

## 5️⃣ Test in App

### Run the app:
```bash
flutter run
```

### Test data loading:
1. Login with test account
2. Go to "Company" tab
3. Check if news/vacancies appear
4. Go to "Finance" to check finance data
5. Go to "Help" to see FAQ

### Expected behavior:
- ✅ Loads Firebase data if available
- ✅ Shows mock data if offline
- ✅ No errors in console

## 6️⃣ Add User Finance Data

In Firebase Console:

```
1. Go to: Firestore → users → [USER_UID]
2. Create subcollection: finance
3. Create document: info
4. Add fields:
   - currentObject: "Project Alpha"
   - totalShiftsWorked: 45
   - trainingDeductions: 5000
   - totalBalance: 150000
   - history: [array of FinanceHistoryItem]
```

## 7️⃣ Common Issues & Fix

### Data not appearing?
```
1. Check: Is user logged in? (required for auth)
2. Check: Firestore rules updated? (publish required)
3. Check: Collection names exact match? (case-sensitive)
4. Check: Network connection? (app shows mock data offline)
```

### How to debug:
```dart
// In any screen, add this to check if data loads:
print('News count: ${_news.length}');
```

### Force mock data:
```dart
// In company_screen.dart, modify _loadData():
Future<void> _loadData() async {
  _loadMockData(); // Comment out Firebase code
  setState(() => _isLoading = false);
}
```

## 8️⃣ Add Real Images

### Option A: Firebase Storage
```
1. Go to: Firebase Console → Storage
2. Create folder: news_images
3. Upload image
4. Copy download URL
5. Paste in news document imageUrl field
```

### Option B: External URL
```
Just use any image URL:
imageUrl: "https://example.com/image.jpg"
```

## 9️⃣ Batch Import CSV Data

Use this Node.js script:

```javascript
// install-data.js
const admin = require('firebase-admin');
const csv = require('csv-parse/sync');
const fs = require('fs');

admin.initializeApp();
const db = admin.firestore();

async function importNews() {
  const data = fs.readFileSync('./news.csv', 'utf8');
  const records = csv.parse(data, { columns: true });
  
  for (const record of records) {
    await db.collection('news').doc(record.id).set({
      id: record.id,
      title: record.title,
      content: record.content,
      publishDate: new Date(record.publishDate),
      author: record.author,
      isCorporate: record.isCorporate === 'true',
      tags: record.tags?.split(',') || []
    });
  }
  console.log('✅ News imported');
}

importNews().catch(console.error);
```

## 🔟 Production Checklist

- [ ] Firestore database created
- [ ] Collections created (news, vacancies, training_materials)
- [ ] Firestore rules updated
- [ ] Initial data added
- [ ] App tested on device
- [ ] Login working
- [ ] Data displays correctly
- [ ] Images load
- [ ] Offline mode works (shows mock data)
- [ ] Released to Play Store/App Store

## 📞 Support URLs

- Firebase Docs: https://firebase.google.com/docs
- Firestore Guide: https://firebase.google.com/docs/firestore
- Flutter Firebase: https://firebase.flutter.dev/
- Troubleshooting: See FIREBASE_GUIDE.md

---

**Setup Time**: ~10 minutes  
**Data Import Time**: ~5 minutes per collection  
**Status**: Ready to go! 🚀
