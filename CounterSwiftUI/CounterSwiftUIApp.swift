//
//  CounterSwiftUIApp.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

@main
struct CounterSwiftUIApp: App {
    @State private var viewModel: CounterViewModel = .init()

    var body: some Scene {
        WindowGroup {
            CounterView(viewModel: viewModel)
        }
    }
}
