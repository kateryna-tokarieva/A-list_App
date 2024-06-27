//
//  HomeView.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var showingSettingsSheet = false
    @State private var showingNewListSheet = false
    private var userId = ""
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(userId: userId))
    }
    
    var body: some View {
        VStack(alignment: .center, content: {
            HStack(alignment: .center, content: {
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
                if viewModel.lists.isEmpty {
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
                        ForEach(viewModel.lists, id: \.self) { list in
                            ListPreviewView(viewModel: ListPreviewViewViewModel(title: list.name, items: list.items, dueDate: list.dueDate))
                        }
                    }
                }
                Spacer()
                Button("+") {
                    showingNewListSheet.toggle()
                    
                }
                .sheet(isPresented: $showingNewListSheet, content: {
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
