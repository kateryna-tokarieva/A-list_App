//
//  ListView.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ListViewModel
    @Binding var showingNewListSheet: Bool
    @Binding var showingListSheet: Bool
    @State private var showButton = true
    
    init(listId: String, showingNewListSheet: Binding<Bool>, showingListSheet: Binding<Bool>) {
        self.viewModel = ListViewModel(listID: listId)
        self._showingNewListSheet = showingNewListSheet
        self._showingListSheet = showingListSheet
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.list?.name ?? "")
                    .font(.title)
                    .underline(color: Resources.Colors.accentPink)
                    .foregroundStyle(Resources.Views.Colors.plainButtonText)
                    .padding()
                List {
                    if let list = viewModel.list {
                        if let items = list.items {
                            ForEach(items.indices, id: \.self) { index in
                                HStack {
                                    viewModel.itemIcons[index]
                                        .padding()
                                        .onTapGesture {
                                            viewModel.toggleItemIsDone(index: index)
                                        }
                                    Text(items[index].title)
                                    Spacer()
                                    Text(String(items[index].quantity))
                                    Text(items[index].unit.rawValue)
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
                    }
                    if viewModel.stateIsEditing {
                        HStack {
                            TextField(Resources.Strings.title, text: $viewModel.newItemTitle)
                            TextField(Resources.Strings.quantity, text: $viewModel.newItemQuantity)
                            Picker("", selection: $viewModel.newItemUnit) {
                                Text(Unit.g.rawValue).tag(Unit.g)
                                Text(Unit.kg.rawValue).tag(Unit.kg)
                                Text(Unit.ml.rawValue).tag(Unit.ml)
                                Text(Unit.l.rawValue).tag(Unit.l)
                                Text(Unit.pc.rawValue).tag(Unit.pc)
                            }
                        }
                        HStack {
                            Spacer()
                            Button {
                                viewModel.addItem(ShoppingItem(title: viewModel.newItemTitle, quantity: viewModel.newItemQuantity, unit: viewModel.newItemUnit, done: false))
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
                        .foregroundStyle(Resources.Views.Colors.borderedButtonText)
                        .tint(Resources.Views.Colors.borderedButtonTint)
                        .padding()
                        .shadow(color: Resources.Views.Colors.borderedButtonShadow, radius: Resources.Sizes.buttonCornerRadius, x: Resources.Sizes.buttonShadowOffset, y: Resources.Sizes.buttonShadowOffset)
                        .controlSize(.large)
                        .padding()
                    }
                }
                .onReceive(KeybordManager.shared.$keyboardFrame) { keyboardFrame in
                    if let keyboardFrame = keyboardFrame, keyboardFrame != .zero {
                        self.showButton = false
                    } else {
                        self.showButton = true
                    }
                
            }
        }
        .onDisappear {
            if !showingListSheet {
                showingNewListSheet = false
            }
        }
    }
}

#Preview {
    ListView(listId: "2F0EDB58-E8D8-47E1-9F7C-BEE9945BA8DF", showingNewListSheet: .constant(false), showingListSheet: .constant(false))
}
