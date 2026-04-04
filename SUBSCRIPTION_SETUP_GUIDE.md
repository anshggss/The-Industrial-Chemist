# Subscription Setup Guide for The Industrial Chemist

This guide will walk you through setting up in-app subscriptions for The Industrial Chemist app.

## ✅ What's Already Implemented

The following components are already complete in the codebase:

1. **SubscriptionManager.swift** - StoreKit integration and purchase handling
2. **SubscriptionViewController.swift** - Beautiful subscription UI with pricing
3. **Firebase Integration** - `hasSubscription` field in user documents
4. **Experiment Locking Logic** - Experiments lock/unlock based on subscription status
5. **Receipt Validation** - Basic local validation (needs server-side in production)
6. **Restore Purchases** - Full restore functionality

## 🔧 What You Need to Do

### Step 1: Update Product IDs

Open `SubscriptionManager.swift` and update the product identifiers to match what you'll create in App Store Connect:

```swift
enum ProductID: String {
    case monthlySubscription = "com.industrialchemist.premium.monthly"  // Update this
    case yearlySubscription = "com.industrialchemist.premium.yearly"    // Update this
}
```

Replace `com.industrialchemist` with your actual app's bundle identifier.

---

### Step 2: App Store Connect Configuration

#### 2.1 Sign In to App Store Connect
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Sign in with your Apple Developer account
3. Select "My Apps"
4. Select "The Industrial Chemist" (or create a new app if you haven't yet)

#### 2.2 Create Subscription Group
1. Click on "Features" in the sidebar
2. Select "In-App Purchases"
3. Click the "+" button
4. Select "Auto-Renewable Subscription"
5. Create a Subscription Group:
   - Name: "Premium Subscription"
   - Reference Name: "premium_group"

#### 2.3 Add Monthly Subscription
1. Click "Create Subscription" within the group
2. Fill in the details:
   - **Reference Name**: `Monthly Premium`
   - **Product ID**: `com.industrialchemist.premium.monthly` (must match code!)
   - **Subscription Duration**: 1 Month

3. Add pricing:
   - Click "Add Pricing"
   - Select all territories
   - Set price tier (e.g., Tier 3 = $2.99/month)

4. Add localized information:
   - **Display Name**: `Monthly Premium`
   - **Description**: `Unlock all experiments instantly with monthly premium access`

5. Review Information:
   - Add app-specific information about what's included
   - Upload subscription screenshot if required

#### 2.4 Add Yearly Subscription
Repeat the same process for yearly:
1. **Reference Name**: `Yearly Premium`
2. **Product ID**: `com.industrialchemist.premium.yearly`
3. **Subscription Duration**: 1 Year
4. **Pricing**: e.g., Tier 15 = $24.99/year (save 30%)
5. **Display Name**: `Yearly Premium`
6. **Description**: `Unlock all experiments with yearly premium access - Best Value!`

#### 2.5 Save and Submit for Review
1. Click "Save" on all subscriptions
2. Once ready, submit your subscriptions for review
3. Subscriptions must be approved before they work in production

---

### Step 3: Configure Sandbox Testing

#### 3.1 Create Sandbox Test Users
1. In App Store Connect, go to "Users and Access"
2. Click "Sandbox Testers"
3. Click the "+" button to add a new tester
4. Fill in:
   - Email: Use a test email (can be fake, e.g., test@example.com)
   - Password: Create a strong password
   - First/Last Name
   - Country/Region: Select your region

5. **Important**: Don't verify the email - sandbox accounts shouldn't be verified

#### 3.2 Configure Device for Testing
1. On your iOS test device, go to Settings > App Store
2. Scroll to bottom and tap "Sandbox Account"
3. Sign in with your sandbox tester account
4. **Never use a sandbox account in the production App Store!**

---

### Step 4: Enable In-App Purchase Capability in Xcode

1. Open your Xcode project
2. Select your app target
3. Go to "Signing & Capabilities"
4. Click "+ Capability"
5. Add "In-App Purchase"

---

### Step 5: Testing the Subscription Flow

#### 5.1 Build and Run
1. Build the app on a real device or simulator (iOS 15.0+)
2. Sign in with a test account
3. Navigate to a locked experiment
4. Tap on it to see the subscription prompt
5. Click "Subscribe" to see the subscription options

#### 5.2 Test Purchase Flow
1. Select a subscription plan
2. Click "Subscribe Now"
3. When prompted, sign in with your **sandbox tester account**
4. Confirm the subscription (sandbox purchases are free)
5. Verify the purchase succeeds and `hasSubscription` updates to `true` in Firebase
6. Verify all experiments unlock

#### 5.3 Test Restore Purchases
1. Go to Settings
2. Tap "RESTORE SUBSCRIPTION"
3. Verify it detects the existing subscription
4. Verify `hasSubscription` is set to `true`

---

### Step 6: Production Deployment Checklist

Before releasing to the App Store:

#### 6.1 Server-Side Receipt Validation (IMPORTANT!)
The current implementation uses basic local receipt validation. For production, you **must** implement server-side validation:

1. **Create a backend endpoint** (Firebase Cloud Functions recommended):
   ```javascript
   exports.validateReceipt = functions.https.onCall(async (data, context) => {
     const receiptData = data.receipt;
     const isProduction = data.production;

     const verifyURL = isProduction
       ? 'https://buy.itunes.apple.com/verifyReceipt'
       : 'https://sandbox.itunes.apple.com/verifyReceipt';

     // Send receipt to Apple for validation
     const response = await fetch(verifyURL, {
       method: 'POST',
       body: JSON.stringify({
         'receipt-data': receiptData,
         'password': 'YOUR_SHARED_SECRET' // From App Store Connect
       })
     });

     const result = await response.json();
     return { valid: result.status === 0 };
   });
   ```

2. **Update SubscriptionManager.swift**:
   ```swift
   private func validateReceiptWithServer(receiptData: Data, completion: @escaping (Bool) -> Void) {
       // Call your backend validation endpoint
       // Update Firebase hasSubscription based on result
   }
   ```

#### 6.2 Get Shared Secret from App Store Connect
1. Go to App Store Connect
2. Select your app
3. Go to "In-App Purchases"
4. Under "App-Specific Shared Secret", click "Generate"
5. Copy this secret for your backend validation

#### 6.3 Update Product Descriptions
Ensure all subscription descriptions are clear and comply with App Store guidelines.

#### 6.4 Add Privacy Policy
1. Create a privacy policy that mentions in-app purchases
2. Add the URL in App Store Connect under "App Privacy"

#### 6.5 Test on Production Environment
1. Use TestFlight to distribute to beta testers
2. Have real users test the subscription flow
3. Verify purchases work correctly
4. Check that receipt validation works

---

### Step 7: App Store Submission

When submitting your app for review:

1. **Include Test Account**: Provide a test account in App Review Information
2. **Subscription Benefits**: Clearly explain what users get with subscription
3. **Screenshots**: Include screenshots showing premium features
4. **Compliance**: Ensure you follow Apple's subscription guidelines

---

## 🎯 Product IDs Reference

Make sure these match exactly between code and App Store Connect:

| Subscription | Product ID | Duration | Recommended Price |
|-------------|-----------|----------|-------------------|
| Monthly | `com.industrialchemist.premium.monthly` | 1 Month | $2.99 - $4.99 |
| Yearly | `com.industrialchemist.premium.yearly` | 1 Year | $24.99 - $39.99 |

---

## 🔒 What Premium Unlocks

Premium subscribers get:
- ✅ Instant access to all experiments
- ✅ No need to complete previous experiments
- ✅ Priority customer support
- ✅ Future experiments as they're released

---

## 📱 UI Flow

### Locked Experiment Tap:
```
User taps locked experiment
    ↓
Alert: "Experiment Locked 🔒"
    ↓
User taps "Subscribe"
    ↓
SubscriptionViewController appears
    ↓
Beautiful full-screen subscription UI with:
  - Crown icon
  - Feature list
  - Monthly & Yearly options
  - Live pricing from App Store
  - Subscribe Now button
  - Restore Purchases button
```

### After Successful Purchase:
```
Purchase completes
    ↓
Firebase hasSubscription = true
    ↓
All experiments auto-unlock
    ↓
User can access any experiment
```

---

## 🐛 Troubleshooting

### Products Not Loading
- Verify product IDs match exactly
- Check that products are "Ready to Submit" or "Approved" in App Store Connect
- Make sure you're signed into a sandbox account
- Try clearing derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### Purchases Failing
- Verify you're using a sandbox tester account
- Check that sandbox account email is NOT verified
- Ensure In-App Purchase capability is enabled
- Check Console.app for detailed error messages

### Receipt Validation Failing
- For testing, the local validation should work
- For production, implement server-side validation
- Verify receipt file exists at `Bundle.main.appStoreReceiptURL`

### Firebase Not Updating
- Check Firebase rules allow writes to user documents
- Verify user is authenticated
- Check Firebase Console for actual `hasSubscription` value

---

## 📚 Resources

- [StoreKit Documentation](https://developer.apple.com/documentation/storekit)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Subscription Best Practices](https://developer.apple.com/app-store/subscriptions/)
- [Testing In-App Purchases](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases)

---

## ✨ Summary

You now have a fully functional subscription system! The code is production-ready except for server-side receipt validation. Follow this guide to:

1. Configure products in App Store Connect
2. Test with sandbox accounts
3. Implement server-side validation
4. Deploy to production

Good luck with your app! 🚀
