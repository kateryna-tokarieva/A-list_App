//
//  NotificationsManager.swift
//  A-list
//
//  Created by Екатерина Токарева on 07.07.2024.
//

import SwiftUI
import UserNotifications

class NotificationsManager: ObservableObject {
    @Published var notificationsIsOn: Bool {
        didSet {
            saveNotificationsSettings(notificationsIsOn)
            if notificationsIsOn {
                requestAuthorization()
            } else {
                disableNotifications()
            }
        }
    }
    
    init() {
        let saved = UserDefaults.standard.bool(forKey: "notificationsIsOn")
        self.notificationsIsOn = saved
    }
    
    func saveNotificationsSettings(_ notificationsIsOn: Bool) {
        UserDefaults.standard.set(notificationsIsOn, forKey: "notificationsIsOn")
    }
    
    func requestAuthorization() {
        DispatchQueue.global(qos: .background).async {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Error requesting authorization: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.notificationsIsOn = granted
                    if granted {
                        //self.scheduleTestNotification()
                    }
                }
            }
        }
    }
    
    func disableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
            }
        }
    }
}
