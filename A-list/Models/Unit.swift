//
//  Unit.swift
//  A-list
//
//  Created by Екатерина Токарева on 30.06.2024.
//

import Foundation

enum Unit: String, Codable, CaseIterable {
    case ml = "мл."
    case l = "л."
    case g = "гр."
    case kg = "кг."
    case pc = "шт."
}
