//
//  UKLegalNotice.swift
//  RefugeGuide
//
////  Created by Djibal Ramazani on 30/06/2025.

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct UKLegalNotice: View {
        let text: String
    
        var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}


struct LegalNotice: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.vertical, 8)
    }
}
