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
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingSettingsSheet = false
    @State private var showingNewListSheet = false
    @State private var showingListSheet = false
    @State private var showingSharedListSheet = false
    
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
        .background(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
        .onAppear {
            Task {
                await viewModel.fetchLists()
                await viewModel.fetchSharedLists()
            }
        }
    }
    
    private var header: some View {
        HStack(alignment: .center) {
            Spacer()
            Text(Resources.Strings.allLists)
                .font(.title)
                .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
            Spacer()
            Button {
                showingSettingsSheet.toggle()
            } label: {
                Resources.Images.settings
            }
            .controlSize(.large)
            .aspectRatio(contentMode: .fill)
            .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            .sheet(isPresented: $showingSettingsSheet) {
                SettingsView(userId: userId)
            }
        }
        .padding()
    }
    
    private var content: some View {
        VStack {
            if viewModel.lists.isEmpty && viewModel.sharedLists.isEmpty {
                emptyState
            } else {
                listGrid
            }
        }
    }
    
    private var emptyState: some View {
        VStack {
            Resources.Images.background(forScheme: themeManager.colorScheme)
                .resizable()
                .scaledToFit()
                .padding()
            VStack {
                Text(Resources.Strings.welcome)
                    .padding()
                    .font(.largeTitle)
                    .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
                Text(Resources.Strings.background)
                    .padding()
                    .font(.subheadline)
                    .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
                    .multilineTextAlignment(.center)
            }
            .padding()
            Spacer()
        }
    }
    
    private var listGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.lists.indices, id: \.self) { index in
                    listItem(for: index)
                        .id("listItem_\(index)")
                }
                ForEach(viewModel.sharedLists.indices, id: \.self) { index in
                    sharedListItem(for: index)
                        .id("sharedListItem_\(index)")
                }
            }
            .padding()
        }
    }

    
    private func sharedListItem(for index: Int) -> some View {
        VStack {
            HStack {
                Resources.Images.sharedList
                    .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                Text(viewModel.sharedLists[index].name + ":")
                    .font(.title2)
                    .foregroundColor(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
                    .lineLimit(1)
                Spacer()
            }
            .padding(.bottom)
            .padding(.leading)
            VStack {
                ForEach(0..<4) { itemIndex in
                    HStack {
                        Text("• " + (viewModel.sharedLists[safe: index]?.items?[safe: itemIndex]?.title ?? ""))
                            .padding(.leading)
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))

                        Spacer()
                    }
                }
                .padding(.leading)
            }
        }
        .padding()
        .frame(width: Resources.Sizes.listPreviewFrame, height: Resources.Sizes.listPreviewFrame)
        .background(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
        .cornerRadius(Resources.Sizes.listPreviewCornerRadius)
        .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: Resources.Sizes.listPreviewShadowRadius, x: Resources.Sizes.listPreviewShadowOffset, y: Resources.Sizes.listPreviewShadowOffset)
        .overlay(
            RoundedRectangle(cornerRadius: Resources.Sizes.listPreviewCornerRadius)
                .stroke(Resources.ViewColors.accent(forScheme: themeManager.colorScheme), lineWidth: 1)
        )
        .onTapGesture {
            viewModel.currentListId = viewModel.sharedLists[index].id
            showingSharedListSheet.toggle()
        }
        .sheet(isPresented: $showingSharedListSheet, onDismiss: {
            Task {
                await viewModel.fetchLists()
                await viewModel.fetchSharedLists()
            }
        }) {
            SharedListView(listId: viewModel.currentListId)
        }
    }
    
    private func listItem(for index: Int) -> some View {
        VStack {
            HStack {
                Text(viewModel.lists[index].name + ":")
                    .font(.title2)
                    .foregroundColor(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
                    .lineLimit(1)
                Spacer()
            }
            .padding(.bottom)
            .padding(.leading)
            VStack {
                ForEach(0..<4) { itemIndex in
                    HStack {
                        Text("• " + (viewModel.lists[safe: index]?.items?[safe: itemIndex]?.title ?? ""))
                            .padding(.leading)
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))

                        Spacer()
                    }
                }
                .padding(.leading)
            }
        }
        .padding()
        .frame(width: Resources.Sizes.listPreviewFrame, height: Resources.Sizes.listPreviewFrame)
        .background(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
        .cornerRadius(Resources.Sizes.listPreviewCornerRadius)
        .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: Resources.Sizes.listPreviewShadowRadius, x: Resources.Sizes.listPreviewShadowOffset, y: Resources.Sizes.listPreviewShadowOffset)
        .overlay(
            RoundedRectangle(cornerRadius: Resources.Sizes.listPreviewCornerRadius)
                .stroke(Resources.ViewColors.accent(forScheme: themeManager.colorScheme), lineWidth: 1)
        )
        .onTapGesture {
            viewModel.currentListId = viewModel.lists[index].id
            showingListSheet.toggle()
        }
        .sheet(isPresented: $showingListSheet, onDismiss: {
            Task {
                await viewModel.fetchLists()
                await viewModel.fetchSharedLists()
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
                    await viewModel.fetchSharedLists()
                }
            }) {
                NewListView(viewModel: NewListViewModel(), showingNewListSheet: $showingNewListSheet)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(.circle)
            .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
            .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            .padding()
            .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: Resources.Sizes.buttonCornerRadius, x: Resources.Sizes.buttonShadowOffset, y: Resources.Sizes.buttonShadowOffset)
            .controlSize(.large)
        }
    }
}

#Preview {
    HomeView(userId: "3YIxHKN4ekMJ5V9zdJqkDgzEenI2")
}
