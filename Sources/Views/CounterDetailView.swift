//
//  CounterDetailView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI
import SwiftData

struct CounterDetailView: View {
    @Bindable var viewModel: CounterViewModel
    @Environment(\.modelContext) var modelContext

    private var count: Int { self.viewModel.counterModel.count }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            self.countDisplay
            self.controls
            Spacer()
            self.lastUpdated
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(self.viewModel.name)
        .navigationBarTitleDisplayMode(.large)
        .sensoryFeedback(.selection, trigger: self.count)
        .onChange(of: self.count) { _, _ in
            self.saveState()
        }
    }

    // MARK: - Subviews

    private var countDisplay: some View {
        Text(self.count, format: .number)
            .font(.system(size: 120, weight: .bold, design: .rounded))
            .monospacedDigit()
            .contentTransition(.numericText(value: Double(self.count)))
            .foregroundStyle(self.count < 0 ? Color.red : Color.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(
                Color(.secondarySystemGroupedBackground),
                in: RoundedRectangle(cornerRadius: 28, style: .continuous)
            )
            .accessibilityLabel(self.viewModel.countString())
    }

    private var controls: some View {
        HStack(spacing: 40) {
            self.stepButton(
                systemImage: "minus",
                label: .decrementButtonTitle,
                tint: .secondary
            ) {
                self.viewModel.decrement()
            }
            self.stepButton(
                systemImage: "plus",
                label: .incrementButtonTitle,
                tint: .accentColor
            ) {
                self.viewModel.increment()
            }
        }
    }

    private var lastUpdated: some View {
        Label(self.viewModel.dateString(), systemImage: "clock")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }

    private func stepButton(
        systemImage: String,
        label: LocalizedStringResource,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            withAnimation(.snappy) { action() }
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: 32, weight: .semibold))
                .frame(width: 72, height: 72)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.circle)
        .tint(tint)
        .accessibilityLabel(Text(label))
    }

    // MARK: - Persistence

    func saveState() {
        do {
            self.viewModel.updateDate()
            try self.modelContext.save()
        } catch {
            print("Error saving counter: \(error)")
        }
    }
}

#Preview {
    let counterTitle = String(localized: "counterTitle")
    NavigationStack {
        CounterDetailView(
            viewModel: CounterViewModel(counterModel: CounterModel(
                name: "\(counterTitle)0")
            )
        )
    }
    .modelContainer(for: CounterModel.self, inMemory: true)
}

import Playgrounds

#Playground {
    let counterTitle = String(localized: "counterTitle")
    let counterModel = CounterModel(
        name: String(format: "\(counterTitle)0")
    )
    print(counterModel.description)
}
