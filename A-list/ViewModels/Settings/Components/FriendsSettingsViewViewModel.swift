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
    @Published var receivedFriendRequestsCount = 0
    @Published var errorMessage: String?

    private let dataBase = Firestore.firestore()

    init() {
        Task {
            await fetchFriends()
            await fetchFriendRequests()
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

    @MainActor
    private func fetchFriendRequests() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        do {
            let receivedSnapshot = try await dataBase.collection("users").document(userId).collection("receivedFriendRequests").getDocuments()
            let receivedDocuments = receivedSnapshot.documents

            let sentSnapshot = try await dataBase.collection("users").document(userId).collection("sentFriendRequests").getDocuments()
            let sentDocuments = sentSnapshot.documents

            let receivedFriendRequests = try receivedDocuments.compactMap { document in
                let user = try document.data(as: User.self)
                return user
            }
            self.receivedFriendRequestsCount = receivedFriendRequests.count
            
        } catch {
            print("Error fetching friend requests: \(error)")
            self.errorMessage = "Error fetching friend requests: \(error.localizedDescription)"
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

    func sendFriendRequest(withEmail email: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        findUserByEmail(email: email) { [weak self] friendId in
            guard let self = self, let friendId = friendId else {
                completion(false)
                return
            }

            self.sendFriendRequest(fromUserId: userId, toUserId: friendId, completion: completion)
        }
    }

    private func sendFriendRequest(fromUserId: String, toUserId: String, completion: @escaping (Bool) -> Void) {
        let userRef = dataBase.collection("users").document(toUserId).collection("receivedFriendRequests").document(fromUserId)
        userRef.setData(["id": fromUserId]) { error in
            if let error = error {
                print("Error sending friend request: \(error)")
                self.errorMessage = "Error sending friend request: \(error.localizedDescription)"
                completion(false)
                return
            }

            let sentRef = self.dataBase.collection("users").document(fromUserId).collection("sentFriendRequests").document(toUserId)
            sentRef.setData(["id": toUserId]) { error in
                if let error = error {
                    print("Error adding sent friend request: \(error)")
                    self.errorMessage = "Error adding sent friend request: \(error.localizedDescription)"
                    completion(false)
                    return
                }

                completion(true)
            }
        }
    }

    func deleteFriend(friendId: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        deleteFriend(userId: userId, friendId: friendId) { [weak self] success in
            guard let self = self, success else {
                completion(false)
                return
            }

            self.deleteFriend(userId: friendId, friendId: userId, completion: completion)
        }
    }

    private func deleteFriend(userId: String, friendId: String, completion: @escaping (Bool) -> Void) {
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
}
