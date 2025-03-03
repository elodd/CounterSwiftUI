//
//  InnerView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

struct CounterInnerView: View {
    @Bindable var viewModel: CounterViewModel
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            TextField("Name:", text: $viewModel.counter.name)
                .border(Color.black)
            HStack {
                Button("Add") {
                    self.viewModel.increment()
                }
                Text("\(self.viewModel.counter.count)")
                Button("Delete") {
                    self.viewModel.decrement()
                }
            }
        }
        .frame(width: 200, height: 100)
        .background(Color.init(red: 0.0, green: 0.0, blue: 1.0).opacity(0.2))
        .onDisappear() {
            self.saveState()
        }
    }
    
    func saveState() {
        do {
            self.modelContext.insert(self.viewModel.counter)
            try self.modelContext.save()
        } catch {
            print("Error saving counter: \(error)")
        }
    }
}
