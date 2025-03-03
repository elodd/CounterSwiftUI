//
//  CounterRow.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-03-02.
//

import SwiftUI

struct CounterRow: View {
    @Bindable var counterModel: CounterModel

    var body: some View {
        NavigationLink(
            "Name:\(counterModel.name)\n Count:\(counterModel.countString())\n Date:\(counterModel.date.formatted(date: .abbreviated, time: .shortened))",
            destination: CounterInnerView(
                viewModel: CounterViewModel(counterModel: self.counterModel)
            )
        )
    }
}

#Preview {
    CounterRow(counterModel: CounterModel(name: "Counter1", count: 0, date: Date()))
}
