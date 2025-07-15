//
//  LocalizationManager.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

func NSlocalizedString(_ defaultValue: String, translations: [String: String]) -> String {
    let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
    return translations[languageCode] ?? defaultValue
}


func localizedManual(_ defaultText: String, translations: [String: String]) -> String {
    let lang = Locale.current.language.languageCode?.identifier ?? "en"
    return translations[lang] ?? defaultText
}
