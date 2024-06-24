//
//  ListView.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ListViewModel
    @State private var selectedIds: [UUID] = []
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .shadow(color: .red, radius: 5, x: 5, y: 5)                .foregroundStyle(.white)
                .aspectRatio(1.0, contentMode: .fit)
            VStack {
                Text(viewModel.title)
                    .font(.largeTitle)
                VStack {
                    let items = viewModel.shoppingItems
                    List(items) {
                        Text($0.title)
                        }
                
                }
            }
        }
        
    }
}

#Preview {
    ListView(viewModel: ListViewModel(title: "АТБ", category: "Дім", shoppingItems: [ShoppingItem(title: "молоко", quantity: 3, unit: .l, done: false), ShoppingItem(title: "цукор", quantity: 1, unit: .kg, done: false)]))
}
