//
//  Counter.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-03-02.
//

import Foundation
import SwiftData

@Model
class Counter: Identifiable {
    var date: Date
    var name: String
    var count: Int
    
    init(name: String, count: Int = 0, date: Date = Date()) {
        self.name = name
        self.count = count
        self.date = date
    }
    
    func countString() -> String {
        return "\(count)"
    }
}
