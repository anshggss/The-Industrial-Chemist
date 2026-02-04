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
}
