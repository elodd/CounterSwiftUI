//
//  ContentView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-03-02.
//

import SwiftUI
import SwiftData

public struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \CounterModel.date) var counterModels: [CounterModel]
    @State var showCounter = false

    public var body: some View {
        NavigationStack {
            VStack {
                if self.counterModels.isEmpty {
                    Spacer()
                    Text("Add a new counter by tapping the plus (+) button.")
                        .font(.headline)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(counterModels, id: \.id) { counterModel in
                            VStack {
                                CounterRow(counterModel: counterModel)
                            }
                        }
                        .onDelete(perform: self.deleteCounter)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "plus")
                        .accentColor(.black)
                        .onTapGesture(perform: {
                            showCounter.toggle()
                        })
                }
            }
            .navigationTitle("Counters")
            .navigationDestination(isPresented: self.$showCounter) {
                CounterView(
                    viewModel: CounterViewModel(
                        counterModel: CounterModel(
                            name: "Counter\(self.counterModels.count + 1)"
                        )
                    )
                )
            }
        }
    }

    func deleteCounter(_ indexSet: IndexSet) {
        for index in indexSet {
            let counter = self.counterModels[index]
            self.modelContext.delete(counter)
        }
    }
}

#Preview {
    // TODO: Prefil SwiftData with data
    ContentView()
}
