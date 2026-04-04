//
//  Achievement.swift
//  The Industrial Chemist
//
//  Created by Claude Code
//

import Foundation

struct Achievement {
    let id: String
    let title: String
    let description: String
    let imageName: String
    var isUnlocked: Bool

    static let all: [Achievement] = [
        Achievement(
            id: "first_experiment",
            title: "Good Start",
            description: "Complete your first experiment",
            imageName: "ach1",
            isUnlocked: false
        ),
        Achievement(
            id: "streak_master",
            title: "Explorer",
            description: "Maintain a 7-day streak",
            imageName: "ach2",
            isUnlocked: false
        ),
        Achievement(
            id: "xp_milestone",
            title: "Rising Star",
            description: "Reach 1000 total XP",
            imageName: "ach3",
            isUnlocked: false
        ),
        Achievement(
            id: "all_experiments",
            title: "Master Chemist",
            description: "Complete all available experiments",
            imageName: "ach4",
            isUnlocked: false
        )
    ]

    static func withUnlockedIds(_ unlockedIds: [String]) -> [Achievement] {
        return all.map { achievement in
            var updatedAchievement = achievement
            updatedAchievement.isUnlocked = unlockedIds.contains(achievement.id)
            return updatedAchievement
        }
    }
}
