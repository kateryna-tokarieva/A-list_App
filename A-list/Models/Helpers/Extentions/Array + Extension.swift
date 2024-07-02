//
//  Array + Extension.swift
//  A-list
//
//  Created by Екатерина Токарева on 01.07.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
