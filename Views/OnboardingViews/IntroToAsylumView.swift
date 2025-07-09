//
//  IntroToAsylumView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//

import SwiftUI

struct IntroToAsylumView: View {
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
                        number: "1",
                        title: step1Title,
                        description: step1Description
                    )
                    
                    StepCard(
                        number: "2",
                        title: step2Title,
                        description: step2Description
                    )
                    
                    StepCard(
                        number: "3",
                        title: step3Title,
                        description: step3Description
                    )
                    
                    StepCard(
                        number: "4",
                        title: step4Title,
                        description: step4Description
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
        case "ar": return "مرحبًا بكم في عملية اللجوء في المملكة المتحدة"
        case "fr": return "Bienvenue dans le processus d'asile au Royaume-Uni"
        case "fa": return "به فرآیند پناهندگی در بریتانیا خوش آمدید"
        case "ku": return "بەخێربێیت بۆ پرۆسەی پەنابەری لە شانشینی یەکگرتوو"
        case "ps": return "په انګلستان کې د پناه غوښتنې پروسې ته ښه راغلاست"
        case "uk": return "Ласкаво просимо до процесу надання притулку у Великій Британії"
        case "ur": return "برطانیہ میں پناہ کے عمل میں خوش آمدید"
        default: return "Welcome to the UK Asylum Process"
        }
    }

    private var asylumDescription: String {
        switch selectedLanguage {
        case "ar": return "إذا كنت تخطط لطلب اللجوء، سيساعدك هذا الدليل على فهم كل خطوة من الرحلة."
        case "fr": return "Si vous prévoyez de demander l'asile, ce guide vous aidera à comprendre chaque étape du parcours."
        case "fa": return "اگر قصد دارید پناهندگی بگیرید، این راهنما به شما کمک می‌کند تا هر مرحله از سفر را درک کنید."
        case "ku": return "ئەگەر دەتەوێت داوای پەنابەری بکەیت، ئەم ڕێنماییە یارمەتیت دەدات بۆ تێگەیشتن بە هەر هەنگاوێک."
        case "ps": return "که تاسو د پناه غوښتنې پلان لرئ، دا لارښود به درسره مرسته وکړي چې هر ګام درک کړئ."
        case "uk": return "Якщо ви плануєте подати заяву на притулок, цей посібник допоможе зрозуміти кожен крок."
        case "ur": return "اگر آپ پناہ لینے کا ارادہ رکھتے ہیں تو یہ گائیڈ آپ کو ہر مرحلہ سمجھنے میں مدد دے گا۔"
        default: return "If you're planning to seek asylum, this guide will help you understand each step of the journey."
        }
    }

    // MARK: - Steps

    private var step1Title: String {
        switch selectedLanguage {
        case "ar": return "التسجيل"
        case "fr": return "Enregistrement"
        case "fa": return "ثبت‌نام"
        case "ku": return "تۆمارکردن"
        case "ps": return "راجستر"
        case "uk": return "Реєстрація"
        case "ur": return "رجسٹریشن"
        default: return "Registration"
        }
    }

    private var step1Description: String {
        switch selectedLanguage {
        case "ar": return "تسجيل طلب اللجوء الخاص بك رسميًا لدى السلطات."
        case "fr": return "Enregistrez officiellement votre demande d'asile auprès des autorités."
        case "fa": return "درخواست پناهندگی خود را رسماً نزد مقامات ثبت کنید."
        case "ku": return "داوای پەنابەریت بە شێوەی فەرمی لە نزیكی دەسەڵاتەكان تۆمار بكە."
        case "ps": return "خپله د پناه غوښتنې غوښتنه رسمي ثبت کړئ."
        case "uk": return "Офіційно зареєструйте свою заяву на притулок у влади."
        case "ur": return "اپنی پناہ کی درخواست حکام کے ساتھ باضابطہ رجسٹر کریں۔"
        default: return "Officially register your asylum claim with the authorities."
        }
    }

    private var step2Title: String {
        switch selectedLanguage {
        case "ar": return "مقابلة الفحص"
        case "fr": return "Entretien de dépistage"
        case "fa": return "مصاحبه غربالگری"
        case "ku": return "چاوپێکەوتنی تاقیکردنەوە"
        case "ps": return "د سکریننګ مرکه"
        case "uk": return "Співбесіда з відбору"
        case "ur": return "سکریننگ انٹرویو"
        default: return "Screening Interview"
        }
    }

    private var step2Description: String {
        switch selectedLanguage {
        case "ar": return "سوف تُسأل عن خلفيتك وأسباب لجوئك."
        case "fr": return "Vous serez interrogé sur vos antécédents et votre raison de chercher l'asile."
        case "fa": return "در مورد سابقه شما و دلیل درخواست پناهندگی‌تان سوال می‌شود."
        case "ku": return "پرسیاری دەکرێت لەسەر ڕوونکردنەوە و هۆکاری داوای پەنابەریت."
        case "ps": return "ستاسو د شالید او د پناه غوښتنې دلیل به وپوښتل شي."
        case "uk": return "Вас запитають про ваше минуле та причини звернення за притулком."
        case "ur": return "آپ سے آپ کی پس منظر اور پناہ لینے کی وجہ پوچھی جائے گی۔"
        default: return "You'll be asked about your background and reason for seeking asylum."
        }
    }

    private var step3Title: String {
        switch selectedLanguage {
        case "ar": return "مقابلة اللجوء"
        case "fr": return "Entretien d'asile"
        case "fa": return "مصاحبه پناهندگی"
        case "ku": return "چاوپێکەوتنی پەنابەری"
        case "ps": return "د پناه غوښتنې مرکه"
        case "uk": return "Співбесіда щодо притулку"
        case "ur": return "پناہ کی انٹرویو"
        default: return "Asylum Interview"
        }
    }

    private var step3Description: String {
        switch selectedLanguage {
        case "ar": return "المقابلة الرئيسية التي تقرر حالتك."
        case "fr": return "L'entretien principal qui détermine votre statut."
        case "fa": return "مصاحبه اصلی که وضعیت شما را مشخص می‌کند."
        case "ku": return "ئەو چاوپێکەوتنە سەرەکییە کە دۆخی تۆ دیاریدەکات."
        case "ps": return "اصلي مرکه چې ستاسو د قضیې پرېکړه کوي."
        case "uk": return "Головна співбесіда, яка визначає вашу справу."
        case "ur": return "مرکزی انٹرویو جو آپ کے کیس کا فیصلہ کرے گا۔"
        default: return "The main interview that decides your case."
        }
    }

    private var step4Title: String {
        switch selectedLanguage {
        case "ar": return "القرار"
        case "fr": return "Décision"
        case "fa": return "تصمیم نهایی"
        case "ku": return "بڕیار"
        case "ps": return "پریکړه"
        case "uk": return "Рішення"
        case "ur": return "فیصلہ"
        default: return "Decision"
        }
    }

    private var step4Description: String {
        switch selectedLanguage {
        case "ar": return "ستتلقى النتيجة والمساعدة التالية إذا تمت الموافقة."
        case "fr": return "Vous recevrez le résultat et de l'aide si vous êtes approuvé."
        case "fa": return "نتیجه را دریافت می‌کنید و در صورت پذیرش کمک خواهید گرفت."
        case "ku": return "ئەگەر قبوڵ بکرێت، ئەنجامی داواکاری و یارمەتی داهاتووت وەرگری."
        case "ps": return "که ستاسو غوښتنه ومنل شي، نتیجه او ملاتړ ترلاسه کوئ."
        case "uk": return "Якщо вашу заяву буде схвалено, ви отримаєте результат і подальшу підтримку."
        case "ur": return "اگر آپ کی درخواست منظور ہو جائے تو نتیجہ اور معاونت حاصل کریں گے۔"
        default: return "You’ll receive the outcome and next support if approved."
        }
    }

    // MARK: - Benefits Section

    private var asylumBenefitsTitle: String {
        switch selectedLanguage {
        case "ar": return "فوائد اللجوء"
        case "fr": return "Avantages de l'asile"
        case "fa": return "مزایای پناهندگی"
        case "ku": return "سوودەکانی پەنابەری"
        case "ps": return "د پناه ګټې"
        case "uk": return "Переваги притулку"
        case "ur": return "پناہ کی سہولیات"
        default: return "Asylum Benefits"
        }
    }

    private var asylumBenefit1: String {
        switch selectedLanguage {
        case "ar": return "الحماية من الترحيل القسري"
        case "fr": return "Protection contre l'expulsion"
        case "fa": return "محافظت در برابر اخراج اجباری"
        case "ku": return "پاراستن لە دەرکردنی زۆرەوە"
        case "ps": return "د جبري اخراج څخه ساتنه"
        case "uk": return "Захист від примусового видворення"
        case "ur": return "زبردستی بے دخلی سے تحفظ"
        default: return "Protection from forced removal"
        }
    }

    private var asylumBenefit2: String {
        switch selectedLanguage {
        case "ar": return "الدعم المالي والإقامة"
        case "fr": return "Soutien financier et logement"
        case "fa": return "حمایت مالی و مسکن"
        case "ku": return "پشتگیری دارایی و جێگای نیشتەجێبوون"
        case "ps": return "مالي ملاتړ او استوګنځای"
        case "uk": return "Фінансова допомога та житло"
        case "ur": return "مالی معاونت اور رہائش"
        default: return "Financial support and housing"
        }
    }

    private var asylumBenefit3: String {
        switch selectedLanguage {
        case "ar": return "الوصول إلى الرعاية الصحية"
        case "fr": return "Accès aux soins de santé"
        case "fa": return "دسترسی به مراقبت‌های بهداشتی"
        case "ku": return "گەیشتن بە چاودێری تەندروستی"
        case "ps": return "د روغتیايي خدمتونو ته لاسرسی"
        case "uk": return "Доступ до медичної допомоги"
        case "ur": return "صحت کی سہولیات تک رسائی"
        default: return "Access to healthcare"
        }
    }

    private var asylumBenefit4: String {
        switch selectedLanguage {
        case "ar": return "الدراسة والعمل لاحقًا"
        case "fr": return "Étudier et travailler plus tard"
        case "fa": return "تحصیل و کار در آینده"
        case "ku": return "خوێندن و کارکردن لە داهاتوودا"
        case "ps": return "زده کړه او وروسته کار کول"
        case "uk": return "Навчання та робота у майбутньому"
        case "ur": return "آگے جا کر تعلیم اور ملازمت"
        default: return "Study and work later"
        }
    }

    // MARK: - Continue Button

    private var continueButtonText: String {
        switch selectedLanguage {
        case "ar": return "متابعة"
        case "fr": return "Continuer"
        case "fa": return "ادامه"
        case "ku": return "بەردەوام بە"
        case "ps": return "ادامه ورکړئ"
        case "uk": return "Продовжити"
        case "ur": return "جاری رکھیں"
        default: return "Continue"
        }
    }
    
    
    // ... (similar localized properties for all text elements)
    
    struct StepCard: View {
        let number: String
        let title: String
        let description: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 16) {
                Text(number)
                    .font(.title)
                    .bold()
                    .frame(width: 40, height: 40)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                
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

