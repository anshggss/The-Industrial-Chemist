//
//  SubscriptionManager.swift
//  The Industrial Chemist
//
//  Manages in-app purchases and subscriptions using StoreKit
//

import Foundation
import StoreKit
import FirebaseAuth
import FirebaseFirestore

class SubscriptionManager: NSObject {
    static let shared = SubscriptionManager()

    // MARK: - Product Identifiers
    // TODO: Replace these with your actual App Store Connect product IDs
    enum ProductID: String {
        case monthlySubscription = "com.industrialchemist.premium.monthly"
        case yearlySubscription = "com.industrialchemist.premium.yearly"

        static var allCases: [ProductID] {
            return [.monthlySubscription, .yearlySubscription]
        }
    }

    // MARK: - Properties
    private let db = Firestore.firestore()
    private var products: [SKProduct] = []
    private var productRequest: SKProductsRequest?
    private var purchaseCompletionHandlers: [(Bool, Error?) -> Void] = []
    private var restoreCompletionHandler: ((Bool, Error?) -> Void)?

    var isPurchasing = false
    var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }

    // MARK: - Initialization
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    // MARK: - Product Loading

    /// Fetch available subscription products from App Store
    func loadProducts(completion: @escaping (Bool, [SKProduct]?) -> Void) {
        guard canMakePayments else {
            print("❌ Cannot make payments on this device")
            completion(false, nil)
            return
        }

        let productIdentifiers = Set(ProductID.allCases.map { $0.rawValue })
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest?.delegate = self
        productRequest?.start()

        // Store completion handler
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self else { return }
            if self.products.isEmpty {
                completion(false, nil)
            } else {
                completion(true, self.products)
            }
        }
    }

    /// Get product by ID
    func getProduct(for productID: ProductID) -> SKProduct? {
        return products.first { $0.productIdentifier == productID.rawValue }
    }

    /// Get formatted price for product
    func getFormattedPrice(for product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? ""
    }

    /// Get subscription period description
    func getSubscriptionPeriod(for product: SKProduct) -> String {
        guard let subscription = product.subscriptionPeriod else {
            return ""
        }

        switch subscription.unit {
        case .day:
            return subscription.numberOfUnits == 1 ? "Daily" : "\(subscription.numberOfUnits) days"
        case .week:
            return subscription.numberOfUnits == 1 ? "Weekly" : "\(subscription.numberOfUnits) weeks"
        case .month:
            return subscription.numberOfUnits == 1 ? "Monthly" : "\(subscription.numberOfUnits) months"
        case .year:
            return subscription.numberOfUnits == 1 ? "Yearly" : "\(subscription.numberOfUnits) years"
        @unknown default:
            return ""
        }
    }

    // MARK: - Purchase Flow

    /// Purchase a subscription
    func purchase(product: SKProduct, completion: @escaping (Bool, Error?) -> Void) {
        guard canMakePayments else {
            completion(false, NSError(domain: "SubscriptionManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Payments are not allowed on this device"]))
            return
        }

        guard !isPurchasing else {
            completion(false, NSError(domain: "SubscriptionManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "A purchase is already in progress"]))
            return
        }

        isPurchasing = true
        purchaseCompletionHandlers.append(completion)

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)

        print("🛒 Initiating purchase for: \(product.localizedTitle)")
    }

    /// Restore previous purchases
    func restorePurchases(completion: @escaping (Bool, Error?) -> Void) {
        guard canMakePayments else {
            completion(false, NSError(domain: "SubscriptionManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Payments are not allowed on this device"]))
            return
        }

        restoreCompletionHandler = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
        print("♻️ Restoring purchases...")
    }

    // MARK: - Subscription Status

    /// Check if user has active subscription by validating receipt
    func checkSubscriptionStatus(completion: @escaping (Bool) -> Void) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: receiptURL.path) else {
            print("ℹ️ No receipt found - user has no subscription")
            completion(false)
            return
        }

        // In production, you should validate the receipt with your backend server
        // For now, we'll do basic local validation
        validateReceiptLocally { isValid in
            completion(isValid)
        }
    }

    /// Local receipt validation (basic check)
    private func validateReceiptLocally(completion: @escaping (Bool) -> Void) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL) else {
            completion(false)
            return
        }

        // In production, send receipt to your backend for validation
        // This is a simplified check - receipt exists means subscription exists
        let hasReceipt = !receiptData.isEmpty
        completion(hasReceipt)

        // TODO: Implement server-side receipt validation for production
        // POST receipt to your backend -> backend validates with Apple -> returns subscription status
    }

    /// Update Firebase with subscription status
    func updateFirebaseSubscription(isSubscribed: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ No authenticated user")
            return
        }

        db.collection("users").document(uid).updateData([
            "hasSubscription": isSubscribed,
            "subscriptionUpdatedAt": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("❌ Error updating subscription status: \(error.localizedDescription)")
            } else {
                print("✅ Subscription status updated in Firebase: \(isSubscribed)")

                // Update local user object
                UserManager.shared.currentUser?.hasSubscription = isSubscribed
            }
        }
    }

    // MARK: - Helper Methods

    private func finishPurchase(success: Bool, error: Error? = nil) {
        isPurchasing = false

        // Call all completion handlers
        for handler in purchaseCompletionHandlers {
            handler(success, error)
        }
        purchaseCompletionHandlers.removeAll()

        // If successful, update subscription status
        if success {
            updateFirebaseSubscription(isSubscribed: true)
        }
    }

    private func finishRestore(success: Bool, error: Error? = nil) {
        restoreCompletionHandler?(success, error)
        restoreCompletionHandler = nil

        // If successful, update subscription status
        if success {
            updateFirebaseSubscription(isSubscribed: true)
        }
    }
}

// MARK: - SKProductsRequestDelegate

extension SubscriptionManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("✅ Loaded \(response.products.count) products")

        products = response.products.sorted { product1, product2 in
            // Sort by price ascending
            return product1.price.compare(product2.price) == .orderedAscending
        }

        for product in products {
            print("📦 Product: \(product.localizedTitle) - \(getFormattedPrice(for: product))")
        }

        if !response.invalidProductIdentifiers.isEmpty {
            print("⚠️ Invalid product IDs: \(response.invalidProductIdentifiers)")
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("❌ Product request failed: \(error.localizedDescription)")
    }
}

// MARK: - SKPaymentTransactionObserver

extension SubscriptionManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("🔄 Purchasing: \(transaction.payment.productIdentifier)")

            case .purchased:
                print("✅ Purchase successful: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                finishPurchase(success: true)

            case .failed:
                print("❌ Purchase failed: \(transaction.error?.localizedDescription ?? "Unknown error")")
                SKPaymentQueue.default().finishTransaction(transaction)
                finishPurchase(success: false, error: transaction.error)

            case .restored:
                print("♻️ Purchase restored: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                finishRestore(success: true)

            case .deferred:
                print("⏳ Purchase deferred (pending external action)")

            @unknown default:
                break
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("✅ Restore completed successfully")
        finishRestore(success: true)
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("❌ Restore failed: \(error.localizedDescription)")
        finishRestore(success: false, error: error)
    }
}
