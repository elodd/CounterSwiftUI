//
//  CounterView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

struct CounterView: View {
    @Bindable var viewModel: CounterViewModel

    var body: some View {
        VStack {
            InnerView(vm: viewModel)
        }
    }
}

#Preview {
    @Previewable
    @State var viewModel: CounterViewModel = .init()
    CounterView(viewModel: viewModel)
}
