//
//  UserSettingsViewViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 10.07.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserSettingsViewViewModel: ObservableObject {
    @Published var user: User?
    @Published var profileImage: UIImage?
    
    init() {
        fetchUser()
    }
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        dataBase.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data() else { return }
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    image: data["image"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    friends: data["friends"] as? [String] ?? [],
                    settings: data["settings"] as? Settings ?? Settings()
                )
                
                if let imageUrlString = data["image"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    self?.downloadImage(from: imageUrl)
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            // Handle error
        }
    }
    
    func changeProfileImage(image: UIImage) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profileImages/\(userId).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { [weak self] url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else { return }
                
                let dataBase = Firestore.firestore()
                dataBase.collection("users").document(userId).updateData([
                    "image": downloadURL.absoluteString
                ]) { error in
                    if let error = error {
                        print("Error updating Firestore: \(error.localizedDescription)")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.user?.image = downloadURL.absoluteString
                        self?.profileImage = image
                    }
                }
            }
        }
    }
    
    func changeUserName(name: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        dataBase.collection("users").document(userId).updateData([
            "name": name
        ]) { error in
            if let error = error {
                print("Error updating Firestore: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.user?.name = name
            }
        }
    }
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.profileImage = image
            }
        }.resume()
    }
}
