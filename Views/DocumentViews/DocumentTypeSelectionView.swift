//
//  DocumentTypeSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct DocumentTypeSelectionView: View {
    @ObservedObject var vm: DocumentAIViewModel
    @Binding var showPicker: Bool
    @Binding var showCamera: Bool
    @State private var showSourceSelection = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Select Document Type")
                .font(.title2)

            VStack(spacing: 20) {
                ForEach(UKDocumentType.allCases) { type in
                    Button(action: {
                        vm.selectedType = type
                        showSourceSelection = true
                    }) {
                        HStack {
                            Image(systemName: type.iconName)
                                .font(.title)
                                .frame(width: 40)
                            Text(type.rawValue)
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
            }
            .actionSheet(isPresented: $showSourceSelection) {
                ActionSheet(
                    title: Text("Select Source"),
                    buttons: [
                        .default(Text("Take Photo")) { showCamera = true },
                        .default(Text("Choose from Library")) { showPicker = true },
                        .cancel()
                    ]
                )
            }

            UKLegalNotice(text: "AI analysis is not a substitute for legal advice. Please consult a professional.")
        }
        .padding()
    }
}
