//
//  SharedList.swift
//  A-list
//
//  Created by Екатерина Токарева on 08.07.2024.
//

import Foundation

struct SharedList: Codable, Hashable {
    var id: String
    var ownerId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId
    }
    
    init(id: String, ownerId: String) {
        self.id = id
        self.ownerId = ownerId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        ownerId = try container.decodeIfPresent(String.self, forKey: .ownerId) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(ownerId, forKey: .ownerId)
    }
}
