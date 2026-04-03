# Firebase Configuration Guide

## Required Firestore Indexes

After building and running the app, you'll need to create the following composite indexes in Firebase Console to optimize leaderboard queries.

### Method 1: Create Indexes Manually

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Firestore Database** → **Indexes** tab
4. Click **Create Index**

#### Index 1: Weekly Leaderboard Query
- **Collection ID**: `users`
- **Fields to index**:
  - Field: `weeklyXP` → Order: `Descending`
  - Field: `__name__` → Order: `Ascending`
- **Query scope**: Collection
- Click **Create**

#### Index 2: Global Leaderboard Query
- **Collection ID**: `users`
- **Fields to index**:
  - Field: `experience` → Order: `Descending`
  - Field: `__name__` → Order: `Ascending`
- **Query scope**: Collection
- Click **Create**

### Method 2: Let Firebase Create Indexes Automatically

1. Run your app and navigate to the Leaderboard tab
2. Check Xcode console for errors like:
   ```
   [FirebaseFirestore] The query requires an index...
   ```
3. Click the provided link in the error message
4. Firebase will create the index automatically

**Note**: Index creation can take a few minutes. Wait until status shows "Enabled" before testing leaderboard functionality.

---

## Firestore Security Rules

Update your Firestore security rules to allow users to read leaderboard data and write their own progress:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users collection - users can read all, write own
    match /users/{userId} {
      allow read: if true; // Allow reading all users for leaderboard
      allow write: if request.auth != null && request.auth.uid == userId;

      // User progress subcollection
      match /progress/{experimentId} {
        allow read: if request.auth != null && request.auth.uid == userId;
        allow write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Experiments collection - read-only for all authenticated users
    match /experiments/{experimentId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins via Firebase Console
    }
  }
}
```

**To update rules**:
1. Go to Firebase Console → Firestore Database → Rules tab
2. Replace existing rules with the above
3. Click **Publish**

---

## Database Structure Reference

### Collection: `users/{uid}`
```javascript
{
  uid: "abc123",
  name: "John Doe",
  email: "john@example.com",
  phone: "+1234567890",

  // Experience & Gamification
  experience: 500,          // Total XP (lifetime)
  weeklyXP: 200,           // XP earned this week
  currentStreak: 5,        // Consecutive days
  lastActivityDate: Timestamp,
  division: "Silver",      // Current division

  createdAt: Timestamp
}
```

### Subcollection: `users/{uid}/progress/{experimentId}`
```javascript
{
  status: "Completed",     // "Locked" | "In Progress" | "Completed"
  progress: 1.0,           // 0.0 to 1.0
  updatedAt: Timestamp
}
```

### Collection: `experiments/{experimentId}`
```javascript
{
  title: "Ammonia Process",
  testExperiment: "Description...",
  setup: ["Step 1", "Step 2"],
  build: ["Component 1", "Component 2"],
  theory: "Theory content...",
  test: "Test instructions...",
  results: "Results and takeaways...",
  model: "ammonia.usdz",
  time: "15 min",
  order: 1
}
```

---

## Testing Database Setup

### 1. Verify User Creation
After signing up, check Firestore Console:
```
users/{uid}
  ├─ experience: 0
  ├─ weeklyXP: 0
  ├─ currentStreak: 0
  ├─ division: "Bronze"
  └─ lastActivityDate: (timestamp)
```

### 2. Verify XP Award
After completing an experiment:
```
users/{uid}
  ├─ experience: 100
  ├─ weeklyXP: 100
  ├─ currentStreak: 1
  └─ division: "Bronze"

users/{uid}/progress/ammonia_process
  ├─ status: "Completed"
  └─ progress: 1.0
```

### 3. Verify Leaderboard Query
Run this query in Firestore Console to test:
```
Collection: users
Order by: weeklyXP descending
Limit: 10
```

Should return top 10 users sorted by weekly XP.

---

## Optional: Weekly Reset Cloud Function

To automatically reset `weeklyXP` every Sunday, deploy this Cloud Function:

### Setup Firebase Functions
```bash
npm install -g firebase-tools
firebase login
firebase init functions
```

### Create Function: `functions/index.js`
```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Runs every Sunday at midnight UTC
exports.resetWeeklyXP = functions.pubsub
  .schedule('0 0 * * 0')
  .timeZone('America/New_York') // Adjust to your timezone
  .onRun(async (context) => {
    console.log('Starting weekly XP reset...');

    const db = admin.firestore();
    const usersSnapshot = await db.collection('users').get();

    const batch = db.batch();
    let updateCount = 0;

    usersSnapshot.forEach(doc => {
      batch.update(doc.ref, { weeklyXP: 0 });
      updateCount++;
    });

    await batch.commit();
    console.log(`Weekly XP reset complete. Updated ${updateCount} users.`);

    return null;
  });
