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
        NavigationStack(path: $path) {
            VStack {
                if self.counterModels.isEmpty {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                        .padding()
                    Text(.emptyViewMessage)
                        .font(.headline)
                        .padding()
                        .accessibilityIdentifier("emptyViewMessage")
                    Spacer()
                    Spacer()
                } else {
                    List {
                        ForEach(counterModels) { counterModel in
                            VStack {
                                CounterRowView(counterViewModel: CounterViewModel(
                                    counterModel: counterModel
                                ))
                            }
                        }
                        .onDelete(perform: self.deleteCounter)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        .addCounterButtonTitle,
                        systemImage: "plus",
                        action: self.addCounter
                    )
                    .accessibilityIdentifier("addCounterButton")
                }
                ToolbarItemGroup(placement: .bottomBar) {
                   Text("A.B.C (build: xyz)")
                       .font(.footnote)
                       .foregroundColor(.secondary)
                       .frame(maxWidth: .infinity)
                       .textSelection(.enabled)
                   }
            }
            .navigationTitle(.navigationTitle)
            .navigationDestination(isPresented: $showCounter) {
                if self.counterModels.isEmpty == false, let counterModel: CounterModel = self.counterModels.last {
                    CounterDetailView(
                        viewModel: CounterViewModel(
                            counterModel: counterModel)
                    )
                }
            }
        }
    }

    func addCounter() {
        let newCounter = CounterModel(
            name: CounterModel.nextName(existing: self.counterModels.map(\.name))
        )
        self.modelContext.insert(newCounter)
        self.path.append(newCounter)
        self.showCounter = true
    }

    func deleteCounter(_ indexSet: IndexSet) {
        CounterModel.delete(at: indexSet, from: self.counterModels, in: self.modelContext)
    }
}

#Preview {
    ContentView()
        .modelContainer(
            CounterContainer.createContainer()
        )
}
