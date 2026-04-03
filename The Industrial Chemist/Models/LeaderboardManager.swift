//
//  LeaderboardManager.swift
//  The Industrial Chemist
//
//  Created by admin25 on 04/02/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class LeaderboardManager {
    static let shared = LeaderboardManager()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Fetch Leaderboard Data

    /// Fetches the global leaderboard based on total XP
    func fetchGlobalLeaderboard(limit: Int = 10, completion: @escaping ([LeaderboardEntry]?, Error?) -> Void) {
        db.collection("users")
            .order(by: "experience", descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching global leaderboard: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion([], nil)
                    return
                }

                let entries = documents.enumerated().map { index, doc -> LeaderboardEntry in
                    let data = doc.data()
                    let name = data["name"] as? String ?? "Unknown"
                    let xp = data["experience"] as? Int ?? 0

                    return LeaderboardEntry(
                        rank: index + 1,
                        name: name,
                        xp: xp,
                        profileImage: nil
                    )
                }

                completion(entries, nil)
            }
    }

    /// Fetches the weekly leaderboard based on weekly XP
    func fetchWeeklyLeaderboard(limit: Int = 10, completion: @escaping ([LeaderboardEntry]?, Error?) -> Void) {
        db.collection("users")
            .order(by: "weeklyXP", descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching weekly leaderboard: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion([], nil)
                    return
                }

                let entries = documents.enumerated().map { index, doc -> LeaderboardEntry in
                    let data = doc.data()
                    let name = data["name"] as? String ?? "Unknown"
                    let weeklyXP = data["weeklyXP"] as? Int ?? 0

                    return LeaderboardEntry(
                        rank: index + 1,
                        name: name,
                        xp: weeklyXP,
                        profileImage: nil
                    )
                }

                completion(entries, nil)
            }
    }

    /// Fetches leaderboard data including the current user's position
    func fetchLeaderboardWithCurrentUser(completion: @escaping ([LeaderboardEntry]?, Int?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil, nil, NSError(domain: "LeaderboardManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        // Fetch all users sorted by weekly XP
        db.collection("users")
            .order(by: "weeklyXP", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching leaderboard: \(error.localizedDescription)")
                    completion(nil, nil, error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion([], nil, nil)
                    return
                }

                // Find current user's rank
                var currentUserRank: Int?
                var currentUserEntry: LeaderboardEntry?

                let allEntries = documents.enumerated().compactMap { index, doc -> LeaderboardEntry? in
                    let data = doc.data()
                    let name = data["name"] as? String ?? "Unknown"
                    let weeklyXP = data["weeklyXP"] as? Int ?? 0
                    let rank = index + 1

                    let entry = LeaderboardEntry(
                        rank: rank,
                        name: name,
                        xp: weeklyXP,
                        profileImage: nil
                    )

                    // Check if this is the current user
                    if doc.documentID == uid {
                        currentUserRank = rank
                        currentUserEntry = LeaderboardEntry(
                            rank: rank,
                            name: "You",
                            xp: weeklyXP,
                            profileImage: nil
                        )
                    }

                    return entry
                }

                // Get top 10
                var topEntries = Array(allEntries.prefix(10))

                // If current user is not in top 10, include them
                if let currentRank = currentUserRank, currentRank > 10, let userEntry = currentUserEntry {
                    // Replace the 10th entry with current user or add them
                    if topEntries.count == 10 {
                        topEntries[9] = userEntry
                    } else {
                        topEntries.append(userEntry)
                    }
                }

                // Replace user's actual name with "You" if they're in the list
                if let currentRank = currentUserRank, currentRank <= 10 {
                    topEntries[currentRank - 1] = LeaderboardEntry(
                        rank: currentRank,
                        name: "You",
                        xp: topEntries[currentRank - 1].xp,
                        profileImage: nil
                    )
                }

                completion(topEntries, currentUserRank, nil)
            }
    }

    /// Calculates days remaining in the current week
    func getDaysRemainingInWeek() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        // Sunday is 1, Saturday is 7
        // Days until Sunday (end of week)
        let daysRemaining = 8 - weekday

        return daysRemaining
    }

    /// Gets a formatted string for time remaining (e.g., "3 days left")
    func getTimeRemainingString() -> String {
        let days = getDaysRemainingInWeek()

        if days == 1 {
            return "⏱ 1 day left"
        } else {
            return "⏱ \(days) days left"
        }
    }
}
