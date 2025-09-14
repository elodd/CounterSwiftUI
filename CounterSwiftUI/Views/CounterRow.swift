//
//  CounterRow.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-03-02.
//

import SwiftUI

struct CounterRow: View {
    @Bindable var counterViewModel: CounterViewModel

    var body: some View {
        NavigationLink(destination: {
            CounterInnerView(viewModel: self.counterViewModel)

        }, label: {
            Text("\(counterViewModel.nameString())\n" +
                 "\(counterViewModel.countString())\n" +
                 "\(counterViewModel.dateString())")
                .font(.system(size: 20))
                .multilineTextAlignment(.leading)
        })
    }
}

#Preview {
    let counterName = String(localized: "counterTitle")
    CounterRow(
        counterViewModel: CounterViewModel(counterModel: CounterModel(
            name: "\(counterName)0")
        )
    )
}
