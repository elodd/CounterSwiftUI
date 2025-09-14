//
//  Counter.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-03-02.
//

import Foundation
import SwiftData

@Model
class CounterModel: Identifiable {
    var id: String = UUID().uuidString
    var date: Date
    var name: String
    var count: Int
    
    init(name: String, count: Int = 0, date: Date = Date()) {
        self.name = name
        self.count = count
        self.date = date
    }
}

extension CounterModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension CounterModel: CustomStringConvertible {
    var description: String {
        return "[[CounterModel] id: \(self.id), name: \(self.name), count: \(self.count), date: \(self.date)]"
    }
}

extension CounterModel {
    static var defaults: [CounterModel] {
        let counterName = String(localized: "counterTitle")
        return [
            CounterModel(name: String(format: "\(counterName)0"), count: 0),
            CounterModel(name: String(format: "\(counterName)1"), count: 1),
            CounterModel(name: String(format: "\(counterName)2"), count: 2)
        ]
    }
}
