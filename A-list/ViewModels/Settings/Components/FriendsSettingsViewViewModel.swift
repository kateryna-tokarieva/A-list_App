//
//  FriendsSettingsViewViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 07.07.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class FriendsSettingsViewViewModel: ObservableObject {
    @Published var friendsIds: [String] = []
    @Published var friends: [User] = []
    @Published var errorMessage: String?
    
    private let dataBase = Firestore.firestore()
    
    init() {
        Task {
            await fetchFriends()
        }
    }
    
    @MainActor
    private func fetchFriends() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await dataBase.collection("users").document(userId).collection("friends").getDocuments()
            let documents = snapshot.documents
            
            guard !documents.isEmpty else {
                print("No documents found in user's friends collection")
                return
            }
            
            let friendsIds = documents.compactMap { document in
                document["id"] as? String
            }
            self.friendsIds = friendsIds
            await fetchUsersByIds(ids: friendsIds)
            
        } catch {
            print("Error fetching documents: \(error)")
            self.errorMessage = "Error fetching friends: \(error.localizedDescription)"
        }
    }
    
    private func findUserByEmail(email: String, completion: @escaping (String?) -> Void) {
        dataBase.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error finding user by email: \(error)")
                self.errorMessage = "Error finding user by email: \(error.localizedDescription)"
                completion(nil)
                return
            }
            
            if let document = querySnapshot?.documents.first {
                let userId = document.documentID
                completion(userId)
            } else {
                self.errorMessage = "No user found with this email."
                completion(nil)
            }
        }
    }
    
    private func addFriend(userId: String, friendId: String, completion: @escaping (Bool) -> Void) {
        let userRef = dataBase.collection("users").document(userId).collection("friends").document(friendId)
        userRef.setData(["id": friendId]) { error in
            if let error = error {
                print("Error adding friend: \(error)")
                self.errorMessage = "Error adding friend: \(error.localizedDescription)"
                completion(false)
                return
            }
            
            self.friendsIds.append(friendId)
            completion(true)
            
            Task {
                await self.fetchUsersByIds(ids: self.friendsIds)
            }
        }
    }
    
    func addFriendByEmail(email: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        findUserByEmail(email: email) { [weak self] friendId in
            guard let self = self, let friendId = friendId else {
                completion(false)
                return
            }
            self.addFriend(userId: userId, friendId: friendId, completion: completion)
        }
    }
    
    @MainActor
    private func fetchUsersByIds(ids: [String]) async {
        var users: [User] = []
        
        for id in ids {
            do {
                let document = try await dataBase.collection("users").document(id).getDocument()
                
                if document.exists, let user = try? document.data(as: User.self) {
                    users.append(user)
                } else {
                    print("Document does not exist or failed to decode for user with ID: \(id)")
                }
            } catch {
                print("Error fetching user with ID \(id): \(error.localizedDescription)")
                self.errorMessage = "Error fetching user: \(error.localizedDescription)"
            }
        }
        
        self.friends = users
    }

    func deleteFriend(friendId: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let friendRef = dataBase.collection("users").document(userId).collection("friends").document(friendId)
        
        friendRef.delete { error in
            if let error = error {
                print("Error deleting friend: \(error)")
                self.errorMessage = "Error deleting friend: \(error.localizedDescription)"
                completion(false)
                return
            }
            
            if let index = self.friendsIds.firstIndex(of: friendId) {
                self.friendsIds.remove(at: index)
                self.friends.removeAll { $0.id == friendId }
            }
            completion(true)
        }
    }
}
