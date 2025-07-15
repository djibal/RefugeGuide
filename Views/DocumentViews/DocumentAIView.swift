//
//  DocumentAIview.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 21/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import Vision
import CoreML
import SwiftUICore


struct DocumentAIView: View {
    @StateObject private var vm = DocumentAIViewModel()
    @State private var showPicker = false
    @State private var showCamera = false
    @State private var inputImage: UIImage?
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        NavigationView {
            VStack {
                switch vm.state {
                case .idle:
                    DocumentTypeSelectionView(vm: vm, showPicker: $showPicker, showCamera: $showCamera)

                case .processing:
                    ProcessingView(progress: vm.progress)

                case .result(let result):
                    DocumentResultView(result: result, onRetry: vm.reset)

                case .error(let message):
                    ErrorView(message: message, onRetry: vm.reset)
                }
            }
            .navigationTitle("Document AI")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Scan") {
                        vm.reset()
                    }
                }
            }
            .sheet(isPresented: $showPicker) {
                DocumentPickerView { url in
                    vm.processDocument(url: url)
                }
            }
            .sheet(isPresented: $showCamera, onDismiss: processImage) {
                ImagePickerView(image: $inputImage)
            }
        }
    }

    private func processImage() {
        guard let image = inputImage else { return }
        vm.processImage(image)
        inputImage = nil
    }
}
