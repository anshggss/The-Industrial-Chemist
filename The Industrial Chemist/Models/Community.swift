//
//  Community.swift
//  The Industrial Chemist
//

import Foundation
import FirebaseFirestore

struct Community {
    let id: String
    let name: String
    let description: String
    let createdBy: String
    let createdByName: String
    var memberCount: Int
    let createdAt: Date
    var isJoined: Bool = false

    init?(id: String, data: [String: Any]) {
        guard let name = data["name"] as? String,
              let createdBy = data["createdBy"] as? String else { return nil }
        self.id = id
        self.name = name
        self.description = data["description"] as? String ?? ""
        self.createdBy = createdBy
        self.createdByName = data["createdByName"] as? String ?? "Unknown"
        self.memberCount = data["memberCount"] as? Int ?? 0
        if let ts = data["createdAt"] as? Timestamp {
            self.createdAt = ts.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}

struct Post {
    let id: String
    let title: String
    let body: String
    let authorUID: String
    let authorName: String
    let createdAt: Date
    var likeCount: Int

    init?(id: String, data: [String: Any]) {
        guard let title = data["title"] as? String,
              let body = data["body"] as? String,
              let authorUID = data["authorUID"] as? String else { return nil }
        self.id = id
        self.title = title
        self.body = body
        self.authorUID = authorUID
        self.authorName = data["authorName"] as? String ?? "Unknown"
        self.likeCount = data["likeCount"] as? Int ?? 0
        if let ts = data["createdAt"] as? Timestamp {
            self.createdAt = ts.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}
