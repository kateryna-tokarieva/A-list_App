//
//  HomeView.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var showingSheet = false
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack(alignment: .top, content: {
            ScrollView {
                LazyVGrid(columns: columns) {
                    //Lists
                }
            }
            
            HStack(alignment: .center, content: {
                Picker(viewModel.currentCategory, selection: $viewModel.currentCategory, content:  {
                    if let user = viewModel.user {
                        ForEach(user.categories, id: \.self) {
                            Text($0.name).tag($0.name)
                        }
                    }
                })
                .tint(.black)
                Button {
                    viewModel.fetchUser()
                    guard let _ = viewModel.user else { return }
                    viewModel.showingSheet.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
                .tint(.red)
                .sheet(isPresented: $viewModel.showingSheet, content: {
                    SettingsView(viewModel: SettingsViewModel(user: viewModel.user!))
                })
            })
            
            ZStack {
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
                    Spacer()
                    Button("+") {
                        viewModel.fetchUser()
                        showingSheet.toggle()
                        
                    }
                    .sheet(isPresented: $showingSheet, content: {
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
                
            }
        })//.onAppear(perform: viewModel.fetchUser())
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(userId: "3YIxHKN4ekMJ5V9zdJqkDgzEenI2"))
}
