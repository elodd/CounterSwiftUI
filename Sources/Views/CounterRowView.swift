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
        // Value-based, so the push is recorded in ContentView's navigation path.
        NavigationLink(value: self.counterViewModel.counterModel, label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(counterViewModel.nameString())
                Text(counterViewModel.countString())
                Text(counterViewModel.dateString())
            }
            .font(.system(size: 20))
        })
        .accessibilityIdentifier("counterRow.\(counterViewModel.counterModel.id)")
    }
}

#Preview {
    let counterTitle = String(localized: "counterTitle")
    NavigationStack {
        List {
            CounterRowView(
                counterViewModel: CounterViewModel(counterModel: CounterModel(
                    name: "\(counterTitle) 0")
                )
            )
        }
    }
}
