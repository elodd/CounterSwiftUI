//
//  Mocks.swift
//  Tests
//
//  Created by eloddobos on 2026-10-28.
//

import SwiftMocks
@testable import CounterSwiftUI

// `@Mock` must sit on the protocol it mocks. To keep SwiftMocks out of the app, each app
// protocol is mirrored here and the generated mock conforms to the app protocol too.

@Mock
protocol KeyValueStoreDouble {
    func bool(forKey key: String) -> Bool
    func set(_ value: Bool, forKey key: String)
}

extension KeyValueStoreDoubleMock: KeyValueStore {}

@Mock
protocol ContextSaverDouble {
    func save() throws
}

extension ContextSaverDoubleMock: ContextSaver {}
