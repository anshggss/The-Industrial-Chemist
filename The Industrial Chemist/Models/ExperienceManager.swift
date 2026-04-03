//
//  ExperienceManager.swift
//  The Industrial Chemist
//
//  Created by admin25 on 04/02/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ExperienceManager {
    static let shared = ExperienceManager()
    private let db = Firestore.firestore()

    private init() {}

    // XP rewards for different actions
    enum XPReward: Int {
        case experimentCompleted = 100
        case firstExperiment = 200
        case allExperimentsCompleted = 500
    }

    // MARK: - Award Experience

    /// Awards experience points to the current user and updates their stats
    func awardExperience(amount: Int, completion: @escaping (Bool, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false, NSError(domain: "ExperienceManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        let userRef = db.collection("users").document(uid)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let userDocument: DocumentSnapshot
            do {
                try userDocument = transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard userDocument.exists else {
                let error = NSError(domain: "ExperienceManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User document not found"])
                errorPointer?.pointee = error
                return nil
            }

            let currentXP = userDocument.data()?["experience"] as? Int ?? 0
            let currentWeeklyXP = userDocument.data()?["weeklyXP"] as? Int ?? 0

            // Calculate division
            let newTotalXP = currentXP + amount
            let division = self.calculateDivision(totalXP: newTotalXP)

            // Update user document (no longer updating streak on activity, only on login)
            transaction.updateData([
                "experience": newTotalXP,
                "weeklyXP": currentWeeklyXP + amount,
                "lastActivityDate": FieldValue.serverTimestamp(),
                "division": division.rawValue
            ], forDocument: userRef)

            return newTotalXP
        }) { (result, error) in
            if let error = error {
                print("❌ Error awarding XP: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("✅ Awarded \(amount) XP. New total: \(result ?? 0)")

                // Update UserManager
                self.refreshCurrentUser()

                completion(true, nil)
            }
        }
    }

    // MARK: - Streak Calculation

    /// Updates user's login streak based on daily login (call on app launch/login)
    func updateLoginStreak(completion: @escaping (Bool, Int) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false, 0)
            return
        }

        let userRef = db.collection("users").document(uid)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let userDocument: DocumentSnapshot
            do {
                try userDocument = transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard userDocument.exists else {
                let error = NSError(domain: "ExperienceManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User document not found"])
                errorPointer?.pointee = error
                return nil
            }

            let currentStreak = userDocument.data()?["currentStreak"] as? Int ?? 0
            let lastLoginDate = userDocument.data()?["lastLoginDate"] as? Timestamp

            // Calculate new streak based on login
            let newStreak = self.calculateLoginStreak(currentStreak: currentStreak, lastLoginDate: lastLoginDate)

            // Update user document with new streak and last login date
            transaction.updateData([
                "currentStreak": newStreak,
                "lastLoginDate": FieldValue.serverTimestamp()
            ], forDocument: userRef)

            return newStreak
        }) { (result, error) in
            if let error = error {
                print("❌ Error updating login streak: \(error.localizedDescription)")
                completion(false, 0)
            } else {
                let newStreak = result as? Int ?? 0
                print("✅ Login streak updated: \(newStreak)")

                // Update UserManager
                self.refreshCurrentUser()

                completion(true, newStreak)
            }
        }
    }

    private func calculateLoginStreak(currentStreak: Int, lastLoginDate: Timestamp?) -> Int {
        guard let lastLogin = lastLoginDate?.dateValue() else {
            // First login ever (no lastLoginDate set)
            return 1
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastLoginDay = calendar.startOfDay(for: lastLogin)

        let daysDifference = calendar.dateComponents([.day], from: lastLoginDay, to: today).day ?? 0

        switch daysDifference {
        case 0:
            // Same day - don't increment streak
            // BUT if streak is 0, this is their first login today (new user), so set to 1
            return currentStreak == 0 ? 1 : currentStreak
        case 1:
            // Consecutive day - increment streak
            return currentStreak + 1
        default:
            // Streak broken - restart
            return 1
        }
    }

    // MARK: - Division Calculation

    func calculateDivision(totalXP: Int) -> Division {
        switch totalXP {
        case 10000...:
            return .master
        case 5000..<10000:
            return .diamond
        case 3000..<5000:
            return .platinum
        case 1500..<3000:
            return .gold
        case 500..<1500:
            return .silver
        default:
            return .bronze
        }
    }

    // MARK: - Reset Weekly XP

    /// Resets weekly XP for all users (should be called via a scheduled function)
    func resetWeeklyXP(completion: @escaping (Bool) -> Void) {
        // This would typically be called by a Cloud Function on a schedule
        // For now, we'll keep it as a manual operation if needed

        let batch = db.batch()

        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching users for weekly reset: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let documents = snapshot?.documents else {
                completion(false)
                return
            }

            for document in documents {
                batch.updateData(["weeklyXP": 0], forDocument: document.reference)
            }

            batch.commit { error in
                if let error = error {
                    print("❌ Error resetting weekly XP: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("✅ Weekly XP reset successfully")
                    completion(true)
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func refreshCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error refreshing user: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else { return }

            let user = AppUser(
                uid: uid,
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                phone: data["phone"] as? String ?? "",
                experience: data["experience"] as? Int ?? 0,
                weeklyXP: data["weeklyXP"] as? Int,
                currentStreak: data["currentStreak"] as? Int,
                division: data["division"] as? String
            )

            UserManager.shared.currentUser = user
        }
    }

    // MARK: - Get User Stats

    func getUserStats(completion: @escaping (UserStats?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error fetching user stats: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = snapshot?.data() else {
                completion(nil)
                return
            }

            let totalXP = data["experience"] as? Int ?? 0
            let weeklyXP = data["weeklyXP"] as? Int ?? 0
            let streak = data["currentStreak"] as? Int ?? 0
            let divisionString = data["division"] as? String ?? "Bronze"
            let division = Division(rawValue: divisionString) ?? .bronze

            // Get user's rank
            self.getUserRank(uid: uid) { rank in
                let stats = UserStats(
                    streak: streak,
                    totalXP: totalXP,
                    weeklyXP: weeklyXP,
                    rank: rank,
                    division: division
                )
                completion(stats)
            }
        }
    }

    private func getUserRank(uid: String, completion: @escaping (Int) -> Void) {
        // Query users with higher XP
        db.collection("users")
            .order(by: "experience", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching rank: \(error.localizedDescription)")
                    completion(0)
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(0)
                    return
                }

                // Find position in the list
                if let index = documents.firstIndex(where: { $0.documentID == uid }) {
                    completion(index + 1) // Rank is 1-based
                } else {
                    completion(documents.count + 1)
                }
            }
    }
}
