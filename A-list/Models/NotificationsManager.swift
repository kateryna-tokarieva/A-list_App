//
//  NotificationsManager.swift
//  A-list
//
//  Created by Екатерина Токарева on 07.07.2024.
//

import SwiftUI
import UserNotifications

class NotificationsManager: ObservableObject {
    @Published var notificationsIsOn: Bool = false {
        didSet {
            print("notificationsIsOn didSet called with value: \(notificationsIsOn)")
        }
    }
    
    func loadInitialState() {
        let saved = UserDefaults.standard.bool(forKey: "notificationsIsOn")
        self.notificationsIsOn = saved
        print("Loaded initial state: \(saved)")
    }
    
    func saveNotificationsSettings(_ notificationsIsOn: Bool) {
        UserDefaults.standard.set(notificationsIsOn, forKey: "notificationsIsOn")
        print("Saved notifications settings: \(notificationsIsOn)")
    }
    
    func requestAuthorization() {
        DispatchQueue.global(qos: .background).async {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Error requesting authorization: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("Authorization granted: \(granted)")
                    self.setNotificationsIsOn(granted)
                    if granted {
//                        self.scheduleTestNotification()
                    }
                }
            }
        }
    }
    
    func disableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        DispatchQueue.main.async {
            print("Notifications disabled")
            self.setNotificationsIsOn(false)
        }
    }
    
    func enableNotifications() {
        print("Requesting authorization for notifications")
        requestAuthorization()
    }
    
    private func setNotificationsIsOn(_ isOn: Bool) {
        self.notificationsIsOn = isOn
        self.saveNotificationsSettings(isOn)
        print("setNotificationsIsOn called with value: \(isOn)")
    }
    
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "Notifications are enabled!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Test notification scheduled successfully.")
            }
        }
    }
}
