//
//  NewAsylumSeekerOnboardingView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======

let asylumBenefitsTitle = NSLocalizedString("Asylum Benefits", comment: "")
let asylumBenefit1 = NSLocalizedString("Access to housing", comment: "")
let asylumBenefit2 = NSLocalizedString("Free healthcare", comment: "")
let asylumBenefit3 = NSLocalizedString("Education for children", comment: "")
let asylumBenefit4 = NSLocalizedString("Monthly financial support", comment: "")
let continueButtonText = NSLocalizedString("Continue", comment: "")
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct NewAsylumSeekerOnboardingView: View {
    var onContinue: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    @State private var showRefEntry = false
    
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray

    
<<<<<<< HEAD
=======
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)  // Deep UK blue
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)   // UK accent orange
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
    private let cardBackground = Color.white
    
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(asylumTitle)
                            .font(.title)
                            .bold()
                            .foregroundColor(primaryColor)
<<<<<<< HEAD
                            .lineLimit(nil)
=======
                            .lineLimit(nil) // Ensure full text display
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                        
                        Text(asylumDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
<<<<<<< HEAD
                            .lineLimit(nil)
                    }
                    .padding(.bottom, 10)
                    
                    // UK Asylum Process
                    VStack(alignment: .leading, spacing: 25) {
                        Text(localized("UK Asylum Process"))
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil)
=======
                            .lineLimit(nil) // Ensure full text display
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        Text("UK Asylum Process")
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil) // Ensure full text display
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                        
                        StepCard(
                            icon: "doc.text.fill",
                            title: step1Title,
                            description: step1Description,
                            color: primaryColor
                        )
                        
                        StepCard(
                            icon: "person.fill.questionmark",
                            title: step2Title,
                            description: step2Description,
                            color: accentColor
                        )
                        
                        StepCard(
                            icon: "clock.fill",
                            title: step3Title,
                            description: step3Description,
                            color: primaryColor
                        )
                        
                        StepCard(
                            icon: "house.fill",
                            title: step4Title,
                            description: step4Description,
                            color: accentColor
                        )
                        
                        StepCard(
                            icon: "person.2.fill",
                            title: step5Title,
                            description: step5Description,
                            color: primaryColor
                        )
                    }
                    .padding()
<<<<<<< HEAD
                    .background(backgroundColor)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    // Rights and Benefits
                    VStack(alignment: .leading, spacing: 20) {
                        Text(localized("Your Rights & Benefits"))
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            BenefitItem(icon: "house.fill", text: localized("Access to housing"), color: primaryColor)
                            BenefitItem(icon: "heart.fill", text: localized("Free healthcare through NHS"), color: accentColor)
                            BenefitItem(icon: "book.fill", text: localized("Education for children (5-18 years)"), color: primaryColor)
                            BenefitItem(icon: "sterlingsign.circle.fill", text: localized("Financial support (£49.18/week)"), color: accentColor)
                            BenefitItem(icon: "gavel.fill", text: localized("Free legal advice"), color: primaryColor)
                            BenefitItem(icon: "hands.sparkles.fill", text: localized("Protection from deportation"), color: accentColor)
=======
                    .background(cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(asylumBenefitsTitle)
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil) // Ensure full text display
                        
                        VStack(alignment: .leading, spacing: 15) {
                            BenefitItem(icon: "house.fill", text: asylumBenefit1, color: primaryColor)
                            BenefitItem(icon: "heart.fill", text: asylumBenefit2, color: accentColor)
                            BenefitItem(icon: "book.fill", text: asylumBenefit3, color: primaryColor)
                            BenefitItem(icon: "sterlingsign.circle.fill", text: asylumBenefit4, color: accentColor)
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                        }
                        .padding(.vertical, 5)
                    }
                    .padding()
