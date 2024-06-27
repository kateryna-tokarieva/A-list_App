//
//  SettingsSectionViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import Foundation
import SwiftUI

class SettingsSectionViewModel: ObservableObject {
    @Published var section: SettingsSection
    
    
    init(section: SettingsSection) {
        self.section = section
    }
}
