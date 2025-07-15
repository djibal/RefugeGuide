//
//  FileUploader.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseStorage

class FileUploader {
    static let shared = FileUploader()
    private let storage = Storage.storage()
    private let maxFileSize: Int64 = 10 * 1024 * 1024 // 10MB
    
    func uploadFile(
        url: URL,
        progressHandler: @escaping (Double) -> Void,
        completion: @escaping (Result<(URL, String), Error>) -> Void
    ) {
        // Validate file size
        guard let fileSize = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize,
              fileSize <= maxFileSize else {
            completion(.failure(FileError.fileTooLarge))
            return
        }
        
        let fileName = "\(UUID().uuidString).\(url.pathExtension)"
        let ref = storage.reference().child("user_documents/\(fileName)")
        let contentType = url.pathExtension.lowercased().mimeType()
        
        let metadata = StorageMetadata()
        metadata.contentType = contentType
        
        // Start upload task
        let uploadTask = ref.putFile(from: url, metadata: metadata)
        
        // Progress tracking
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
            progressHandler(percentComplete)
        }
        
        // Completion handler
        uploadTask.observe(.success) { _ in
            ref.downloadURL { url, error in
                if let url = url {
                    completion(.success((url, contentType)))
                } else {
                    completion(.failure(error ?? FileError.unknown))
                }
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                completion(.failure(error))
            } else {
                completion(.failure(FileError.unknown))
            }
        }
    }
}

extension String {
    func mimeType() -> String {
        switch self.lowercased() {
        case "pdf": return "application/pdf"
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "doc": return "application/msword"
        case "docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "txt": return "text/plain"
        case "heic": return "image/heic"
        default: return "application/octet-stream"
        }
    }
}

enum FileError: Error {
    case fileTooLarge, unsupportedType, unknown
    
    var localizedDescription: String {
        switch self {
        case .fileTooLarge: return "File size exceeds 10MB limit"
        case .unsupportedType: return "Unsupported file type"
        case .unknown: return "Unknown upload error"
        }
    }
}
