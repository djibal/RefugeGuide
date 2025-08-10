//
//  ResidenceGuideView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct ResidenceGuideView: View {
    let selectedLanguage: String
    var onContinue: () -> Void
    

    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")


    var body: some View {
        GuideContentView(
            selectedLanguage: selectedLanguage,
            title: localizedString("Residence Permit Holders", for: selectedLanguage),
            subtitle: localizedString("Support after receiving leave to remain in the UK", for: selectedLanguage),
            cards: guideCards,
            continueButtonText: localizedString("Continue", for: selectedLanguage),
            onContinue: onContinue,
            primaryColor: primaryColor,
            accentColor: accentColor
        )
    }
    
    private var guideCards: [GuideCardData] {
        [
            GuideCardData(
                title: localizedString("Universal Credit", for: selectedLanguage),
                description: localizedString("Apply for monthly financial support", for: selectedLanguage),
                icon: "sterlingsign.circle.fill",
                linkText: localizedString("Apply Now", for: selectedLanguage),
                linkURL: "https://www.gov.uk/universal-credit"
            ),
            GuideCardData(
                title: localizedString("Council Housing", for: selectedLanguage),
                description: localizedString("Support to help you find housing", for: selectedLanguage),
                icon: "house.fill",
                linkText: localizedString("Find Housing", for: selectedLanguage),
                linkURL: "https://www.gov.uk/apply-for-council-housing"
            ),
            GuideCardData(
                title: localizedString("Jobseeker Support", for: selectedLanguage),
                description: localizedString("Training programs and job listings", for: selectedLanguage),
                icon: "briefcase.fill",
                linkText: localizedString("Job Search", for: selectedLanguage),
                linkURL: "https://www.gov.uk/jobsearch"
            )
        ]
    }
    
    private func localizedString(_ key: String, for language: String) -> String {
        let translations: [String: [String: String]] = [
            "Residence Permit Holders": [
                "ar": "حاملي تصاريح الإقامة",
                "fr": "Titulaires de permis de séjour",
                "fa": "دارندگان اجازه اقامت",
                "ku": "خاوەنانی مۆڵەتی نیشتەجێبوون",
                "ps": "د اقامت اجازه لرونکي",
                "uk": "Власники дозволу на проживання",
                "ur": "رہائش کی اجازت نامے کے حاملین"
            ],
            "Support after receiving leave to remain in the UK": [
                "ar": "الدعم بعد الحصول على إذن البقاء في المملكة المتحدة",
                "fr": "Soutien après l'obtention du permis de séjour au Royaume-Uni",
                "fa": "پشتیبانی پس از دریافت اجازه اقامت در بریتانیا",
                "ku": "یارمەتی دوای وەرگرتنی مۆڵەتی مانەوە لە شانشینی یەکگرتوو",
                "ps": "په انګلستان کې د پاتې کیدو اجازه ترلاسه کولو وروسته ملاتړ",
                "uk": "Підтримка після отримання дозволу на проживання у Великій Британії",
                "ur": "برطانیہ میں رہنے کی اجازت ملنے کے بعد معاونت"
            ],
            "Universal Credit": [
                "ar": "الائتمان الشامل",
                "fr": "Crédit Universel",
                "fa": "اعتبار جهانی",
                "ku": "قەرزی گشتی",
                "ps": "یونیورسل کریډیټ",
                "uk": "Універсальний кредит",
                "ur": "یونیورسل کریڈٹ"
            ],
            "Continue": [
                "ar": "متابعة",
                "fr": "Continuer",
                "fa": "ادامه",
                "ku": "بەردەوام بە",
                "ps": "ادامه ورکړئ",
                "uk": "Продовжити",
                "ur": "جاری رکھیں"
            ]
        ]
        
        return translations[key]?[language] ?? key
    }
}
