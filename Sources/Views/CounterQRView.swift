//
//  CounterQRView.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2026-10-27.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

enum QRCode {
    private static let context = CIContext()

    /// A black-on-white QR code for `text`, one pixel per module; scale it up with `.interpolation(.none)`.
    static func image(for text: String) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(text.utf8)
        filter.correctionLevel = "M"
        guard let output = filter.outputImage,
              let cgImage = self.context.createCGImage(output, from: output.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    /// The QR code for a counter's deep link.
    static func image(for counterModel: CounterModel) -> UIImage? {
        self.image(for: CounterModel.deepLinkURL(id: counterModel.id).absoluteString)
    }
}

/// A counter's QR code, crisp at any size, on a white quiet zone so it scans in dark mode.
struct QRCodeImage: View {
    let counterModel: CounterModel
    var padding: CGFloat = 8
    var cornerRadius: CGFloat = 12

    var body: some View {
        if let image = QRCode.image(for: self.counterModel) {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .padding(self.padding)
                .background(Color.white, in: RoundedRectangle(cornerRadius: self.cornerRadius, style: .continuous))
        }
    }
}

/// One counter's deep link as a large, shareable QR code.
struct CounterQRView: View {
    let counterModel: CounterModel
    @Environment(\.dismiss) private var dismiss

    private var url: URL { CounterModel.deepLinkURL(id: self.counterModel.id) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                QRCodeImage(counterModel: self.counterModel, padding: 16, cornerRadius: 20)
                    .frame(maxWidth: 280)
                    .accessibilityIdentifier("counterQR.\(self.counterModel.id)")
                ShareLink(item: self.url) {
                    Label(.shareButtonTitle, systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle(self.counterModel.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(.doneButtonTitle) { self.dismiss() }
                        .accessibilityIdentifier("qrDoneButton")
                }
            }
        }
    }
}

#Preview {
    let counterTitle = String(localized: "counterTitle")
    CounterQRView(counterModel: CounterModel(name: "\(counterTitle) 0"))
}
