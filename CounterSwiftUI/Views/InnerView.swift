//
//  InnerView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

struct InnerView: View {
    @Bindable var vm: CounterViewModel

    var body: some View {
        VStack {
            HStack {
                Button("Add") {
                    self.vm.increment()
                }
                Text("\(self.vm.count)")
                Button("Delete") {
                    self.vm.decrement()
                }

            }
        }
        .frame(width: 200, height: 100)
        .background(Color.init(red: 0.0, green: 0.0, blue: 1.0).opacity(0.2))
    }
}
