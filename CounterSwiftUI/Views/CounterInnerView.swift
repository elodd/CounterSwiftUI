//
//  CounterInnerView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

struct CounterInnerView: View {
    @Bindable var viewModel: CounterViewModel
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack(alignment: .center) {
            Label("Date:\(self.viewModel.counterModel.date.formatted(date: .abbreviated, time: .shortened))", systemImage: "calendar")
                .dynamicTypeSize(.small)
                .padding()
            TextField("Name:", text: $viewModel.counterModel.name)
                .border(Color.black)
                .padding()
            HStack {
                Button("Add") {
                    self.viewModel.increment()
                }
                .padding()
                Text("\(self.viewModel.counterModel.count)")
                .padding()
                Button("Delete") {
                    self.viewModel.decrement()
                }
                .padding()
            }
        }
        .frame(width: 250, height: 200)
        .background(Color.init(red: 0.0, green: 0.0, blue: 1.0).opacity(0.2))
        .onDisappear() {
            self.saveState()
        }
    }
    
    func saveState() {
        do {
            self.modelContext.insert(self.viewModel.counterModel)
            try self.modelContext.save()
        } catch {
            print("Error saving counter: \(error)")
        }
    }
}
