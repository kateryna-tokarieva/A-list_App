//
//  Event.swift
//  A-list
//
//  Created by Екатерина Токарева on 07.07.2024.
//

import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}
