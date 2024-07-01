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
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingSettingsSheet = false
    @State private var showingNewListSheet = false
    @State private var showingListSheet = false
    
    private var userId = ""
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                header
                content
            }
            footer
        }
    }
    
    private var header: some View {
        HStack(alignment: .center) {
            Spacer()
            Text(Resources.Strings.allLists)
                .font(.title)
                .underline(color: Resources.Colors.accentPink)
                .foregroundStyle(Resources.Views.Colors.plainButtonText)
            Spacer()
            Button {
                showingSettingsSheet.toggle()
            } label: {
                Resources.Images.settings
            }
            .controlSize(.large)
            .aspectRatio(contentMode: .fill)
            .tint(Resources.Views.Colors.plainButtonText)
            .sheet(isPresented: $showingSettingsSheet) {
                SettingsView(userId: userId)
            }
        }
        .padding()
    }
    
    private var content: some View {
        VStack {
            if viewModel.lists.isEmpty {
                emptyState
            } else {
                listGrid
            }
        }
    }
    
    private var emptyState: some View {
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
                    .foregroundStyle(Resources.Colors.subText)
                    .multilineTextAlignment(.center)
            }
            .padding()
            Spacer()
        }
    }
    
    private var listGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.lists.indices, id: \.self) { list in
                    listItem(for: list)
                }
            }
            .padding()
        }
    }
    
    private func listItem(for index: Int) -> some View {
        VStack {
            HStack {
                Text(viewModel.lists[index].name + ":")
                    .font(.title2)
                    .foregroundColor(Resources.Colors.accentBlue)
                    .underline()
                    .lineLimit(1)
                Spacer()
            }
            .padding(.bottom)
            .padding(.leading)
            VStack {
                ForEach(0..<4) { itemIndex in
                    HStack {
                        Text("• " + (viewModel.lists[safe: index]?.items?[safe: itemIndex]?.title ?? "Item \(itemIndex + 1)"))
                            .padding(.leading)
                            .font(.caption)
                            .foregroundColor(Resources.Colors.subText)

                        Spacer()
                    }
                }
                .padding(.leading)
            }
        }
        .padding()
        .frame(width: Resources.Sizes.listPreviewFrame, height: Resources.Sizes.listPreviewFrame)
        .background(Resources.Colors.base)
        .cornerRadius(Resources.Sizes.listPreviewCornerRadius)
        .shadow(color: Resources.Colors.accentPink, radius: Resources.Sizes.listPreviewShadowRadius, x: Resources.Sizes.listPreviewShadowOffset, y: Resources.Sizes.listPreviewShadowOffset)
        .overlay(
            RoundedRectangle(cornerRadius: Resources.Sizes.listPreviewCornerRadius)
                .stroke(Resources.Colors.accentPink, lineWidth: 1)
        )
        .onTapGesture {
            viewModel.currentListId = viewModel.lists[index].id
            showingListSheet.toggle()
        }
        .sheet(isPresented: $showingListSheet, onDismiss: {
            Task {
                await viewModel.fetchLists()
            }
        }) {
            ListView(listId: viewModel.currentListId, showingNewListSheet: $showingNewListSheet, showingListSheet: $showingListSheet)
        }
    }
    
    private var footer: some View {
        VStack {
            Spacer()
            Button {
                showingNewListSheet.toggle()
            } label: {
                Resources.Images.add
            }
            .sheet(isPresented: $showingNewListSheet, onDismiss: {
                Task {
                    await viewModel.fetchLists()
                }
            }) {
                NewListView(viewModel: NewListViewModel(), showingNewListSheet: $showingNewListSheet)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(.circle)
            .foregroundStyle(Resources.Views.Colors.borderedButtonText)
            .tint(Resources.Views.Colors.borderedButtonTint)
            .padding()
            .shadow(color: Resources.Views.Colors.borderedButtonShadow, radius: Resources.Sizes.buttonCornerRadius, x: Resources.Sizes.buttonShadowOffset, y: Resources.Sizes.buttonShadowOffset)
            .controlSize(.large)
        }
    }
}

#Preview {
    HomeView(userId: "3YIxHKN4ekMJ5V9zdJqkDgzEenI2")
}
