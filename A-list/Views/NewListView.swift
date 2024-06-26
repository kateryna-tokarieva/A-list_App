//
//  AddList.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct NewListView: View {
    @StateObject var viewModel = NewListViewModel()
    @State var step = NewListStep.name
    @State private var showingSheet = false
    
    var body: some View {
        ZStack(alignment: .top, content: {
            VStack (alignment: .center, spacing: 0.0, content: {
                
                VStack  (spacing: 0, content: {
                    VStack {
                        HStack {
                            Spacer()
                            ForEach(1...3, id: \.self) {
                                Text("\($0)")
                                    .foregroundStyle(.black)
                                    .padding()
                                Spacer()
                            }
                            .onAppear {
                                viewModel.update(step: step)
                            }
                        }
                        ProgressView(value: viewModel.progress)
                            .tint(.red)
                    }
                    Spacer()
                    Text(viewModel.title)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    Spacer()
                })
                VStack(alignment: .trailing) {
                    ZStack {
                        VStack {
                            HStack {
                                ZStack {
                                    TextField(viewModel.titleTextFieldText, text: $viewModel.titleTextFieldText)
                                        .padding()
                                        .opacity(Double(viewModel.titleTextFieldOpacity))
                                        .foregroundColor(.gray)
                                    
                                    TextField(viewModel.categoryTextFieldText, text: $viewModel.categoryTextFieldText) {
                                        // Додати функціонал додавання нової категорії
                                    }
                                    .padding()
                                    .opacity(Double(viewModel.categoryMenuOpacity))
                                    .foregroundColor(.gray)
                                }
                                Picker(viewModel.category, selection: $viewModel.category, content:  {
                                    ForEach(viewModel.allCaterories, id: \.self) {
                                        Text($0).tag($0)
                                    }
                                })
                                .tint(.black)
                                .opacity(Double(viewModel.categoryMenuOpacity))
                            }
                            Divider()
                        }
                        DatePicker(selection: $viewModel.dueDate, label: { Text("Постав нагадування:") })
                            .opacity(Double(viewModel.datePickerOpacity))
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Button {
                            self.step = NewListStep(rawValue: step.rawValue + 1) ?? NewListStep.name
                            viewModel.update(step: step)
                            
                        } label: {
                            Text("Пропустити")
                                .underline()
                        }
                        .opacity(Double(viewModel.datePickerOpacity))
                        .foregroundColor(.gray)
                        Spacer()
                        Button {
                            guard self.step != .category else {
                                showingSheet.toggle()
                                return
                            }
                            self.step = NewListStep(rawValue: step.rawValue + 1) ?? NewListStep.name
                            viewModel.update(step: step)
                            
                            
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        .buttonStyle(.borderedProminent)
                        .clipShape(.circle)
                        .foregroundStyle(.white)
                        .tint(.red)
                        .controlSize(.large)
                        .shadow(color: .red, radius: 2, x: 2, y: 2)
                        .sheet(isPresented: $showingSheet, content: {
                            ListView(viewModel: ListViewModel(title: self.viewModel.titleTextFieldText, category: self.viewModel.category))
                        })
                    }
                }
                .padding()
                Spacer(minLength: 300)
            })
        })
    }
}

#Preview {
    NewListView()
}
