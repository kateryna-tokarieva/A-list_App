//
//  Test.swift
//  A-list
//
//  Created by Екатерина Токарева on 01.07.2024.
//

import SwiftUI

struct Test: View {
    @State private var items = ["Item 1", "Item 2", "Item 3"]
        @State private var showingDeleteAlert = false
        @State private var itemToDelete: String? = nil

        var body: some View {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .swipeActions {
                            Button(role: .destructive) {
                                itemToDelete = item
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Item"),
                    message: Text("Are you sure you want to delete this item?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let item = itemToDelete, let index = items.firstIndex(of: item) {
                            items.remove(at: index)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
}

#Preview {
    Test()
}
