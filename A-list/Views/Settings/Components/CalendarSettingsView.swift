//
//  CalendarSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct CalendarSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .tint(Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme))
                .labelsHidden()
                .padding()
//            Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
//                .padding()
            Spacer()
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    CalendarSettingsView()
}
