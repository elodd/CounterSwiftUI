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
            CounterInnerView(viewModel: viewModel)
        }
    }
}

#Preview {
    @Previewable
    @State var viewModel: CounterViewModel = .init(
        counterModel: CounterModel(
            name: String(format: "\(String(localized: "counterTitle"))1"),
            count: 1
        )
                                    
    )
    CounterView(viewModel: viewModel)
}
