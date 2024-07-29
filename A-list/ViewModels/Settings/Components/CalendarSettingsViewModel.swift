//
//  CalendarSettingsViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 28.07.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class CalendarViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    init() {
        Task {
            await fetchEvents()
        }
    }

    @MainActor
    func fetchEvents() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        do {
            let snapshot = try await dataBase.collection("users").document(userId).collection("events").getDocuments()
            let documents = snapshot.documents

            guard !documents.isEmpty else {
                print("No documents found in user's events collection")
                return
            }

            let events = documents.compactMap { document in
                Event(document: document)
            }
            self.events = events
            print("Fetched events: \(events)")

        } catch {
            print("Error fetching documents: \(error)")
        }
    }

}
