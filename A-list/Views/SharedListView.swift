//
//  SharedListView.swift
//  A-list
//
//  Created by Екатерина Токарева on 08.07.2024.
//

import SwiftUI

struct SharedListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: SharedListViewViewModel
    @State private var showButton = true
    @State private var showDeletingListAlert = false
    @State private var isShowingScanner = false
    
    init(listId: String) {
        self.viewModel = SharedListViewViewModel(listID: listId)
        
    }
    
    var body: some View {
        header
        content
        footer
    }
    
    private var header: some View {
        ZStack {
            HStack {
                Spacer()
                
                Text("")
                    .font(.title)
                    .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            HStack {
                if viewModel.stateIsEditing {
                    Button(action: {
                        showDeletingListAlert = true
                    }) {
                        Image(systemName: "trash")
                            .tint(Resources.ViewColors.error(forScheme: themeManager.colorScheme))
                    }
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
                    .padding()
                }
            }
        }
    }
    
    private var content: some View {
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
                        .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
                        .padding()
                    TextField(Resources.Strings.quantity, text: $viewModel.newItemQuantity)
                        .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
                        .padding(.trailing)
                    Picker("", selection: $viewModel.newItemUnit) {
                        ForEach(Unit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
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
                button
            }
        }
        .background(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
        .listStyle(.plain)
    }
    
    private var footer: some View {
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
    
    private var button: some View {
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
    SharedListView(listId: "2F0EDB58-E8D8-47E1-9F7C-BEE9945BA8DF")
}
