//
//  AddList.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct NewListView: View {
    @ObservedObject var viewModel = NewListViewModel()
    @State var step = NewListStep.name
    @State private var showingSheet = false
    @Binding var showingNewListSheet: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 0.0) {
                header
                content
                footer
            }
            .onAppear {
                viewModel.update(step: step)
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    ForEach(1...2, id: \.self) {
                        Text("\($0)")
                            .foregroundStyle(Resources.Colors.text)
                            .padding()
                        Spacer()
                    }
                }
                ProgressView(value: viewModel.progress)
                    .tint(Resources.Colors.accentPink)
            }
            Spacer()
            Text(viewModel.stepTitle)
                .font(.largeTitle)
                .foregroundStyle(Resources.Colors.text)
            Spacer()
        }
    }
    
    private var content: some View {
        VStack(alignment: .trailing) {
            ZStack {
                VStack {
                    HStack {
                        ZStack {
                            TextField(viewModel.listTitle, text: $viewModel.listTitle)
                                .padding()
                                .opacity(Double(viewModel.textFieldOpacity))
                                .foregroundStyle(Resources.Colors.subText)
                        }
                    }
                    Divider()
                }
                DatePicker(selection: $viewModel.dueDate, label: { Text(Resources.Strings.setupNotification) })
                    .opacity(Double(viewModel.datePickerOpacity))
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
    
    private var footer: some View {
        VStack {
            HStack {
                Button {
                    self.step = .timer
                    self.viewModel.save()
                    showingSheet.toggle()
                } label: {
                    Text(Resources.Strings.skip)
                        .underline()
                }
                .sheet(isPresented: $showingSheet, onDismiss: {
                    showingNewListSheet = false
                }) {
                    ListView(listId: viewModel.listId, showingNewListSheet: $showingNewListSheet, showingListSheet: $showingSheet)
                }
                .padding()
                .opacity(Double(viewModel.datePickerOpacity))
                .foregroundColor(.gray)
                Spacer()
                Button {
                    guard self.step != .timer else {
                        self.viewModel.save()
                        showingSheet.toggle()
                        return
                    }
                    self.step = .timer
                    viewModel.update(step: step)
                } label: {
                    Resources.Images.checkmark
                }
                .buttonStyle(.borderedProminent)
                .clipShape(.circle)
                .foregroundStyle(Resources.ViewColors.borderedButtonText)
                .tint(Resources.ViewColors.borderedButtonTint)
                .padding()
                .shadow(color: Resources.ViewColors.borderedButtonShadow, radius: Resources.Sizes.buttonCornerRadius, x: Resources.Sizes.buttonShadowOffset, y: Resources.Sizes.buttonShadowOffset)
                .controlSize(.large)
                .sheet(isPresented: $showingSheet, onDismiss: {
                    showingNewListSheet = false
                }) {
                    ListView(listId: viewModel.listId, showingNewListSheet: $showingNewListSheet, showingListSheet: $showingSheet)
                }
            }
            Spacer(minLength: 300)
        }
    }
}

#Preview {
    NewListView(showingNewListSheet: .constant(true))
}
