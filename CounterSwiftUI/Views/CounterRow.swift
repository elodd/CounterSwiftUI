//
//  CounterRow.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-03-02.
//

import SwiftUI

struct CounterRow: View {
    @Bindable var counter: CounterModel

    var body: some View {
        NavigationLink("Name:\(counter.name) Count:\(counter.countString()) Date:\(counter.date.formatted(date: .abbreviated, time: .shortened))", destination: CounterInnerView(viewModel: CounterViewModel(counter: self.counter)))
    }
}

#Preview {
    CounterRow(counter: CounterModel(name: "Counter1", count: 0, date: Date()))
}
