//
//  CounterViewModel.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

@Observable
class CounterViewModel {
    var counterModel: CounterModel

    init(counterModel: CounterModel) {
        self.counterModel = counterModel
    }

    func increment() {
        self.counterModel.count += 1
    }

    func decrement() {
        self.counterModel.count -= 1
    }

    func updateDate() {
        self.counterModel.date = Date()
    }
}
