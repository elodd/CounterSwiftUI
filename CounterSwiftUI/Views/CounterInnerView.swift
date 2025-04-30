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
            Label(
                self.viewModel.counterModel.dateString(),
                systemImage: "calendar"
            )
                .dynamicTypeSize(.small)
                .padding()
            Label(self.viewModel.counterModel.name, systemImage: "person")
                .padding()
            Label(self.viewModel.counterModel.countString(),
                systemImage: "digitalcrown.arrow.counterclockwise"
            )
                .onChange(of: self.viewModel.counterModel.count) { oldValue, newValue in
                    print("Count changed from \(oldValue) to \(newValue)")
                    self.saveState()
                }
            HStack {
                Button("Decrement") {
                    self.viewModel.decrement()
                }
                .font(.custom("Courier New", size: 14))
                .bold()
                .fixedSize(horizontal: true, vertical: false)
                .padding()
                Button("Increment") {
                    self.viewModel.increment()
                }
                .font(.custom("Courier New", size: 14))
                .bold()
                .fixedSize(horizontal: true, vertical: false)
                .padding()
            }
        }
        .frame(width: 300, height: 250)
        .background(Color.init(red: 0.0, green: 0.0, blue: 1.0).opacity(0.2))
        .onAppear() {
            self.addCounter()
        }
    }

    func addCounter() {
        self.modelContext.insert(self.viewModel.counterModel)
    }

    func saveState() {
        do {
            try self.modelContext.save()
        } catch {
            print("Error saving counter: \(error)")
        }
    }
}

#Preview {
    CounterInnerView(
        viewModel: CounterViewModel(counterModel: CounterModel(
            name: "Counter1",
            count: 0,
            date: Date()
        ))
    )
}
