//
//  ListView.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct ListView: View {
    @Environment(\.presentationMode) var presentationMode
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
        .onReceive(KeybordManager.shared.$keyboardFrame) { handleKeyboardFrameChange($0) }
        .onDisappear { handleOnDisappear() }
    }
    
    private var header: some View {
        HStack {
            deleteButton
            Spacer()
            listTitle
            Spacer()
            doneItemsIndicator
        }
    }
    
    private var content: some View {
        List {
            if let items = viewModel.list?.items {
                ForEach(items.indices, id: \.self) { index in
                    itemRow(for: index)
                }
            }
            if viewModel.stateIsEditing {
                newItemInputFields
                newItemAddButton
            }
        }
    }
    
    private var footer: some View {
        VStack {
            Spacer()
            if showButton {
                toggleEditButton
            }
        }
    }
    
    private var deleteButton: some View {
        Button(action: { showAlert = true }) {
            Image(systemName: "trash")
                .tint(Resources.Colors.accentRed)
        }
        .alert(isPresented: $showAlert) {
            deleteConfirmationAlert
        }
        .padding()
    }
    
    private var listTitle: some View {
        Text(viewModel.list?.name ?? "")
            .font(.title)
            .underline(color: Resources.Colors.accentPink)
            .foregroundStyle(Resources.Views.Colors.plainButtonText)
            .padding()
    }
    
    private var doneItemsIndicator: some View {
        Text(viewModel.doneItemsText)
            .padding()
            .foregroundStyle(Resources.Colors.subText)
            .overlay(
                Circle()
                    .stroke(Resources.Colors.accentPink, lineWidth: 1)
            )
            .padding()
    }
    
    private var newItemInputFields: some View {
        HStack {
            TextField(Resources.Strings.title, text: $viewModel.newItemTitle)
            TextField(Resources.Strings.quantity, text: $viewModel.newItemQuantity)
            unitPicker
        }
    }
    
    private var unitPicker: some View {
        Picker("", selection: $viewModel.newItemUnit) {
            ForEach(Unit.allCases, id: \.self) { unit in
                Text(unit.rawValue).tag(unit)
            }
        }
    }
    
    private var newItemAddButton: some View {
        HStack {
            Spacer()
            Button(action: addItem) {
                Resources.Images.checkmark
            }
            Spacer()
        }
    }
    
    private var toggleEditButton: some View {
        Button(action: toggleEditState) {
            viewModel.buttonImage
        }
        .buttonStyle(.borderedProminent)
        .clipShape(.circle)
        .foregroundStyle(Resources.Views.Colors.borderedButtonText)
        .tint(Resources.Views.Colors.borderedButtonTint)
        .padding()
        .shadow(color: Resources.Views.Colors.borderedButtonShadow, radius: Resources.Sizes.buttonCornerRadius, x: Resources.Sizes.buttonShadowOffset, y: Resources.Sizes.buttonShadowOffset)
        .controlSize(.large)
        .padding()
    }
    
    private var deleteConfirmationAlert: Alert {
        Alert(
            title: Text("Підтвердження"),
            message: Text("Ви впевнені, що хочете видалити цей список?"),
            primaryButton: .destructive(Text("Видалити")) {
                confirmDelete()
            },
            secondaryButton: .cancel()
        )
    }
    
    private func itemRow(for index: Int) -> some View {
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
            deleteItemButton(index: index)
        }
    }
    
    private func deleteItemButton(index: Int) -> some View {
        Button(role: .destructive) {
            viewModel.deleteItem(withIndex: index)
            viewModel.fetchList()
        } label: {
            Label("Видалити", systemImage: "trash")
        }
    }
    
    private func handleKeyboardFrameChange(_ keyboardFrame: CGRect?) {
        self.showButton = keyboardFrame == nil || keyboardFrame == .zero
    }
    
    private func handleOnDisappear() {
        if !showingListSheet {
            showingNewListSheet = false
        }
    }
    
    private func toggleEditState() {
        viewModel.stateIsEditing.toggle()
        viewModel.updateForState()
    }
    
    private func addItem() {
        let newItem = ShoppingItem(
            title: viewModel.newItemTitle,
            quantity: viewModel.newItemQuantity,
            unit: viewModel.newItemUnit,
            isDone: false
        )
        viewModel.addItem(newItem)
        viewModel.newItemTitle = ""
        viewModel.newItemQuantity = ""
    }
    
    private func confirmDelete() {
        viewModel.deleteList()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    ListView(
        listId: "2F0EDB58-E8D8-47E1-9F7C-BEE9945BA8DF",
        showingNewListSheet: .constant(false),
        showingListSheet: .constant(false)
    )
}
