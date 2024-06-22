//
//  A_listApp.swift
//  A-list
//
//  Created by Екатерина Токарева on 22.06.2024.
//

import SwiftUI

@main
struct A_listApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
