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

    private var versionString: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "-"
        let build = info?["CFBundleVersion"] as? String ?? "-"
        return "\(version) (build: \(build))"
    }

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
                            CounterRowView(counterViewModel: CounterViewModel(
                                counterModel: counterModel
                            ))
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
                    Text(versionString)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .textSelection(.enabled)
                }
            }
            .navigationTitle(.navigationTitle)
            .navigationDestination(for: CounterModel.self) { counterModel in
                CounterDetailView(
                    viewModel: CounterViewModel(counterModel: counterModel)
                )
            }
        }
    }

    func addCounter() {
        let newCounter = CounterModel(
            name: CounterModel.nextName(existing: self.counterModels.map(\.name))
        )
        self.modelContext.insert(newCounter)
        self.path.append(newCounter)
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
