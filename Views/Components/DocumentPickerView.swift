
// DocumentPickerView.swift//
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {


    var onDocumentPicked: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [.pdf, .image, .data],
            asCopy: true
        )
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
            guard let fileURL = urls.first else {
                print("❌ No file URL returned.")
                return
            }

            print("📂 File selected: \(fileURL)")

            if fileURL.startAccessingSecurityScopedResource() {
                print("🔐 Access granted to file")
                defer { fileURL.stopAccessingSecurityScopedResource() }

                // ✅ Check if file is locally readable
                if FileManager.default.isReadableFile(atPath: fileURL.path) {
                    parent.onDocumentPicked(fileURL)
                } else {
                    print("❌ File not locally downloaded or readable.")
                }
            } else {
                print("❌ Failed to access security-scoped resource")
            }
        }

    }
}

