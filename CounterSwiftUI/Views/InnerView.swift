//
//  InnerView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

struct InnerView: View {
    @Bindable var viewModel: CounterViewModel
    // TODO: add database-update closure

    var body: some View {
        VStack {
            HStack {
                Button("Add") {
                    self.viewModel.increment()
                }
                Text("\(self.viewModel.counter.count)")
                Button("Delete") {
                    self.viewModel.decrement()
                }
            }
        }
        .frame(width: 200, height: 100)
        .background(Color.init(red: 0.0, green: 0.0, blue: 1.0).opacity(0.2))
    }
}
