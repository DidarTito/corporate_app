# Firebase Database Guide - Corporate App

This guide explains how to set up and manage data in Firebase Firestore for the Corporate App Release 2.

## Database Structure

### 1. Users Collection (`/users/{uid}`)

**Profile Document:**
```json
{
  "uid": "user-unique-id",
  "name": "John Doe",
  "email": "john@example.com",
  "iin": "123456789012",
  "position": "Project Manager",
  "phoneNumber": "+7 777 123 4567",
  "clothingSize": "M",
  "shoeSize": "42",
  "photoUrl": "https://example.com/photo.jpg",
  "rating": 4.5,
  "awards": ["Best Employee 2023", "Safety Award"],
  "status": "active",  // active, vacation, transfer
  "balance": 150000.0,
  "shiftsWorked": 45,
  "createdAt": "2023-01-15T10:30:00Z"
}
```

**Children Subcollection (`/users/{uid}/children/{childId}`):**
```json
{
  "name": "Maria Doe",
  "birthDate": "2015-06-20",
  "certificateNumber": "CERT-12345",
  "socialPackageInfo": "Family package A"
}
```

**Finance Subcollection (`/users/{uid}/finance/info`):**
```json
{
  "currentObject": "Project Alpha",
  "totalShiftsWorked": 45,
  "trainingDeductions": 5000.0,
  "totalBalance": 150000.0,
  "history": [
    {
      "id": "1",
      "objectName": "Project Alpha",
      "completedVolume": 1000.0,
      "payment": 50000.0,
      "date": "2024-01-15T10:30:00Z",
      "shiftsWorked": 15
    }
  ]
}
```

### 2. News Collection (`/news/{newsId}`)

**News Document:**
```json
{
  "id": "news1",
  "title": "Company Expansion Announcement",
  "content": "We are excited to announce...",
  "imageUrl": "https://example.com/news1.jpg",
  "videoUrl": "https://example.com/video.mp4",
  "publishDate": "2024-02-10T14:30:00Z",
  "author": "HR Department",
  "isCorporate": true,
  "tags": ["company", "expansion", "news"]
}
```

### 3. Vacancies Collection (`/vacancies/{vacancyId}`)

**Vacancy Document:**
```json
{
  "id": "vac1",
  "title": "Construction Project Manager",
  "description": "Looking for experienced project manager...",
  "location": "Almaty",
  "latitude": 43.2220,
  "longitude": 76.8512,
  "projectType": "construction",
  "publishDate": "2024-02-12T10:00:00Z"
}
```

### 4. Training Materials Collection (`/training_materials/{materialId}`)

**Training Material Document:**
```json
{
  "id": "tm1",
  "title": "Safety Guidelines for Masters",
  "description": "Important safety procedures...",
  "category": "master",  // master, installer, foreman
  "fileUrl": "https://example.com/safety_guide.pdf",
  "imageUrl": "https://example.com/thumb.jpg",
  "publishDate": "2024-02-01T09:00:00Z",
  "isMemo": true
}
```

### 5. Bonus Information (`/users/{uid}/bonus/info`)

**Bonus Document:**
```json
{
  "points": 1250,
  "balance": 5000.0,
  "availableRewards": [
    {
      "id": "reward1",
      "name": "Coffee Voucher",
      "description": "Get free coffee for a week",
      "pointsRequired": 100,
      "imageUrl": "https://example.com/coffee.jpg"
    }
  ],
  "redeemedRewards": [
    {
      "id": "reward2",
      "name": "Office Supplies",
      "description": "Office supplies package",
      "pointsRequired": 200,
      "imageUrl": "https://example.com/supplies.jpg"
    }
  ]
}
```

### 6. Referral Information (`/users/{uid}/referral/info`)

**Referral Document:**
```json
{
  "referralCode": "REF-2024-USER",
  "referralLink": "https://app.company.com/ref/REF-2024-USER",
  "totalReferrals": 3,
  "referrals": [
    {
      "id": "ref1",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "referredDate": "2024-01-20T10:00:00Z",
      "isActive": true
    }
  ]
}
```

## Firestore Rules

