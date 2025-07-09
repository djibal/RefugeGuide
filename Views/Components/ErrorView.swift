//
//  ErrorView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text("Processing Error")
                .font(.title2)

            Text(message)
                .multilineTextAlignment(.center)
                .padding()

            Button("Try Again", action: onRetry)
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
    }
}
