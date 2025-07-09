//
//  UploadedDocument.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import Foundation
import FirebaseFirestoreSwift

struct UploadedDocument: Identifiable, Codable {
    @DocumentID var id: String?
    let filename: String
    let uploadDate: Date
    let storagePath: String
}
