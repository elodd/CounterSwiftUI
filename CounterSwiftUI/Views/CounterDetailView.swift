//
//  CounterDetailView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

struct CounterDetailView: View {
    @Bindable var viewModel: CounterViewModel
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack(alignment: .leading) {
            Label(
                self.viewModel.dateString(),
                systemImage: "calendar"
            )
                .font(.system(size: 20))
            Label(self.viewModel.nameString(), systemImage: "person")
                .font(.system(size: 20))
            Label(self.viewModel.countString(),
                systemImage: "digitalcrown.arrow.counterclockwise"
            )
                .font(.system(size: 20))
                .onChange(of: self.viewModel.counterModel.count) { oldValue, newValue in
                    print("Count changed from \(oldValue) to \(newValue)")
                    print("\(self.viewModel.counterModel.description)")
                    self.saveState()
                }
            HStack(alignment: .center) {
                Button(.decrementButtonTitle) {
                    self.viewModel.decrement()
                }
                .bold()
                Button(.incrementButtonTitle) {
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
            self.viewModel.updateDate()
            try self.modelContext.save()
            print("Saved the counter state")
        } catch {
            print("Error saving counter: \(error)")
        }
    }
}

#Preview {
    let counterTitle = String(localized: "counterTitle")
    CounterDetailView(
        viewModel: CounterViewModel(counterModel: CounterModel(
            name: "\(counterTitle)0")
        )
    )
}

import Playgrounds

#Playground {
    let counterTitle = String(localized: "counterTitle")
    let counterModel = CounterModel(
        name: String(format: "\(counterTitle)0")
    )
    print(counterModel.description)
}
