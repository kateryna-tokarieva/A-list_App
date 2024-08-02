//
//  AddListViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

class NewListViewModel: ObservableObject {
    @Published var listTitle = Resources.Strings.listNamePlaceholder
    @Published var stepTitle = Resources.Strings.step1Title
    @Published var progress: Float = 0.5
    @Published var textFieldOpacity = 1
    @Published var skipButtonOpacity = 0
    @Published var datePickerOpacity = 0
    @Published var dueDate =  Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @Published var listId = ""

    func update(step: NewListStep) {
        switch step {
        case .name:
            self.stepTitle = Resources.Strings.step1Title
            self.listTitle = Resources.Strings.listNamePlaceholder
            self.progress = 0.5
            self.textFieldOpacity = 1
            self.skipButtonOpacity = 0
            self.datePickerOpacity = 0
        case .timer:
            self.stepTitle = Resources.Strings.step2Title
            self.progress = 1
            self.textFieldOpacity = 0
            self.skipButtonOpacity = 1
            self.datePickerOpacity = 1
        }
    }

    func save() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let notificationId = setNotification(title: listTitle, date: dueDate)
        let newList = ShoppingList(name: listTitle, dueDate: dueDate, notificationId: notificationId)
        self.listId = newList.id
        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(userId)
            .collection("lists")
            .document(newList.id)
            .setData(newList.asDictionary()) { error in
                if let error = error {
                    print("Error saving list: \(error)")
                } else {
                    self.addEventToDatabase(userId: userId, list: newList)
                }
            }
    }

    private func addEventToDatabase(userId: String, list: ShoppingList) {
        let event = [
            "title": list.name,
            "dueDate": list.dueDate?.timeIntervalSince1970 ?? 0.0,
            "isDone": list.isDone,
            "sharedWithFriends": list.sharedWithFriends ?? []
        ] as [String : Any]

        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(userId)
            .collection("events")
            .document(list.id)
            .setData(event) { error in
                if let error = error {
                    print("Error saving event: \(error)")
                } 
            }
    }

    private func setNotification(title: String, date: Date) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Час відправлятися на шопінг!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let notificationId = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
        return notificationId
    }
}
