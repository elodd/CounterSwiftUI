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
    var id: String
    var date: Date
    var name: String
    var count: Int
    
    init(name: String, count: Int = 0, date: Date = Date()) {
        self.id = UUID().uuidString
        self.name = name
        self.count = count
        self.date = date
    }
    
    func countString() -> String {
        "\(String(localized: "countLabelTitle")) \(self.count)"
    }

    func nameString() -> String {
        "\(String(localized: "nameLabelTitle")) \(self.name)"
    }

    func dateString() -> String {
        let dateLabelTitle = String(localized: "dateLabelTitle")
        let dateFormat = self.date.formatted(date: .numeric, time: .shortened)
        return "\(dateLabelTitle) \(dateFormat)"
    }
}

extension CounterModel: CustomStringConvertible {
    var description: String {
        return "[[\(Self.self)] id: \(self.id), name: \(self.name), count: \(self.count), date: \(self.date)]"
    }
}

extension CounterModel {
    static var defaults: [CounterModel] {
        let counterKey = String(localized: "counterTitle")
        return [
            CounterModel(name: String(format: "\(counterKey)0"), count: 0),
            CounterModel(name: String(format: "\(counterKey)1"), count: 1),
            CounterModel(name: String(format: "\(counterKey)2"), count: 2)
        ]
    }
}
