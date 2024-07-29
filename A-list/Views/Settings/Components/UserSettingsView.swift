//
//  UserSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var viewModel: UserSettingsViewViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingLoginSheet = false
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var isEditing = false
    @State var name = ""
    @State private var showProfileImage = true
    
    var body: some View {
        VStack {
            if showProfileImage {
                profileImage
            }
            VStack (alignment: .leading) {
                userName
                userEmail
            }
            Spacer()
            footer
        }
        .navigationBarTitle("Налаштування профілю")
        .sheet(isPresented: $isImagePickerPresented, content: {
            ImagePicker(image: $selectedImage, onImagePicked: { image in
                if let image = image {
                    viewModel.changeProfileImage(image: image)
                }
            })
        })
        .onReceive(KeybordManager.shared.$keyboardFrame) { keyboardFrame in
            if let keyboardFrame = keyboardFrame, keyboardFrame != .zero {
                self.showProfileImage = false
            } else {
                self.showProfileImage = true
            }
        }
    }
    
    var profileImage: some View {
        VStack {
            if let image = viewModel.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .clipped()
            } else {
                Resources.Images.userImagePlaceholder
                    .resizable()
                    .frame(width: 120, height: 120)
            }
            Button(action: {
                isImagePickerPresented.toggle()
            }, label: {
                Text("Завантажити фото")
            })
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: true, vertical: false)
            .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: CGFloat(Resources.Sizes.buttonCornerRadius)))
            .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: CGFloat(Resources.Sizes.buttonShadowRadius), x: CGFloat(Resources.Sizes.buttonShadowRadius), y: CGFloat(Resources.Sizes.buttonShadowRadius))
            .padding()
        }
    }
    
    var userName: some View {
        VStack (alignment: .leading) {
            Text("Бажане імʼя")
                .font(.headline)
                .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
            TextField(viewModel.user?.name ?? "", text: $name, onCommit: {
                viewModel.changeUserName(name: name)
            })
                .textFieldStyle(.roundedBorder)
                .padding(.top)
                
        }
        .padding()
    }
    
    var userEmail: some View {
        VStack (alignment: .leading) {
            Text("Ел. пошта")
                .font(.headline)
                .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
            Text(viewModel.user?.email ?? "")
                .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
                .font(.subheadline)
                .padding(.top)
        }
        .padding()
    }
    
    var footer: some View {
        Button {
            viewModel.logout()
            showingLoginSheet.toggle()
        } label: {
            Text("Вийти")
        }
        .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
        .fullScreenCover(isPresented: $showingLoginSheet, content: {
            LoginView()
        })
    }
}
