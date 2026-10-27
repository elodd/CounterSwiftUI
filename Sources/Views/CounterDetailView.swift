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
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var isShowingQRCode = false

    private var count: Int { self.viewModel.counterModel.count }

    /// iPhone landscape: too short to stack everything, so the count sits beside the controls.
    private var isCompactHeight: Bool { self.verticalSizeClass == .compact }

    var body: some View {
        Group {
            if self.isCompactHeight {
                VStack(spacing: 16) {
                    HStack(spacing: 32) {
                        self.countDisplay
                        VStack(spacing: 20) {
                            self.controls
                            self.qrCode(size: 96)
                        }
                    }
                    self.lastUpdated
                }
            } else {
                VStack(spacing: 32) {
                    Spacer()
                    self.countDisplay
                    self.controls
                    Spacer()
                    self.qrCode(size: 120)
                    self.lastUpdated
                }
            }
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
        .sheet(isPresented: $isShowingQRCode) {
            CounterQRView(counterModel: self.viewModel.counterModel)
                .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Subviews

    private var countDisplay: some View {
        Text(self.count, format: .number)
            .font(.system(size: 120, weight: .bold, design: .rounded))
            .monospacedDigit()
            .contentTransition(.numericText(value: Double(self.count)))
            .animation(.snappy, value: self.count)
            .foregroundStyle(self.count < 0 ? Color.red : Color.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .frame(maxWidth: .infinity, maxHeight: self.isCompactHeight ? .infinity : nil)
            .padding(.vertical, 32)
            .background(
                Color(.secondarySystemGroupedBackground),
                in: RoundedRectangle(cornerRadius: 28, style: .continuous)
            )
            .accessibilityLabel(self.viewModel.countString())
            .accessibilityIdentifier("countDisplay")
    }

    private var controls: some View {
        HStack(spacing: 40) {
            self.stepButton(
                systemImage: "minus",
                label: .decrementButtonTitle,
                identifier: "decrementButton",
                tint: .secondary
            ) {
                await self.viewModel.decrement()
            }
            self.stepButton(
                systemImage: "plus",
                label: .incrementButtonTitle,
                identifier: "incrementButton",
                tint: .accentColor
            ) {
                await self.viewModel.increment()
            }
        }
    }

    /// The counter's deep link; tap to enlarge and share.
    private func qrCode(size: CGFloat) -> some View {
        Button {
            self.isShowingQRCode = true
        } label: {
            QRCodeImage(counterModel: self.viewModel.counterModel)
                .frame(width: size, height: size)
                .padding(12)
                .background(
                    Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(.qrCodeButtonTitle))
        .accessibilityIdentifier("qrCodeButton")
    }

    private var lastUpdated: some View {
        Label(self.viewModel.dateString(), systemImage: "clock")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }

    private func stepButton(
        systemImage: String,
        label: LocalizedStringResource,
        identifier: String,
        tint: Color,
        action: @escaping @MainActor () async -> Void
    ) -> some View {
        Button {
            Task { await action() }
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: 32, weight: .semibold))
                .frame(width: 72, height: 72)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.circle)
        .tint(tint)
        .accessibilityLabel(Text(label))
        .accessibilityIdentifier(identifier)
    }

    // MARK: - Persistence

    func saveState() {
        do {
            try self.viewModel.save(in: self.modelContext)
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
                name: "\(counterTitle) 0")
            )
        )
    }
    .modelContainer(for: CounterModel.self, inMemory: true)
}

import Playgrounds

#Playground {
    let counterTitle = String(localized: "counterTitle")
    let counterModel = CounterModel(
        name: String(format: "\(counterTitle) 0")
    )
    print(counterModel.description)
}
