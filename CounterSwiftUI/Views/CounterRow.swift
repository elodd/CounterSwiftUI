//
//  CounterRow.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-03-02.
//

import SwiftUI

struct CounterRow: View {
    @Bindable var counter: Counter

    var body: some View {
        NavigationLink("\(counter.name) \(counter.countString()) \(counter.date.formatted(date: .abbreviated, time: .shortened))", destination: InnerView(viewModel: CounterViewModel(counter: self.counter)))
    }
}

#Preview {
    CounterRow(counter: Counter(name: "Counter1", count: 0, date: Date()))
}
