//
//  ProcessingView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct ProcessingView: View {
    let progress: Double

    var body: some View {
        VStack(spacing: 20) {
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(width: 200)

            Text("Analyzing Document...")
                .font(.headline)

            Text("\(Int(progress * 100))% complete")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
