//
//  WelcomeIntroView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct WelcomeIntroView: View {
    let selectedLanguage: String
    var onContinue: () -> Void

    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    private var welcomeMessage: String {
        switch selectedLanguage {
        case "ar": "مرحبًا بك في دليل اللاجئين"
        case "fr": "Bienvenue dans Refugee Guide"
        case "fa": "به راهنمای پناهندگان خوش آمدید"
        case "ku": "بەخێربێیت بۆ ڕێنمای پەنابەران"
        case "ps": "د کډوالو لارښود ته ښه راغلاست"
        case "uk": "Ласкаво просимо до Посібника для біженців"
        case "ur": "ریفیوجی گائیڈ میں خوش آمدید"
        default: "Welcome to Refugee Guide"
        }
    }
    
    private var introText: String {
        switch selectedLanguage {
        case "ar": "هذا التطبيق سيساعدك في رحلتك كلاجئ في المملكة المتحدة. سنزودك بالمعلومات والموارد اللازمة لخطواتك التالية."
        case "fr": "Cette application vous aidera dans votre parcours de réfugié au Royaume-Uni. Nous vous fournissons les informations et les ressources nécessaires pour vos prochaines étapes."
        case "fa": "این برنامه به شما در سفر پناهندگی شما در بریتانیا کمک خواهد کرد. ما اطلاعات و منابع لازم را برای مراحل بعدی شما فراهم می‌کنیم."
        case "ku": "ئه‌م بەرنامەیە یارمەتیت دەدات لە گەشتە پەنابەرایەتیەکت لە شانشینی یەکگرتوو. ئێمه‌ زانیاری و سەرچاوە پێشکەشت دەکەین بۆ هەنگاوی دواتر."
        case "ps": "دا اپلیکیشن به تاسو سره د مهاجرت په سفر کې په انګلستان کې مرسته وکړي. موږ به تاسو ته اړینې معلومات او سرچینې برابر کړو."
        case "uk": "Цей додаток допоможе вам у вашій подорожі як біженця у Великій Британії. Ми надамо вам необхідну інформацію та ресурси для наступних кроків."
        case "ur": "یہ ایپ آپ کو برطانیہ میں بطور پناہ گزین آپ کے سفر میں مدد فراہم کرے گی۔ ہم آپ کو آپ کے اگلے مراحل کے لیے ضروری معلومات اور وسائل فراہم کریں گے۔"
        default: "This app will assist you in your journey as a refugee in the UK. We provide you with the information and resources needed for your next steps."
        }
    }
    
    private var continueButtonText: String {
        switch selectedLanguage {
        case "ar": "متابعة"
        case "fr": "Continuer"
        case "fa": "ادامه"
        case "ku": "بەردەوام بە"
        case "ps": "ادامه ورکړئ"
        case "uk": "Продовжити"
        case "ur": "جاری رکھیں"
        default: "Continue"
        }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(welcomeMessage)
                            .font(.largeTitle)
                            .bold()
                            .lineLimit(nil) // Ensure full text display
                        
                        Text(selectedLanguage.uppercased())
                            .font(.title2)
                            .padding(10)
                            .background(Capsule().fill(Color.blue.opacity(0.2)))
                            .lineLimit(nil) // Ensure full text display
                        
                        Text(introText)
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .lineLimit(nil) // Ensure full text display
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Text(localizedString("Refugee Guide", translations: [
                        "ar": "دليل اللاجئ",
                        "fr": "Guide du réfugié",
                        "fa": "راهنمای پناهنده",
                        "ku": "ڕێنمای پەنابەر",
                        "ps": "د کډوالو لارښود",
                        "uk": "Посібник для біженців",
                        "ur": "ریفیوجی گائیڈ",
                    ]))
                    .font(.headline)
                    .padding(.bottom, 10)
                    .lineLimit(nil) // Ensure full text display
                    
                    Text(localizedString("Three options below! 👇", translations: [
                        "ar": "ثلاث خيارات أدناه! 👇",
                        "fr": "Trois options ci-dessous! 👇",
                        "fa": "سه گزینه در زیر! 👇",
                        "ku": "سێ هەلبژاردن لە خوارەوە! 👇",
                        "ps": "درې اختیارونه لاندې دي! 👇",
                        "uk": "Три варіанти нижче! 👇",
                        "ur": "تین اختیارات نیچے ہیں! 👇"
                    ]))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(nil) // Ensure full text display
                    
                    Button(action: onContinue) {
                        Text(continueButtonText)
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .background(AppColors.primary)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 30)
                }
                .id("top") // Identifier for scrolling
            }
            .onAppear {
                proxy.scrollTo("top", anchor: .top)
            }
        }
    }
    
    func localizedString(_ key: String, translations: [String: String]) -> String {
        return translations[selectedLanguage] ?? key
    }
}
