//
//  CalendarSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct CalendarSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var viewModel = CalendarViewModel()
    @State private var selectedDate = Date()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        VStack {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .tint(Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme))
                .labelsHidden()
                .padding()
            
            List {
                let eventsToShow: [Event] = {
                    if Calendar.current.isDate(selectedDate, inSameDayAs: Date()) {
                        return viewModel.events
                    } else {
                        return viewModel.events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
                    }
                }()
                
                ForEach(eventsToShow) { event in
                    VStack(alignment: .leading) {
                        Text("\(event.date, formatter: dateFormatter)")
                            .padding()
                            .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                        Text(event.title)
                            .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
                            .padding(.bottom)
                            .padding(.leading)
                            .padding(.trailing)
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
        }
    }
}
