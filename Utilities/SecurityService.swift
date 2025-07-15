//
//  SecurityService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/08/2025.
//


import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore
import Security
import CryptoKit

struct SecurityService {
    private static func loadKey() -> SymmetricKey? {
        guard let data = KeychainHelper.loadKeyFromKeychain() else { return nil }
        return SymmetricKey(data: data)
    }

    static func encrypt(_ text: String) -> String? {
        guard let key = loadKey(),
              let inputData = text.data(using: .utf8) else { return nil }

        do {
            let sealedBox = try AES.GCM.seal(inputData, using: key)
            return sealedBox.combined?.base64EncodedString()
        } catch {
            print("Encryption failed: \(error)")
            return nil
        }
    }

    static func decrypt(_ base64: String) -> String? {
        guard let key = loadKey(),
              let data = Data(base64Encoded: base64) else { return nil }

        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decrypted = try AES.GCM.open(sealedBox, using: key)
            return String(data: decrypted, encoding: .utf8)
        } catch {
            print("Decryption failed: \(error)")
            return nil
        }
    }
}
