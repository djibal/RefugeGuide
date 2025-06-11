//
//  FileUploader.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

// FileUploader.swift
import Foundation
import FirebaseStorage

class FileUploader {
    static let shared = FileUploader()
    
    private init() {}
    
    func uploadFile(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let fileName = url.lastPathComponent
        let ref = Storage.storage().reference().child("uploads/\(fileName)")
        
        do {
            let fileData = try Data(contentsOf: url)
            print("📦 Loaded file data: \(fileData.count) bytes")
            
            ref.putData(fileData, metadata: nil) { metadata, error in
                if let error = error {
                    print("❌ Upload failed: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    ref.downloadURL { url, error in
                        if let error = error {
                            print("❌ Failed to get download URL: \(error.localizedDescription)")
                            completion(.failure(error))
                        } else if let url = url {
                            print("✅ Download URL: \(url.absoluteString)")
                            completion(.success(url.absoluteString))
                        }
                    }
                }
            }
        } catch {
            print("❌ Failed to read file data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
