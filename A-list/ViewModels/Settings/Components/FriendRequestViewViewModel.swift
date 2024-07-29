//
//  FriendRequestViewViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 10.07.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FriendRequestViewViewModel: ObservableObject {
    @Published var receivedRequestsUsers: [User]?
    @Published var sentRequestsUsers: [User]?
    @Published var errorMessage: String?
    
    private let dataBase = Firestore.firestore()
    
    init() {
        Task {
            await fetchFriendRequests()
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

            self.receivedRequestsUsers = try receivedDocuments.compactMap { document in
                let user = try document.data(as: User.self)
                return user
            }

            self.sentRequestsUsers = try sentDocuments.compactMap { document in
                let user = try document.data(as: User.self)
                return user
            }

        } catch {
            print("Error fetching friend requests: \(error)")
            self.errorMessage = "Error fetching friend requests: \(error.localizedDescription)"
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
    
    func acceptFriendRequest(withId id: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        addFriend(userId: userId, friendId: id) { [weak self] success in
            guard let self = self, success else {
                completion(false)
                return
            }

            self.addFriend(userId: id, friendId: userId, completion: completion)
            self.deleteFriendRequest(fromUserId: id, toUserId: userId, completion: { _ in })
        }
    }

    func declineFriendRequest(withId id: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        deleteFriendRequest(fromUserId: id, toUserId: userId, completion: completion)
    }
    
    private func deleteFriendRequest(fromUserId: String, toUserId: String, completion: @escaping (Bool) -> Void) {
        let receivedRef = dataBase.collection("users").document(toUserId).collection("receivedFriendRequests").document(fromUserId)
        let sentRef = dataBase.collection("users").document(fromUserId).collection("sentFriendRequests").document(toUserId)

        receivedRef.delete { error in
            if let error = error {
                print("Error deleting received friend request: \(error)")
                completion(false)
                return
            }

            sentRef.delete { error in
                if let error = error {
                    print("Error deleting sent friend request: \(error)")
                    self.errorMessage = "Error deleting sent friend request: \(error.localizedDescription)"
                    completion(false)
                    return
                }

                completion(true)
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

            //self.friendsIds.append(friendId)
            completion(true)

//            Task {
//                await self.fetchUsersByIds(ids: self.friendsIds)
//            }
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
}
