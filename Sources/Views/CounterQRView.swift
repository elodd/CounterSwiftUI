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

    /// Generated once per counter id, not on every redraw.
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = self.image {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.clear.aspectRatio(1, contentMode: .fit)
            }
        }
        .padding(self.padding)
        .background(Color.white, in: RoundedRectangle(cornerRadius: self.cornerRadius, style: .continuous))
        .task(id: self.counterModel.id) {
            self.image = QRCode.image(for: self.counterModel)
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
