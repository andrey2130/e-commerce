//
//  PaymentSheetView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 08.02.2026.
//

import SwiftUI

struct PaymentSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = PaymentViewModel()
    @State private var shippingAddress: String = ""

    var body: some View {
        VStack(spacing: 20) {

            // Handle bar
            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Checkout")
                .font(.title3)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 8) {
                Text("Shipping address")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Enter your address", text: $shippingAddress)
                    .textFieldStyle(.roundedBorder)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Spacer()

            Button {
                Task {
                    await viewModel.processCheckout(
                        shippingAddress: shippingAddress
                    )
                }
            } label: {
                HStack {
                    if viewModel.isProcessing {
                        ProgressView()
                    } else {
                        Text("Pay with Apple Pay")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                shippingAddress.isEmpty || viewModel.isProcessing
            )
        }
        .padding()
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
        .onChange(of: viewModel.orderCompleted) { _, completed in
            if completed {
                dismiss()
            }
        }
    }
}
