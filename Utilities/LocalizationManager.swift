//
//  LocalizationManager.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import Foundation

func localizedString(_ defaultValue: String, translations: [String: String]) -> String {
    let languageCode = Locale.current.languageCode ?? "en"
    return translations[languageCode] ?? defaultValue
}


func localizedManual(_ defaultText: String, translations: [String: String]) -> String {
    let lang = Locale.current.languageCode ?? "en"
    return translations[lang] ?? defaultText
}
