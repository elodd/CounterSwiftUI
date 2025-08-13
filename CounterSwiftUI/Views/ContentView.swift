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
    @Query(sort: \CounterModel.name) var counterModels: [CounterModel]
    @State private var path = NavigationPath()

    @State private var showCounter: Bool = false

    public var body: some View {
        NavigationStack {
            VStack {
                if self.counterModels.isEmpty {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                        .padding()
                    Text(StaticStrings.emptyViewMessage)
                        .font(.headline)
                        .padding()
                    Spacer()
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
                    Button(
                        StaticStrings.addCounterButtonTitle,
                        systemImage: "plus",
                        action: self.addCounter
                    )
                }
                ToolbarItemGroup(placement: .bottomBar) {
                   Text("A.B.C (xyz)")
                       .font(.footnote)
                       .foregroundColor(.secondary)
                       .frame(maxWidth: .infinity)
                       .textSelection(.enabled)
                   }
            }
            .navigationTitle(StaticStrings.navigationTitle)
            .navigationDestination(isPresented: $showCounter) {
                if self.counterModels.isEmpty == false, let counterModel: CounterModel = self.counterModels.last {
                    CounterView(
                        viewModel: CounterViewModel(
                            counterModel: counterModel)
                    )
                }
            }
        }
    }

    func addCounter() {
        let newCounter = CounterModel(
            name: "\(StaticStrings.counterTitle)\(self.counterModels.count)"
        )
        self.modelContext.insert(newCounter)
        self.path.append(newCounter)
        self.showCounter = true
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
        .modelContainer(
            CounterContainer.createContainer()
        )
}
