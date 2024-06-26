//
//  ListView.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ListViewModel
    @State private var showingSheet = false
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .shadow(color: .red, radius: 5, x: 5, y: 5)                .foregroundStyle(.white)
                .aspectRatio(1.0, contentMode: .fit)
            VStack {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .padding()
                VStack {
                    List {
                        Text("")
                    }
                    Button("+") {
                        showingSheet.toggle()
                        
                    }
                    .sheet(isPresented: $showingSheet, content: {
                       
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
        }

    }
}

#Preview {
    ListView(viewModel: ListViewModel(title: "АТБ", category: "Дім"))
}
