//
//  NewAsylumSeekerOnboardingView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

let asylumBenefitsTitle = NSLocalizedString("Asylum Benefits", comment: "")
let asylumBenefit1 = NSLocalizedString("Access to housing", comment: "")
let asylumBenefit2 = NSLocalizedString("Free healthcare", comment: "")
let asylumBenefit3 = NSLocalizedString("Education for children", comment: "")
let asylumBenefit4 = NSLocalizedString("Monthly financial support", comment: "")
let continueButtonText = NSLocalizedString("Continue", comment: "")

struct NewAsylumSeekerOnboardingView: View {
    var onContinue: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)  // Deep UK blue
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)   // UK accent orange
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
    private let cardBackground = Color.white
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(asylumTitle)
                            .font(.title)
                            .bold()
                            .foregroundColor(primaryColor)
                            .lineLimit(nil) // Ensure full text display
                        
                        Text(asylumDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(nil) // Ensure full text display
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        Text("UK Asylum Process")
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil) // Ensure full text display
                        
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
                        }
                        .padding(.vertical, 5)
                    }
                    .padding()
                    .background(cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    Spacer()
                    
                    Button(action: onContinue) {
                        Text(continueButtonText)
                            .font(.headline)
                            .foregroundColor(.white)
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
                .id("top") // Identifier for scrolling
            }
            .navigationTitle(asylumTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                proxy.scrollTo("top", anchor: .top)
            }
        }
    }
    
    private var asylumTitle: String {
        switch selectedLanguage {
        case "ar": return "دليل طالبي اللجوء الجدد"
        case "fr": return "Guide des nouveaux demandeurs d'asile"
        case "fa": return "راهنمای تازه واردان پناهجو"
        default: return "New Asylum Seeker's Guide"
        }
    }
    
    private var asylumDescription: String {
        switch selectedLanguage {
        case "ar": return "دليلك الشامل لبدء رحلة اللجوء في المملكة المتحدة"
        case "fr": return "Votre guide complet pour commencer votre parcours d'asile au Royaume-Uni"
        case "fa": return "راهنمای جامع شما برای شروع سفر پناهندگی در بریتانیا"
        default: return "Your comprehensive guide to starting your asylum journey in the UK"
        }
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
