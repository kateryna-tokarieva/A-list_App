//
//  ListPreviewView.swift
//  A-list
//
//  Created by Екатерина Токарева on 27.06.2024.
//

import SwiftUI

struct ListPreviewView: View {
    @ObservedObject var viewModel = ListPreviewViewViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(viewModel.title)
                    Text(String(viewModel.doneItems) + "/" + String(viewModel.items?.count ?? 0))
                }
                if let items = viewModel.items {
                    ForEach(items, id: \.self) {item in
                        HStack {
                            Text("•" + item.title)
                            Spacer()                            
                            Text(String(item.quantity))
                            Text(item.unit.rawValue)
                            
                        }
                    }
                }
            }
        }.clipShape(RoundedRectangle(cornerRadius: CGFloat(Resources.Numbers.listPreviewViewCornerRadius)))
    }
}

#Preview {
    ListPreviewView(viewModel: ListPreviewViewViewModel(title: "ATB", items: [ShoppingItem(title: "milk", quantity: 1, unit: .l, done: false, id: "")], dueDate: nil))
}
