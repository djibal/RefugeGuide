//
//  KeychainHelper.swift
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


enum KeychainHelper {
    static let keyTag = "com.refugeguide.encryptionKey"

    static func saveKeyToKeychain(_ keyData: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyTag,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        // Remove existing key before saving new one
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    static func loadKeyFromKeychain() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyTag,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess {
            return result as? Data
        } else {
            print("❌ Keychain load error: \(status)")
            return nil
        }
    }
}
