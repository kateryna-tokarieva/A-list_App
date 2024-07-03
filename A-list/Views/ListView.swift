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
    @State private var showAlert = false
    
    init(listId: String, showingNewListSheet: Binding<Bool>, showingListSheet: Binding<Bool>) {
        self.viewModel = ListViewModel(listID: listId)
        self._showingNewListSheet = showingNewListSheet
        self._showingListSheet = showingListSheet
    }
    
    var body: some View {
        ZStack {
            VStack {
                header
                content
            }
            footer
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
        ZStack {
            HStack {
                Spacer()
                
                Text(viewModel.list?.name ?? "")
                    .font(.title)
                    .underline(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme))
                    .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            
            HStack {
                Button(action: {
                    showAlert = true
                }) {
                    Image(systemName: "trash")
                        .tint(Resources.ViewColors.error(forScheme: themeManager.colorScheme))
                }
                .alert(isPresented: $showAlert) {
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
                .padding()
                
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
        }
    }

    
    var content: some View {
        List {
            if let list = viewModel.list {
                if let items = list.items {
                    ForEach(items.indices, id: \.self) { index in
                        itemRow(for: index)
                    }
                }
            }
            if viewModel.stateIsEditing {
                HStack {
                    TextField(Resources.Strings.title, text: $viewModel.newItemTitle)
                    TextField(Resources.Strings.quantity, text: $viewModel.newItemQuantity)
                    Picker("", selection: $viewModel.newItemUnit) {
                        ForEach(Unit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.addItem(ShoppingItem(title: viewModel.newItemTitle, quantity: viewModel.newItemQuantity, unit: viewModel.newItemUnit, isDone: false))
                        viewModel.newItemTitle = ""
                        viewModel.newItemQuantity = ""
                    } label: {
                        Resources.Images.checkmark
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    var footer: some View {
        VStack {
            Spacer()
            
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
    }
    
    func itemRow(for index: Int) -> some View {
        HStack {
            viewModel.itemIcons[index]
                .padding()
                .onTapGesture {
                    viewModel.toggleItemIsDone(index: index)
                }
            Text(viewModel.list?.items?[index].title ?? "")
            
            Spacer()
            
            Text(viewModel.list?.items?[index].quantity ?? "")
            
            Text(viewModel.list?.items?[index].unit.rawValue ?? "")
                .padding(.trailing)
        }
        .swipeActions {
            Button(role: .destructive) {
                viewModel.deleteItem(withIndex: index)
                viewModel.fetchList()
            } label: {
                Label("Видалити", systemImage: "trash")
            }
        }
    }
}

#Preview {
    ListView(listId: "2F0EDB58-E8D8-47E1-9F7C-BEE9945BA8DF", showingNewListSheet: .constant(false), showingListSheet: .constant(false))
}
