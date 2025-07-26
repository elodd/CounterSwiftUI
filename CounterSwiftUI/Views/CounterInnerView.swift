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
            Label(self.viewModel.counterModel.nameString(), systemImage: "person")
            Label(self.viewModel.counterModel.countString(),
                systemImage: "digitalcrown.arrow.counterclockwise"
            )
                .onChange(of: self.viewModel.counterModel.count) { oldValue, newValue in
                    print("Count changed from \(oldValue) to \(newValue)")
                    print("\(self.viewModel.counterModel.description)")
                    self.saveState()
                }
            HStack {
                Button("Decrement") {
                    self.viewModel.decrement()
                }
                .bold()
                Button("Increment") {
                    self.viewModel.increment()
                }
                .bold()
            }
        }
        .frame(width: 340, height: 250)
        .background(Color.init(red: 0.0, green: 0.0, blue: 1.0).opacity(0.2))
    }

    func saveState() {
        do {
            try self.modelContext.save()
            print("Saved the counter state")
        } catch {
            print("Error saving counter: \(error)")
        }
    }
}

#Preview {
    CounterInnerView(
        viewModel: CounterViewModel(counterModel: CounterModel(
            name: "Counter0",
            count: 0,
            date: Date()
        ))
    )
}

import Playgrounds

#Playground {
    let counterModel = CounterModel(name: "Counter0", count: 0, date: Date())
    print(counterModel.description)
}
