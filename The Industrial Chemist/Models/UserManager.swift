//
//  UserManager.swift
//  The Industrial Chemist
//
//  Created by admin25 on 04/02/26.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    private init() {}

    var currentUser: AppUser?
}

struct AppUser {
    let uid: String
    let name: String
    let email: String
    let phone: String
    let experience: Int
    var weeklyXP: Int?
    var currentStreak: Int?
    var division: String?

    init(uid: String, name: String, email: String, phone: String, experience: Int, weeklyXP: Int? = nil, currentStreak: Int? = nil, division: String? = nil) {
        self.uid = uid
        self.name = name
        self.email = email
        self.phone = phone
        self.experience = experience
        self.weeklyXP = weeklyXP
        self.currentStreak = currentStreak
        self.division = division
    }
}