**Update these rules in Firebase Console → Firestore → Rules:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
      
      // Users can read/write their own subcollections
      match /{document=**} {
        allow read, write: if request.auth.uid == uid;
      }
    }
    
    // News is readable by all authenticated users
    match /news/{document=**} {
      allow read: if request.auth != null;
      allow write: if false; // Admin only (manage via Firebase Console or Admin SDK)
    }
    
    // Vacancies are readable by all authenticated users
    match /vacancies/{document=**} {
      allow read: if request.auth != null;
      allow write: if false; // Admin only
    }
    
    // Training materials are readable by all authenticated users
    match /training_materials/{document=**} {
      allow read: if request.auth != null;
      allow write: if false; // Admin only
    }
  }
}
```

## How to Add Data

### Option 1: Using Firebase Console (UI)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Firestore Database**
4. Click **"+ Start collection"**
5. Enter collection name (e.g., "news", "vacancies")
6. Add documents with the structure shown above

### Option 2: Using Admin SDK (Backend)

**Install Firebase Admin SDK:**
```bash
npm install firebase-admin
```

**Create/Update News:**
```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccount.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Add news
await db.collection('news').doc('news1').set({
  id: 'news1',
  title: 'Company Expansion',
  content: 'We are expanding...',
  imageUrl: 'https://example.com/image.jpg',
  publishDate: new Date(),
  author: 'HR Department',
  isCorporate: true,
  tags: []
});
```

**Create/Update Vacancy:**
```javascript
await db.collection('vacancies').doc('vac1').set({
  id: 'vac1',
  title: 'Project Manager',
  description: 'Looking for...',
  location: 'Almaty',
  latitude: 43.2220,
  longitude: 76.8512,
  projectType: 'construction',
  publishDate: new Date()
});
```

**Create/Update Training Material:**
```javascript
await db.collection('training_materials').doc('tm1').set({
  id: 'tm1',
  title: 'Safety Guidelines',
  description: 'Important...',
  category: 'master',
  fileUrl: 'https://example.com/guide.pdf',
  imageUrl: 'https://example.com/thumb.jpg',
  publishDate: new Date(),
  isMemo: true
});
```

**Create/Update User Finance:**
```javascript
const userId = 'user-uid-here';
await db.collection('users').doc(userId).collection('finance').doc('info').set({
  currentObject: 'Project Alpha',
  totalShiftsWorked: 45,
  trainingDeductions: 5000.0,
  totalBalance: 150000.0,
  history: []
});
```

### Option 3: Using Flutter App

The app can also update data through the `AuthProvider.updateProfile()` method:

```dart
final authProvider = context.read<AuthProvider>();
await authProvider.updateProfile({
  'phoneNumber': '+7 777 123 4567',
  'email': 'john@example.com',
  'rating': 4.5,
  'awards': ['Best Employee 2023'],
  'children': [
    {
      'name': 'Maria',
      'birthDate': '2015-06-20',
      'certificateNumber': 'CERT-123'
    }
  ]
});
```

## Data Import from CSV

**Sample CSV for News:**
```csv
id,title,content,imageUrl,publishDate,author,isCorporate,tags
news1,Expansion,We are expanding,https://url.jpg,2024-02-10,HR,true,"expansion,company"
news2,Event,Team building,https://url.jpg,2024-02-12,Events,true,"event,team"
```

**Import using Firebase Cloud Function or Admin SDK:**

```javascript
const csv = require('csv-parse/sync');
const fs = require('fs');

const data = fs.readFileSync('./news.csv', 'utf8');
const records = csv.parse(data, { columns: true });

for (const record of records) {
  const date = new Date(record.publishDate);
  const tags = record.tags.split(',').map(t => t.trim());
  
  await db.collection('news').doc(record.id).set({
    ...record,
    publishDate: date,
    tags: tags,
    isCorporate: record.isCorporate === 'true'
  });
}
```

## Required Fields Checklist

### News Document
- ✅ id: unique identifier
- ✅ title: news title
- ✅ content: full text
- ✅ publishDate: timestamp
- ✅ author: author name
- ✅ isCorporate: boolean
- ⚠️ imageUrl: optional
- ⚠️ videoUrl: optional
- ⚠️ tags: optional

### Vacancy Document
- ✅ id: unique identifier
- ✅ title: job title
- ✅ description: job details
- ✅ location: city/location
- ✅ projectType: construction, installation, etc.
- ✅ publishDate: timestamp
- ⚠️ latitude: optional (for map display)
- ⚠️ longitude: optional (for map display)

### Training Material Document
- ✅ id: unique identifier
- ✅ title: material title
- ✅ description: details
- ✅ category: master, installer, foreman
- ✅ publishDate: timestamp
- ✅ isMemo: boolean
- ⚠️ fileUrl: optional
- ⚠️ imageUrl: optional

## Troubleshooting

### Data not appearing in app?
1. Check Firestore rules are correct
2. Verify user is authenticated
3. Check collection and field names match exactly
4. Ensure timestamps are in ISO 8601 format

### Need to migrate data?
Use Firebase Cloud Function or export/import tools:
```bash
# Export data
gcloud firestore export gs://your-bucket/backup

# Import data
gcloud firestore import gs://your-bucket/backup
```

## Support

For Firebase issues, visit: [Firebase Documentation](https://firebase.google.com/docs/firestore)
