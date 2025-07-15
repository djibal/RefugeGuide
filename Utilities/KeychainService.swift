//
//  KeychainService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/08/2025.
//

import Foundation
import CryptoKit
import Security

final class KeychainService {
    static let shared = KeychainService()
    private let keyTag = "com.refugeguide.encryptionKey"

    private init() {}

    /// Generate and store a secure 256-bit AES key
    func generateKeyIfNeeded() {
        if loadKey() != nil {
            return // Key already exists
        }

        let keyData = SymmetricKey(size: .bits256).withUnsafeBytes { Data($0) }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyTag,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            print("🔐 Keychain error: Unable to store encryption key.")
        }
    }

    /// Load stored key from Keychain
    func loadKey() -> SymmetricKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let keyData = result as? Data else {
            return nil
        }

        return SymmetricKey(data: keyData)
    }

    /// Delete the key (optional, for reset/debug)
    func deleteKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag
        ]

        SecItemDelete(query as CFDictionary)
    }
}