<<<<<<< HEAD
                    .background(backgroundColor)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    // Immediate Actions
                    VStack(alignment: .leading, spacing: 20) {
                        Text(localized("First Steps in the UK"))
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            ImmediateActionItem(
                                icon: "phone.fill",
                                title: localized("Report to Authorities"),
                                description: localized("Visit a screening unit within 3 days of arrival"),
                                color: accentColor
                            )
                            
                            ImmediateActionItem(
                                icon: "doc.text.fill",
                                title: localized("Apply for Asylum"),
                                description: localized("Submit your application at the screening interview"),
                                color: primaryColor
                            )
                            
                            ImmediateActionItem(
                                icon: "mappin.and.ellipse",
                                title: localized("Register Your Address"),
                                description: localized("Update Home Office if you change accommodation"),
                                color: accentColor
                            )
                        }
                    }
                    .padding()
                    .background(backgroundColor)
=======
                    .background(cardBackground)
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    Spacer()
                    
<<<<<<< HEAD
                    Button(action: { showRefEntry = true }) {
                        Text(localized("Continue"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(AppColors.primary)
=======
                    Button(action: onContinue) {
                        Text(continueButtonText)
                            .font(.headline)
                            .foregroundColor(.white)
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .shadow(color: primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.bottom, 20)
                }
                .padding()
                .background(backgroundColor.ignoresSafeArea())
<<<<<<< HEAD
                .id("top")
=======
                .id("top") // Identifier for scrolling
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
            }
            .navigationTitle(asylumTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                proxy.scrollTo("top", anchor: .top)
            }
        }
<<<<<<< HEAD
        .navigationDestination(isPresented: $showRefEntry) {
            EnterReferenceNumberView(
                title: localized("Enter Your Home Office Ref Number"),
                subtitle: localized("You'll find this on documents from the UK Home Office (e.g. A1234567)"),
                placeholder: "A1234567"
            ) { _ in
                onContinue()
            }
=======
    }
    
    private var asylumTitle: String {
        switch selectedLanguage {
        case "ar": return "دليل طالبي اللجوء الجدد"
        case "fr": return "Guide des nouveaux demandeurs d'asile"
        case "fa": return "راهنمای تازه واردان پناهجو"
        default: return "New Asylum Seeker's Guide"
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
        }
    }
        // MARK: - Localized Content
        private var asylumTitle: String {
            localized("New Asylum Seeker's Guide")
        }
<<<<<<< HEAD
        
        private var asylumDescription: String {
            localized("Your comprehensive guide to starting your asylum journey in the UK")
        }
        
        private var step1Title: String {
            localized("Registration")
        }
        
        private var step1Description: String {
            localized("Start your journey by officially submitting your asylum application")
        }
        
        private var step2Title: String {
            localized("Screening Interview")
        }
        
        private var step2Description: String {
            localized("Initial meeting to verify identity and reasons for seeking asylum")
        }
        
        private var step3Title: String {
            localized("Waiting Period")
        }
        
        private var step3Description: String {
            localized("Decision may take several months. You'll receive temporary support")
        }
        
        private var step4Title: String {
            localized("Housing Support")
        }
        
        private var step4Description: String {
            localized("Temporary accommodation provided during the application process")
        }
        
        private var step5Title: String {
            localized("Main Interview")
        }
        
        private var step5Description: String {
            localized("Detailed meeting about your asylum reasons (bring all evidence)")
        }
        
        private func localized(_ key: String) -> String {
            NSLocalizedString(key, comment: "")
        }
        
        // MARK: - Custom Views
        struct StepCard: View {
            let icon: String
            let title: String
            let description: String
            let color: Color
            
            var body: some View {
                HStack(alignment: .top, spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: icon)
                            .foregroundColor(color)
                            .font(.system(size: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        
        struct BenefitItem: View {
            let icon: String
            let text: String
            let color: Color
            
            var body: some View {
                HStack(alignment: .top) {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 20))
                        .frame(width: 30)
                    
                    Text(text)
                        .font(.subheadline)
                        .lineLimit(nil)
                }
            }
        }
        
        struct ImmediateActionItem: View {
            let icon: String
            let title: String
            let description: String
            let color: Color
            
            var body: some View {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 20))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.primary)
                        Text(description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
=======
    }
    
    private var step1Title: String {
        switch selectedLanguage {
        case "ar": return "التسجيل"
        case "fr": return "Enregistrement"
        case "fa": return "ثبت‌نام"
        default: return "Registration"
        }
    }

    private var step1Description: String {
        switch selectedLanguage {
        case "ar": return "ابدأ رحلتك بتقديم طلب اللجوء رسميًا."
        case "fr": return "Commencez votre parcours en enregistrant officiellement votre demande d'asile."
        case "fa": return "سفر خود را با ثبت رسمی درخواست پناهندگی آغاز کنید."
        default: return "Start your journey by officially submitting your asylum application."
        }
    }

    private var step2Title: String {
        switch selectedLanguage {
        case "ar": return "المقابلة الأولية"
        case "fr": return "Entretien initial"
        case "fa": return "مصاحبه اولیه"
        default: return "Initial Interview"
        }
    }

    private var step2Description: String {
        switch selectedLanguage {
        case "ar": return "مقابلة قصيرة للتحقق من هويتك وأسباب اللجوء."
        case "fr": return "Un bref entretien pour vérifier votre identité et les raisons de votre demande."
        case "fa": return "مصاحبه کوتاه برای تأیید هویت و دلایل درخواست شما."
        default: return "A short interview to verify your identity and asylum reasons."
        }
    }

    private var step3Title: String {
        switch selectedLanguage {
        case "ar": return "الانتظار للقرار"
        case "fr": return "Attente de la décision"
        case "fa": return "انتظار برای تصمیم"
        default: return "Waiting for a Decision"
        }
    }

    private var step3Description: String {
        switch selectedLanguage {
        case "ar": return "قد يستغرق اتخاذ القرار بعض الوقت. ستتلقى دعمًا مؤقتًا."
        case "fr": return "La décision peut prendre du temps. Vous recevrez un soutien temporaire."
        case "fa": return "ممکن است مدتی طول بکشد تا تصمیم گرفته شود. شما از پشتیبانی موقت برخوردار خواهید شد."
        default: return "It may take time to receive a decision. You’ll get temporary support."
        }
    }

    private var step4Title: String {
        switch selectedLanguage {
        case "ar": return "دعم الإقامة"
        case "fr": return "Soutien au logement"
        case "fa": return "حمایت اقامتی"
        default: return "Housing Support"
        }
    }

    private var step4Description: String {
        switch selectedLanguage {
        case "ar": return "قد يتم توفير سكن مؤقت لك أثناء انتظار القرار."
        case "fr": return "Un logement temporaire peut vous être fourni pendant l'attente."
        case "fa": return "در طول انتظار ممکن است اقامت موقت برای شما فراهم شود."
        default: return "Temporary housing may be provided while you wait."
        }
    }

    private var step5Title: String {
        switch selectedLanguage {
        case "ar": return "الدعم المجتمعي"
        case "fr": return "Soutien communautaire"
        case "fa": return "پشتیبانی اجتماعی"
        default: return "Community Support"
        }
    }

    private var step5Description: String {
        switch selectedLanguage {
        case "ar": return "الوصول إلى المساعدة من المنظمات والجمعيات المحلية."
        case "fr": return "Accès à l'aide des organisations et associations locales."
        case "fa": return "دسترسی به کمک از سازمان‌ها و انجمن‌های محلی."
        default: return "Access help from local organizations and community groups."
        }
    }
    
    struct StepCard: View {
        let icon: String
        let title: String
        let description: String
        let color: Color
        
        var body: some View {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(nil) // Ensure full text display
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(nil) // Ensure full text display
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                }
            }
            .padding(.vertical, 5)
        }
    }
    
<<<<<<< HEAD
    struct NewAsylumSeekerOnboardingView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                NewAsylumSeekerOnboardingView(onContinue: {})
            }
        }
    }
=======
    struct BenefitItem: View {
        let icon: String
        let text: String
        let color: Color
        
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                    .frame(width: 30)
                
                Text(text)
                    .font(.subheadline)
                    .lineLimit(nil) // Ensure full text display
            }
        }
    }
}

struct NewAsylumSeekerOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewAsylumSeekerOnboardingView(onContinue: {})
        }
    }
}
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
