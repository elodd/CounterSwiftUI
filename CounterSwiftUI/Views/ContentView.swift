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
                        ForEach(counterModels, id: \.self) { counterModel in
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
                CounterView(viewModel: CounterViewModel(counter: CounterModel(name: "Counter\(self.counterModels.count + 1)")))
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
    ContentView()
}
