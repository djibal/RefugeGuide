//
//  NewAsylumSeekerOnboardingView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//


import SwiftUI


let asylumBenefitsTitle = NSLocalizedString("Asylum Benefits", comment: "")
let asylumBenefit1 = NSLocalizedString("Access to housing", comment: "")
let asylumBenefit2 = NSLocalizedString("Free healthcare", comment: "")
let asylumBenefit3 = NSLocalizedString("Education for children", comment: "")
let asylumBenefit4 = NSLocalizedString("Monthly financial support", comment: "")
let continueButtonText = NSLocalizedString("Continue", comment: "")



struct NewAsylumSeekerOnboardingView: View {
    var onContinue: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text(asylumTitle)
                    .font(.title)
                    .bold()
                
                Text(asylumDescription)
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 20) {
                    StepCard(
                        icon: "doc.text.magnifyingglass",
                        title: step1Title,
                        description: step1Description
                    )
                    
                    StepCard(
                        icon: "doc.plaintext",
                        title: step2Title,
                        description: step2Description
                    )
                    
                    StepCard(
                        icon: "person.badge.clock",
                        title: step3Title,
                        description: step3Description
                    )
                    
                    StepCard(
                        icon: "creditcard",
                        title: step4Title,
                        description: step4Description
                    )
                    
                    StepCard(
                        icon: "person.2.square.stack",
                        title: step5Title,
                        description: step5Description
                    )
                }
                
                Divider()
                    .padding(.vertical)
                
                Text(asylumBenefitsTitle)
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 12) {
                    BenefitItem(text: asylumBenefit1)
                    BenefitItem(text: asylumBenefit2)
                    BenefitItem(text: asylumBenefit3)
                    BenefitItem(text: asylumBenefit4)
                }
                
                Spacer()
                
                Button(action: onContinue) {
                    Text(continueButtonText)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle(asylumTitle)
    }
    
    // MARK: - Localized Content
    
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
    
    // MARK: - Step Titles & Descriptions

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

    
    // ... (similar localized properties for all text elements)
    
    struct StepCard: View {
        let icon: String
        let title: String
        let description: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.accentColor)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    struct BenefitItem: View {
        let text: String
        
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text(text)
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


