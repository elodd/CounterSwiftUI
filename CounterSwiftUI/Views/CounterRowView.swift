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
            Text("\(counterViewModel.nameString())\n" +
                 "\(counterViewModel.countString())\n" +
                 "\(counterViewModel.dateString())")
                .font(.system(size: 20))
                .multilineTextAlignment(.leading)
        })
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
