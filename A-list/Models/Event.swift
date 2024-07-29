//
//  Event.swift
//  A-list
//
//  Created by Екатерина Токарева on 07.07.2024.
//

import Foundation
import FirebaseFirestore

struct Event: Identifiable, Codable {
    let id: String
    let title: String
    let date: Date

    init(id: String, title: String, date: Date) {
        self.id = id
        self.title = title
        self.date = date
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let title = data["title"] as? String,
              let timestamp = data["dueDate"] as? TimeInterval else {
            return nil
        }
        self.id = document.documentID
        self.title = title
        self.date = Date(timeIntervalSince1970: timestamp)
    }
}
