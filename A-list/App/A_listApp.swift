//
//  A_listApp.swift
//  A-list
//
//  Created by Екатерина Токарева on 22.06.2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
// ...


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct A_listApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(themeManager)
                .onAppear {
                    Resources.themeManager = themeManager
                }
        }
    }
}
