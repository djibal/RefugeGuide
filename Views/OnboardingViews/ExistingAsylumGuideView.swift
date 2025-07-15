//
//  ExistingAsylumGuideView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct ExistingAsylumGuideView: View {
    let selectedLanguage: String
    var onContinue: () -> Void
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")
    
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    
    var body: some View {
        GuideContentView(
            selectedLanguage: selectedLanguage,
            title: localizedString("Existing Asylum Application", for: selectedLanguage),
            subtitle: localizedString("Support for current asylum seekers in the UK", for: selectedLanguage),
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
                title: localizedString("Application Status", for: selectedLanguage),
                description: localizedString("Check the status of your asylum application", for: selectedLanguage),
                icon: "clock.fill",
                linkText: localizedString("Check Status", for: selectedLanguage),
                linkURL: "https://www.gov.uk/asylum-process"
            ),
            GuideCardData(
                title: localizedString("Healthcare", for: selectedLanguage),
                description: localizedString("Access to NHS services and support", for: selectedLanguage),
                icon: "heart.fill",
                linkText: localizedString("Healthcare Info", for: selectedLanguage),
                linkURL: "https://www.redcross.org.uk"
            ),
            GuideCardData(
                title: localizedString("Education", for: selectedLanguage),
                description: localizedString("Access to education for you and your family", for: selectedLanguage),
                icon: "graduationcap.fill",
                linkText: localizedString("Learning Opportunities", for: selectedLanguage),
                linkURL: "https://www.refugee-action.org.uk/education"
            )
        ]
    }
    
    private func localizedString(_ key: String, for language: String) -> String {
        let translations: [String: [String: String]] = [
            "Existing Asylum Application": [
                "ar": "طلب لجوء قائم",
                "fr": "Demande d'asile existante",
                "fa": "درخواست پناهندگی موجود",
                "ku": "داواکاری پەنابەریی هەبوو",
                "ps": "شته پناه غوښتنه",
                "uk": "Існуюча заява на притулок",
                "ur": "موجودہ پناہ کی درخواست"
            ],
            "Support for current asylum seekers in the UK": [
                "ar": "الدعم لطالبي اللجوء الحاليين في المملكة المتحدة",
                "fr": "Soutien aux demandeurs d'asile actuels au Royaume-Uni",
                "fa": "پشتیبانی از پناهجویان فعلی در بریتانیا",
                "ku": "یارمەتی بۆ پەنابەرانی ئێستا لە شانشینی یەکگرتوو",
                "ps": "په انګلستان کې د اوسنیو پناه غوښتونکو ملاتړ",
                "uk": "Підтримка нинішніх шукачів притулку у Великій Британії",
                "ur": "برطانیہ میں موجودہ پناہ کے متلاشیوں کے لیے معاونت"
            ],
            "Application Status": [
                "ar": "حالة الطلب",
                "fr": "Statut de la demande",
                "fa": "وضعیت درخواست",
                "ku": "دۆخی داواکاری",
                "ps": "د غوښتنلیک حالت",
                "uk": "Статус заявки",
                "ur": "درخواست کی حیثیت"
            ],
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
