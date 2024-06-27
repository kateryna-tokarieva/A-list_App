//
//  HomeView.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var showingSettingsSheet = false
    @State private var shovingNewListSheet = false
    @FirestoreQuery var lists: [ShoppingList]
    private var userId = ""
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(userId: String) {
        self.userId = userId
        self._lists = FirestoreQuery(collectionPath: "users/\(userId)/lists")
        print(lists)
    }
    
    var body: some View {
        VStack(alignment: .center, content: {
            HStack(alignment: .center, content: {
                //                Picker(viewModel.currentCategory, selection: $viewModel.currentCategory, content:  {
                //                    if let user = viewModel.user {
                //                        ForEach(user.categories, id: \.self) {
                //                            Text($0.name).tag($0.name)
                //                        }
                //                    }
                //                })
                //                .tint(.black)
                Button {
                    showingSettingsSheet.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
                .tint(.red)
                .sheet(isPresented: $showingSettingsSheet, content: {
                    SettingsView(userId: userId)
                })
            })
            
            VStack {
                if lists.isEmpty {
                    VStack {
                        Resources.Images.background
                            .resizable()
                            .scaledToFit()
                            .padding()
                        VStack {
                            Text(Resources.Strings.welcome)
                                .padding()
                                .font(.largeTitle)
                            Text(Resources.Strings.background)
                                .padding()
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                } else {
                    LazyVGrid(columns: columns) {
                        ForEach(lists, id: \.self) { list in
                            ListPreviewView(viewModel: ListPreviewViewViewModel(title: list.name, items: list.items, dueDate: list.dueDate))
                        }
                    }
                }
                Spacer()
                Button("+") {
                    shovingNewListSheet.toggle()
                    
                }
                .sheet(isPresented: $shovingNewListSheet, content: {
                    NewListView(viewModel: NewListViewModel())
                })
                .buttonStyle(.borderedProminent)
                .clipShape(.circle)
                .foregroundStyle(.white)
                .tint(.red)
                .padding()
                .shadow(color: .red, radius: 2, x: 2, y: 2)
                .controlSize(.large)
            }
        })
    }
}

#Preview {
    HomeView(userId: "3YIxHKN4ekMJ5V9zdJqkDgzEenI2")
}
