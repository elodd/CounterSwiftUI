//
//  ContentView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-03-02.
//

//
//  VoiceListView.swift
//  MindfulVoice
//
//  Created by eloddobos on 2024-11-14.
//

import Foundation
import SwiftUI
import SwiftData

public struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Query(sort: \CounterModel.date) var counters: [CounterModel]
    @State var showCounter = false

    public var body: some View {
        NavigationStack {
            VStack {
                if self.counters.isEmpty {
                    Spacer()
                    Text("No counters yet.")
                        .font(.headline)
                    Spacer()
                } else {
                    List {
                        ForEach(counters, id: \.self) { counter in
                            VStack {
                                CounterRow(counter: counter)
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
                CounterView(viewModel: CounterViewModel(counter: CounterModel(name: "Counter\(self.counters.count + 1)")))
            }
        }
    }

    func deleteCounter(_ indexSet: IndexSet) {
        for index in indexSet {
            let counter = self.counters[index]
            self.modelContext.delete(counter)
        }
    }
}

#Preview {
    ContentView()
}
