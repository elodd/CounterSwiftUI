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
        NavigationLink(destination: {
            CounterInnerView(viewModel: CounterViewModel(counterModel: self.counterModel))

        }, label: {
            Text("\(counterModel.nameString())\n\( counterModel.countString())\n\( counterModel.dateString())")
                .multilineTextAlignment(.leading)
        })
    }
}

#Preview {
    CounterRow(counterModel: CounterModel(name: "Counter1", count: 0, date: Date()))
}
