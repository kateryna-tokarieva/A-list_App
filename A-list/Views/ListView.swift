//
//  ListView.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct ListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: ListViewModel
    @Binding var showingNewListSheet: Bool
    @Binding var showingListSheet: Bool
    @State private var showButton = true
    @State private var showDeletingListAlert = false
    @State private var isShowingScanner = false
    @State private var showingFriendsList = false
    @State private var showDeletingFriendAlert = false
    @State private var selectedFriend: User?
    @State private var isEditingName = false
    
    init(listId: String, showingNewListSheet: Binding<Bool>, showingListSheet: Binding<Bool>) {
        self.viewModel = ListViewModel(listId: listId)
        self._showingNewListSheet = showingNewListSheet
        self._showingListSheet = showingListSheet
    }
    
    var body: some View {
        ZStack {
            VStack {
                header
                content
                footer
            }
        }
        .background(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
        .onReceive(KeybordManager.shared.$keyboardFrame) { keyboardFrame in
            if let keyboardFrame = keyboardFrame, keyboardFrame != .zero {
                self.showButton = false
            } else {
                self.showButton = true
            }
        }
        .onDisappear {
            if !showingListSheet {
                showingNewListSheet = false
            }
        }
    }
    
    var header: some View {
        HStack {
            HStack {
                if viewModel.stateIsEditing {
                    Button(action: {
                        showDeletingListAlert = true
                    }) {
                        Image(systemName: "trash")
                            .tint(Resources.ViewColors.error(forScheme: themeManager.colorScheme))
                    }
                    .padding(.leading)
                    .alert(isPresented: $showDeletingListAlert) {
                        Alert(
                            title: Text(Resources.Strings.deleteConfirmationAlertTitle),
                            message: Text(Resources.Strings.deleteConfirmationAlertContent),
                            primaryButton: .destructive(Text(Resources.Strings.deleteConfirmationAlertPrimaryButton)) {
                                viewModel.deleteList()
                                presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    Menu {
                        ForEach(viewModel.friends, id: \.self) { friend in
                            Button {
                                viewModel.shareWithFriend(withName: friend.name)
                            } label: {
                                Text(friend.name)
                            }
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    .padding()
                    
                    if !viewModel.sharedFriends.isEmpty {
                        Menu {
                            ForEach(viewModel.sharedFriends, id: \.self) { friend in
                                Button(action: {
                                    selectedFriend = friend
                                    showDeletingFriendAlert = true
                                }) {
                                    HStack {
                                        Text(friend.name)
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                        }
                        .menuStyle(BorderlessButtonMenuStyle())
                        .alert(isPresented: $showDeletingFriendAlert) {
                            Alert(
                                title: Text(Resources.Strings.deleteConfirmationAlertTitle),
                                message: Text(Resources.Strings.deleteSharedFriendAlertContent),
                                primaryButton: .destructive(Text(Resources.Strings.deleteConfirmationAlertPrimaryButton)) {
                                    if let friend = selectedFriend {
                                        viewModel.deleteFriendFromShared(withName: friend.name)
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
            .frame(width: 100)
            if isEditingName {
                TextField("Enter new name", text: $viewModel.editedName, onCommit: {
                    viewModel.list?.name = viewModel.editedName
                    isEditingName = false
                    viewModel.updateListName()
                })
                .font(.title)
                .lineLimit(2)
                .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Text(viewModel.list?.name ?? "")
                    .font(.title)
                    .lineLimit(2)
                    .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onTapGesture(count: 2) {
                        isEditingName = true
                        viewModel.editedName = viewModel.list?.name ?? ""
                    }
                    .onLongPressGesture {
                        isEditingName = true
                        viewModel.editedName = viewModel.list?.name ?? ""
                    }
            }
            
            HStack {
                Spacer()
                Text(viewModel.doneItemsText)
                    .padding()
                    .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
                    .overlay(
                        Circle()
                            .stroke(Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), lineWidth: 1)
                    )
                    .padding()
            }
            .frame(width: 100)
        }
    }
    
    var content: some View {
        List {
            if let list = viewModel.list {
                if let items = list.items {
                    ForEach(items.indices, id: \.self) { index in
                        itemRow(for: index)
                            .listRowBackground(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
                    }
                }
            }
            if viewModel.stateIsEditing {
                TextField(Resources.Strings.title, text: $viewModel.newItemTitle)
                    .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
                    .padding()
                    .listRowBackground(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
                HStack {
                    TextField(Resources.Strings.quantity, text: $viewModel.newItemQuantity)
                        .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
                        .padding()
                    Picker("", selection: $viewModel.newItemUnit) {
                        ForEach(Unit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
                    .listRowBackground(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
                    Spacer()
                    Resources.Images.checkmark
                        .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                        .onTapGesture {
                            viewModel.addItem(ShoppingItem(title: viewModel.newItemTitle, quantity: viewModel.newItemQuantity, unit: viewModel.newItemUnit, isDone: false))
                            viewModel.newItemTitle = ""
                            viewModel.newItemQuantity = ""
                        }
                        .padding()
                }
                .listRowBackground(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
                button
                    .listRowBackground(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
            }
        }
        .listStyle(.plain)
    }
    
    var button: some View {
        HStack {
            Spacer()
            Button {
                isShowingScanner.toggle()
            } label: {
                Resources.Images.barcode
                    .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            }
            .sheet(isPresented: $isShowingScanner) {
                ScannerView { code in
                    viewModel.scannedCode = code
                    isShowingScanner = false
                    viewModel.fetchCodeData()
                }
            }
            .padding()
            Spacer()
        }
    }
    
    var footer: some View {
        VStack {
            if showButton {
                Button {
                    viewModel.stateIsEditing.toggle()
                    viewModel.updateForState()
                } label: {
                    viewModel.buttonImage
                }
                .buttonStyle(.borderedProminent)
                .clipShape(.circle)
                .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
                .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                .padding()
                .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: Resources.Sizes.buttonCornerRadius, x: Resources.Sizes.buttonShadowOffset, y: Resources.Sizes.buttonShadowOffset)
                .controlSize(.large)
                .padding()
            }
        }
        .background(.clear)
    }
    
    func itemRow(for index: Int) -> some View {
        HStack {
            viewModel.itemIcons[index]
                .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                .padding()
                .onTapGesture {
                    viewModel.toggleItemIsDone(index: index)
                }
            Text(viewModel.list?.items?[index].title ?? "")
                .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
            Spacer()
            
            Text(viewModel.list?.items?[index].quantity ?? "")
                .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
            
            Text(viewModel.list?.items?[index].unit.rawValue ?? "")
                .padding(.trailing)
                .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
        }
        .swipeActions {
            Button(role: .destructive) {
                viewModel.deleteItem(withIndex: index)
                viewModel.fetchList()
                
            } label: {
                Label("Видалити", systemImage: "trash")
            }
            .tint(Resources.ViewColors.error(forScheme: themeManager.colorScheme))
            .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
            Button {
                viewModel.editItem(withIndex: index)
            } label: {
                Label("Редагувати", systemImage: "pencil")
            }
            .tint(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
            .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
        }
    }
}

#Preview {
    ListView(listId: "2F0EDB58-E8D8-47E1-9F7C-BEE9945BA8DF", showingNewListSheet: .constant(false), showingListSheet: .constant(false))
}
