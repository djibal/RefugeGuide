//
//  WelcomeIntroView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//
import SwiftUI

struct WelcomeIntroView: View {
    let selectedLanguage: String
    var onContinue: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("👉 Refugee Guide")
                .font(.title2)
                .bold()

            Text(localizedString(selectedLanguage, translations: [
                "en": "Welcome to the Refugee Guide app",
                "ar": "مرحبًا بك في تطبيق دليل اللاجئين",
                "fr": "Bienvenue dans l'application Refugee Guide",
                "fa": "به اپلیکیشن راهنمای پناهندگان خوش آمدید",
                "ur": "پناہ گزین گائیڈ ایپ میں خوش آمدید",
                "uk": "Ласкаво просимо до додатку Refugee Guide",
                "ps": "د مهاجرت لارښود ایپ ته ښه راغلاست",
                "ku": "Bi xêr hatî serlêdana Refugee Guide"
            ]))
            .multilineTextAlignment(.center)

            Button(action: onContinue) {
                Text(localizedString(selectedLanguage, translations: [
                    "en": "Continue",
                    "ar": "استمر",
                    "fr": "Continuer",
                    "fa": "ادامه",
                    "ur": "جاری رکھیں",
                    "uk": "Продовжити",
                    "ps": "ادامه ورکړئ",
                    "ku": "Berdewam"
                ]))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding()
    }

    // MARK: - Localization Helper
    private func localizedString(_ lang: String, translations: [String: String]) -> String {
        return translations[lang] ?? translations["en"] ?? ""
    }
}
