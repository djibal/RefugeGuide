//
//  AsylumGuideView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions

struct AsylumGuideView: View {
    let selectedLanguage: String
    var onContinue: () -> Void
    
    // MARK: - UI Constants
     private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)  // Deep UK blue
     private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)   // UK accent orange
    
    var body: some View {
        GuideContentView(
            selectedLanguage: selectedLanguage,
            title: localizedString("Seeking Asylum?", for: selectedLanguage),
            subtitle: localizedString("Learn about the UK asylum process.", for: selectedLanguage),
            cards: guideCards,
            continueButtonText: localizedString("Register", for: selectedLanguage),
            onContinue: onContinue,
            primaryColor: primaryColor,
            accentColor: accentColor
        )
    }
    
    private var guideCards: [GuideCardData] {
            [
                GuideCardData(
                    title: localizedString("How to Apply", for: selectedLanguage),
                    description: localizedString("Step-by-step guide to the asylum application process", for: selectedLanguage),
                    icon: "doc.text.fill",
                    linkText: localizedString("Application Process", for: selectedLanguage),
                    linkURL: "https://www.gov.uk/claim-asylum"
                ),
                GuideCardData(
                    title: localizedString("Legal Support", for: selectedLanguage),
                    description: localizedString("Find free legal advice and representation", for: selectedLanguage),
                    icon: "person.2.fill",
                    linkText: localizedString("Find Help", for: selectedLanguage),
                    linkURL: "https://www.refugeecouncil.org.uk"
                ),
                GuideCardData(
                    title: localizedString("Accommodation", for: selectedLanguage),
                    description: localizedString("Housing support during your application", for: selectedLanguage),
                    icon: "house.fill",
                    linkText: localizedString("Housing Support", for: selectedLanguage),
                    linkURL: "https://www.gov.uk/asylum-support"
                )
            ]
        }
        
    private func localizedString(_ key: String, for language: String) -> String {
        let translations: [String: [String: String]] = [
            "Seeking Asylum?": [
                "ar": "طلب اللجوء؟",
                "fr": "Demande d'asile?",
                "fa": "درخواست پناهندگی؟",
                "ku": "داوای پەنابەری؟",
                "ps": "د پناه غوښتنه؟",
                "uk": "Шукаєте притулку?",
                "ur": "پناہ مانگ رہے ہیں؟"
            ],
            "Learn about the UK asylum process.": [
                "ar": "تعرف على عملية اللجوء في المملكة المتحدة.",
                "fr": "Découvrez le processus d'asile au Royaume-Uni.",
                "fa": "درباره روند پناهندگی در بریتانیا بیاموزید.",
                "ku": "زانیاری لەسەر پرۆسەی پەنابەری لە شانشینی یەکگرتوو.",
                "ps": "د انګلستان د پناه غوښتنې پروسه زده کړئ.",
                "uk": "Дізнайтеся про процес надання притулку у Великій Британії.",
                "ur": "برطانیہ میں پناہ کے عمل کے بارے میں جانیں۔"
            ],
            "How to Apply": [
                "ar": "كيفية التقديم",
                "fr": "Comment postuler",
                "fa": "نحوه درخواست",
                "ku": "چۆن داوا بکەیت",
                "ps": "څنګه غوښتنه وکړئ",
                "uk": "Як подати заяву",
                "ur": "درخواست کیسے دیں"
            ],
            // Add other translations here following the same pattern
            "Register": [
                "ar": "سجل",
                "fr": "S'inscrire",
                "fa": "ثبت نام",
                "ku": "خۆت تۆمار بکە",
                "ps": "نوم لیکنه",
                "uk": "Зареєструватися",
                "ur": "رجسٹر کریں"
            ]
        ]
        
        return translations[key]?[language] ?? key
    }
}

