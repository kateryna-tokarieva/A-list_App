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
                Picker(viewModel.category, selection: $viewModel.category, content:  {
                    ForEach(viewModel.allCategories, id: \.self) {
                        Text($0).tag($0)
                    }
                })
                .tint(.black)
                Button {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                } label: {
                    Image(systemName: "gearshape")
                }
                .tint(.red)
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
        })
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
