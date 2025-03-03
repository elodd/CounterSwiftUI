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
    var counter: CounterModel

    init(counter: CounterModel) {
        self.counter = counter
    }

    func increment() {
        self.counter.count += 1
    }
    
    func decrement() {
        self.counter.count -= 1
    }
}
