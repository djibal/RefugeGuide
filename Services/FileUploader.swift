//
//  FileUploader.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

import Foundation
import FirebaseStorage

class FileUploader {
    static let shared = FileUploader()
    
    private init() {}
    
    func uploadFile(
        url: URL,
        completion: @escaping (Result<(URL, String), Error>) -> Void
    ) {
        let fileName = url.lastPathComponent
        let ref = Storage.storage().reference().child("uploads/\(fileName)")

        do {
            let fileData = try Data(contentsOf: url)
            let contentType = url.pathExtension.lowercased().mimeType()

            let metadata = StorageMetadata()
            metadata.contentType = contentType

            ref.putData(fileData, metadata: metadata) { _, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    ref.downloadURL { downloadURL, error in
                        if let downloadURL = downloadURL {
                            completion(.success((downloadURL, contentType)))
                        } else {
                            completion(.failure(error ?? NSError()))
                        }
                    }
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: - Helper
extension String {
    func mimeType() -> String {
        switch self {
        case "pdf": return "application/pdf"
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "doc": return "application/msword"
        case "docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        default: return "application/octet-stream"
        }
    }
}
