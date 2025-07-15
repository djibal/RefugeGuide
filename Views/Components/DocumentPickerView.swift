
// DocumentPickerView.swift//
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import UniformTypeIdentifiers
import SwiftUICore

struct DocumentPickerView: UIViewControllerRepresentable {
    var supportedTypes: [UTType] = [.pdf, .image, .text]
    var onDocumentPicked: (URL) -> Void
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    
    var onError: (Error) -> Void = { _ in }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerView
        
        init(parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.onError(URLError(.badURL))
                return
            }
            
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                
                if FileManager.default.isReadableFile(atPath: url.path) {
                    parent.onDocumentPicked(url)
                } else {
                    parent.onError(DocumentError.unreadableFile)
                }
            } else {
                parent.onError(DocumentError.accessDenied)
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onError(DocumentError.cancelled)
        }
    }
    
    enum DocumentError: Error {
        case unreadableFile, accessDenied, cancelled
        var localizedDescription: String {
            switch self {
            case .unreadableFile: return "File is not readable"
            case .accessDenied: return "Access to file denied"
            case .cancelled: return "Document selection cancelled"
            }
        }
    }
}
