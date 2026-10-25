//
//  CounterRowView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-03-02.
//

import SwiftUI

struct CounterRowView: View {
    @Bindable var counterViewModel: CounterViewModel

    var body: some View {
        NavigationLink(destination: {
            CounterDetailView(viewModel: self.counterViewModel)
        }, label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(counterViewModel.nameString())
                Text(counterViewModel.countString())
                Text(counterViewModel.dateString())
            }
            .font(.system(size: 20))
        })
        .accessibilityIdentifier("counterRow")
    }
}

#Preview {
    let counterTitle = String(localized: "counterTitle")
    CounterRowView(
        counterViewModel: CounterViewModel(counterModel: CounterModel(
            name: "\(counterTitle)0")
        )
    )
}
