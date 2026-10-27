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
        print (id)
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
    static let deepLinkScheme = "counterswiftui"
    static let deepLinkHost = "counter"

    /// The `counterswiftui://counter/<id>` URL that opens this counter.
    static func deepLinkURL(id: String) -> URL {
        var components = URLComponents()
        components.scheme = deepLinkScheme
        components.host = deepLinkHost
        components.path = "/\(id)"
        // Scheme, host and an absolute path always form a valid URL.
        return components.url!
    }

    /// Returns the counter id or name from a `counterswiftui://counter/<id or name>` URL.
    static func reference(fromDeepLink url: URL) -> String? {
        guard url.scheme == deepLinkScheme,
              url.host() == deepLinkHost,
              url.pathComponents.count == 2 else {
            return nil
        }
        return url.pathComponents[1]
    }

    /// Returns the optional `?date=` of a deep link, as `yyyy-MM-dd` or `yyyy-MM-ddTHH:mm` in local time.
    static func date(fromDeepLink url: URL) -> Date? {
        guard let value = URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?.first(where: { $0.name == "date" })?.value else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        for format in ["yyyy-MM-dd'T'HH:mm", "yyyy-MM-dd"] {
            formatter.dateFormat = format
            if let date = formatter.date(from: value) {
                return date
            }
        }
        return nil
    }

    /// The counter a deep link refers to: an id match, otherwise the counter with that name,
    /// choosing the one last updated closest to `date` when names repeat.
    static func match(_ reference: String, near date: Date?, in counters: [CounterModel]) -> CounterModel? {
        if let counterModel = counters.first(where: { $0.id == reference }) {
            return counterModel
        }
        let named = counters.filter { $0.name == reference }
        guard let date else {
            return named.first
        }
        return named.min { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) }
    }

    static var defaults: [CounterModel] {
        let counterTitle = String(localized: "counterTitle")
        return (0..<3).map { CounterModel(name: "\(counterTitle) \($0)", count: $0) }
    }

    /// Returns the lowest-numbered default name not already taken.
    static func nextName(existing names: [String]) -> String {
        let counterTitle = String(localized: "counterTitle")
        let taken = Set(names)
        let index = (0...).first { !taken.contains("\(counterTitle) \($0)") }!
        return "\(counterTitle) \(index)"
    }

    static func delete(at offsets: IndexSet, from counters: [CounterModel], in context: ModelContext) {
        for index in offsets {
            context.delete(counters[index])
        }
    }
}
