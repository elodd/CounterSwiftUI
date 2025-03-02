//
//  CounterView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

struct CounterView: View {
    @Bindable var viewModel: CounterViewModel
    @Environment(\.modelContext) var modelContext

    init(viewModel: CounterViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            InnerView(viewModel: viewModel)
        }.onAppear() {
            self.addCounter()
        }
    }

    func addCounter() {
        do {
            self.modelContext.insert(self.viewModel.counter)
            try self.modelContext.save()
        } catch {
            print("Error saving counter: \(error)")
        }
    }

}

#Preview {
    @Previewable
    @State var viewModel: CounterViewModel = .init(counter: Counter(name: "Counter1"))
    CounterView(viewModel: viewModel)
}
