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
        "\(self.count)"
    }

    func dateString() -> String {
        "Date:\(self.date.formatted(date: .numeric, time: .shortened))"
    }
}
