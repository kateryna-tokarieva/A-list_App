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
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(userId: userId))
    }
    
    var body: some View {
        VStack(alignment: .center, content: {
            HStack(alignment: .center, content: {
                Spacer()
                Text("Всі списки")
                    .font(.title)
                    .underline(color: Resources.Colors.accentPink)
                    .foregroundStyle(Resources.Views.Colors.plainButtonText)
                Spacer()
                Button {
                    showingSettingsSheet.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
                .controlSize(.large)
                .aspectRatio(contentMode: .fill)
                .tint(Resources.Views.Colors.plainButtonText)
                .sheet(isPresented: $showingSettingsSheet, content: {
                    SettingsView(userId: userId)
                })
            })
            .padding()
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
                            VStack {
                                HStack {
                                    Text(list.name + ":")
                                        .font(.title2)
                                        .foregroundStyle(Resources.Colors.accentBlue)
                                        .underline()
                                    Spacer()
                                }
                                .padding(.bottom)
                                .padding(.bottom)
                                .padding(.leading)
                                VStack {
                                    HStack {
                                        Text("• " + (list.items?[0].title ?? "молоко"))
                                            .padding(.leading)
                                            .padding(.leading)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("• " + (list.items?[1].title ?? "хліб"))
                                            .padding(.leading)
                                            .padding(.leading)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("• " + (list.items?[2].title ?? "шоколадка"))
                                            .padding(.leading)
                                            .padding(.leading)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("• " + (list.items?[3].title ?? "масло"))
                                            .padding(.leading)
                                            .padding(.leading)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                        .frame(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.width/2 - 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Resources.Colors.accentPink, lineWidth: 1)
                                .shadow(color: Resources.Colors.accentPink, radius: 2, x: 4, y: 4))
                    }
                    .padding()
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
                .foregroundStyle(Resources.Views.Colors.borderedButtonText)
                .tint(Resources.Views.Colors.borderedButtonTint)
                .padding()
                .shadow(color: Resources.Views.Colors.borderedButtonShadow, radius: 2, x: 2, y: 2)
                .controlSize(.large)
            }
        })
    }
}

#Preview {
    HomeView(userId: "3YIxHKN4ekMJ5V9zdJqkDgzEenI2")
}
