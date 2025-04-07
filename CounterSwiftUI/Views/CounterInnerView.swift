//
//  CounterInnerView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

struct CounterInnerView: View {
    @Bindable var viewModel: CounterViewModel
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack(alignment: .center) {
            Label("Date:\(self.viewModel.counterModel.date.formatted(date: .abbreviated, time: .shortened))", systemImage: "calendar")
                .dynamicTypeSize(.small)
                .padding()
            Label(viewModel.counterModel.name, systemImage: "person")
                .padding()
            Text("\(self.viewModel.counterModel.count)")
                .onChange(of: self.viewModel.counterModel.count) { oldValue, newValue in
                    print("Count changed from \(oldValue) to \(newValue)")
                }
            HStack {
                Button("Decrement") {
                    self.viewModel.decrement()
                }
                .font(.custom("Courier New", size: 12))
                .bold()
                .fixedSize(horizontal: true, vertical: false)
                .padding()
                Button("Increment") {
                    self.viewModel.increment()
                }
                .font(.custom("Courier New", size: 12))
                .bold()
                .fixedSize(horizontal: true, vertical: false)
                .padding()
            }
        }
        .frame(width: 300, height: 250)
        .background(Color.init(red: 0.0, green: 0.0, blue: 1.0).opacity(0.2))
        .onDisappear() {
            self.saveState()
        }
    }
    
    func saveState() {
        do {
            self.modelContext.insert(self.viewModel.counterModel)
            try self.modelContext.save()
        } catch {
            print("Error saving counter: \(error)")
        }
    }
}
