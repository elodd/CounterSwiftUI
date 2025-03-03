//
//  CounterView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI
import SwiftData

struct CounterView: View {
    @Bindable var viewModel: CounterViewModel
    @Environment(\.modelContext) var modelContext

    init(viewModel: CounterViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            CounterInnerView(viewModel: viewModel)
        }
    }
}

#Preview {
    @Previewable
    @State var viewModel: CounterViewModel = .init(
        counterModel: CounterModel(name: "Counter1")
    )
    CounterView(viewModel: viewModel)
}