```

### Deploy Function
```bash
firebase deploy --only functions
```

### Test Function (Manual Trigger)
```bash
firebase functions:shell
resetWeeklyXP()
```

---

## Monitoring & Analytics

### Key Metrics to Track
1. **Total users** enrolled
2. **Average XP** per user
3. **Experiments completed** per user
4. **Weekly active users** (based on weeklyXP > 0)
5. **Streak distribution** (how many users have 7+ day streaks)

### Firebase Analytics Events (Optional)
Add these to track user engagement:

```swift
// In ResultsViewController after XP award
Analytics.logEvent("experiment_completed", parameters: [
  "experiment_name": experiment.title,
  "xp_earned": 100
])

// When user levels up division
Analytics.logEvent("division_advanced", parameters: [
  "from_division": oldDivision,
  "to_division": newDivision,
  "total_xp": totalXP
])
```

---

## Troubleshooting

### Issue: "Missing or insufficient permissions"
**Solution**: Check Firestore security rules allow reading `users` collection

### Issue: "The query requires an index"
**Solution**: Create composite indexes as described above

### Issue: XP not updating after experiment
**Solution**:
1. Check user is authenticated (`Auth.auth().currentUser` exists)
2. Verify Firestore rules allow write to `users/{uid}`
3. Check Xcode console for error messages

### Issue: Leaderboard shows empty
**Solution**:
1. Ensure at least one user has `weeklyXP > 0`
2. Check indexes are created and enabled
3. Verify network connection to Firebase

### Issue: Duplicate XP awards
**Solution**:
1. Check experiment is marked as "Completed" in Firestore
2. Verify `hasAwardedXP` flag logic in ResultsViewController

---

## Performance Considerations

### Pagination (Future Enhancement)
For apps with 1000+ users, implement pagination:

```swift
func fetchLeaderboardPage(limit: Int, lastDocument: DocumentSnapshot?) {
    var query = db.collection("users")
        .order(by: "weeklyXP", descending: true)
        .limit(to: limit)

    if let last = lastDocument {
        query = query.start(afterDocument: last)
    }

    query.getDocuments { snapshot, error in
        // Handle results
    }
}
```

### Caching
Consider caching leaderboard data for 5-10 minutes to reduce read costs:

```swift
private var leaderboardCache: [LeaderboardEntry]?
private var cacheTimestamp: Date?

func fetchLeaderboardWithCache() {
    if let cache = leaderboardCache,
       let timestamp = cacheTimestamp,
       Date().timeIntervalSince(timestamp) < 300 { // 5 minutes
        return cache
    }

    // Fetch fresh data
}
```

---

## Cost Estimation

### Firestore Reads
- **Leaderboard load**: ~10 reads (top 10 users)
- **User stats**: ~1 read
- **Per active user per day**: ~11 reads
- **1000 active users/day**: ~11,000 reads

**Firebase free tier**: 50,000 reads/day (sufficient for early stage)

### Firestore Writes
- **Experiment completion**: ~2 writes (user doc + progress doc)
- **5 experiments × 100 users/day**: ~1,000 writes

**Firebase free tier**: 20,000 writes/day (sufficient)

---

## Security Best Practices

1. **Never expose sensitive data** in user documents
2. **Use server timestamp** (`FieldValue.serverTimestamp()`) for audit trails
3. **Validate data** in security rules (e.g., XP can't be negative)
4. **Rate limit** XP awards to prevent abuse
5. **Monitor** for unusual activity (sudden XP spikes)

### Enhanced Security Rules (with validation)
```javascript
match /users/{userId} {
  allow read: if true;
  allow write: if request.auth != null
    && request.auth.uid == userId
    && request.resource.data.experience >= 0
    && request.resource.data.weeklyXP >= 0
    && request.resource.data.currentStreak >= 0;
}
```

---

## Support Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firestore Query Guide](https://firebase.google.com/docs/firestore/query-data/queries)
- [Cloud Functions for Firebase](https://firebase.google.com/docs/functions)
- [Firebase iOS SDK](https://firebase.google.com/docs/ios/setup)
