//
//  SupportSettingsViewViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 07.07.2024.
//

import Foundation
import MessageUI

class SupportSettingsViewViewModel: ObservableObject {
    @Published var message = ""
    @Published var showingMailView = false
    @Published var result: Result<MFMailComposeResult, Error>? = nil
    
    func sendMessage() {
        guard !message.isEmpty else { return }
        showingMailView = true
    }
}

