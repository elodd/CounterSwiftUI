//
//  CounterViewModel.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI
import SwiftData

@Observable
class CounterViewModel {
    var counterModel: CounterModel

    init(counter: CounterModel) {
        self.counterModel = counter
    }

    func increment() {
        self.counterModel.count += 1
    }
    
    func decrement() {
        self.counterModel.count -= 1
    }
}
