//
//  LeaveToRemainGuideView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 07/05/2025.
//
import SwiftUI

struct LeaveToRemainGuideView: View {
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    @AppStorage("hasCompletedInitialSetup") var hasCompletedInitialSetup = false
    @State private var currentStep: OnboardingStep = .languageSelection
    
    // MARK: - UI Constants
    private var primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)  // Deep UK blue
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)   // UK accent orange
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
    
    var onContinue: () -> Void // Add closure for completion
    
    init(selectedLanguage: String, primaryColor: Color, onContinue: @escaping () -> Void) {
        self.selectedLanguage = selectedLanguage
        self.primaryColor = primaryColor
        self.onContinue = onContinue
    }

    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack {
                    switch currentStep {
                    case .languageSelection:
                        LanguageSelection(
                            selectedLanguage: $selectedLanguage,
                            primaryColor: primaryColor,
                            onContinue: {
                                withAnimation { currentStep = .welcomeMessage }
                            }
                        )

                    case .welcomeMessage:
                        WelcomeIntroView(
                            selectedLanguage: selectedLanguage,
                            onContinue: {
                                withAnimation { currentStep = .statusSelection }
                            },
                            primaryColor: primaryColor // ✅ moved below
                        )

                    case .statusSelection:
                        StatusSelectionView(
                            selectedLanguage: selectedLanguage,
                            onStatusSelected: { status in
                            handleStatusSelection(status)
                            }
                        )


                    case .asylumGuide:
                        AsylumGuideView(selectedLanguage: selectedLanguage) {
                            showRegistration()
                        }

                    case .existingAsylumGuide:
                        ExistingAsylumGuideView(selectedLanguage: selectedLanguage) {
                            showRegistration()
                        }

                    case .residenceGuide:
                        ResidenceGuideView(selectedLanguage: selectedLanguage) {
                            showRegistration()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    
    private func handleStatusSelection(_ status: RefugeeUserType) {
        switch status {
        case .asylumSeeker:
            currentStep = .asylumGuide
        case .existingAsylumSeeker:
            currentStep = .existingAsylumGuide
        case .grantedResidence:
            currentStep = .residenceGuide
        case .unknown:
            currentStep = .statusSelection
        case .refugee:
            currentStep = .statusSelection
        case .newAsylumSeeker:
            currentStep = .statusSelection
        case .seekingAsylum:
            currentStep = .asylumGuide
        case .residencePermitHolder:
            currentStep = .residenceGuide
            
        }
    }
    

    private func showRegistration() {
        hasCompletedInitialSetup = true
        onContinue() // Call completion handler
    }
}

// MARK: - Onboarding Steps
enum OnboardingStep {
    case languageSelection
    case welcomeMessage
    case statusSelection
    case asylumGuide
    case existingAsylumGuide
    case residenceGuide
}

enum UserStatus {
    case seekingAsylum
    case existingAsylumSeeker
    case grantedResidence
}

struct LanguageSelection: View {
    @Binding var selectedLanguage: String
    var primaryColor: Color
    var onContinue: () -> Void
    
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(primaryColor)
                
                Text("Select your preferred language")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(primaryColor)
            }
            .padding(.top, 40)
            
            VStack(spacing: 20) {
                LanguageButton(
                    language: "English",
                    code: "en",
                    isSelected: selectedLanguage == "en",
                    primaryColor: primaryColor
                ) {
                    selectedLanguage = "en"
                }
                
                LanguageButton(
                    language: "العربية (Arabic)",
                    code: "ar",
                    isSelected: selectedLanguage == "ar",
                    primaryColor: primaryColor
                ) {
                    selectedLanguage = "ar"
                }
                
                LanguageButton(
                    language: "Français (French)",
                    code: "fr",
                    isSelected: selectedLanguage == "fr",
                    primaryColor: primaryColor
                ) {
                    selectedLanguage = "fr"
                }
                
                LanguageButton(
                    language: "فارسی (Farsi)",
                    code: "fa",
                    isSelected: selectedLanguage == "fa",
                    primaryColor: primaryColor
                ) {
                    selectedLanguage = "fa"
                }
                
                LanguageButton(
                    language: "کوردی (Kurdish)",
                    code: "ku",
                    isSelected: selectedLanguage == "ku",
                    primaryColor: primaryColor
                ) {
                    selectedLanguage = "ku"
                }
                
                LanguageButton(
                    language: "پښتو (Pashto)",
                    code: "ps",
                    isSelected: selectedLanguage == "ps",
                    primaryColor: primaryColor
                ) {
                    selectedLanguage = "ps"
                }
                
                LanguageButton(
                    language: "Українська (Ukrainian)",
                    code: "uk",
                    isSelected: selectedLanguage == "uk",
                    primaryColor: primaryColor
                ) {
                    selectedLanguage = "uk"
                }
                
                LanguageButton(
                    language: "اردو (Urdu)",
                    code: "ur",
                    isSelected: selectedLanguage == "ur",
                    primaryColor: primaryColor
                ) {
                    selectedLanguage = "ur"
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                    .shadow(color: primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.bottom, 30)
        }
        .padding()
    }
    
    struct LanguageButton: View {
        let language: String
        let code: String
        let isSelected: Bool
        let primaryColor: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Text(language)
                        .font(.body)
                        .foregroundColor(.primary)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(primaryColor)
                            .font(.title2)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? primaryColor : Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
}

// MARK: - Welcome Intro View
struct WelcomeToIntroView: View {
    let selectedLanguage: String
    var primaryColor: Color
    var onContinue: () -> Void
    


    
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
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading, spacing: 20) {
                Text(welcomeMessage)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(primaryColor)
                
                Text(selectedLanguage.uppercased())
                    .font(.title2)
                    .padding(10)
                    .background(Capsule().fill(primaryColor.opacity(0.2)))
                
                Text(introText)
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 15) {
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
                .foregroundColor(primaryColor)
                
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
            }
            .frame(maxWidth: .infinity)
            
            Button(action: onContinue) {
                Text(continueButtonText)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .shadow(color: primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.bottom, 30)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.96, green: 0.96, blue: 0.98).ignoresSafeArea())
    }
    
    func localizedString(_ key: String, translations: [String: String]) -> String {
        return translations[selectedLanguage] ?? key
    }
}

// MARK: - Status Selection View
struct InlineStatusSelectionView: View {
    let selectedLanguage: String
    let onStatusSelected: (RefugeeUserType) -> Void // see fix below
   
   
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(statusSelectionTitle)
                .font(.title)
                .bold()
                .padding(.bottom, 10)
            
            StatusOptionCard(
                title: option1Title,
                description: option1Description,
                icon: "questionmark.circle.fill",
                action: {
                    onStatusSelected(.seekingAsylum)
                }
            )
            
            StatusOptionCard(
                title: option2Title,
                description: option2Description,
                icon: "person.fill.questionmark",
                action: {
                    onStatusSelected(.existingAsylumSeeker)
                }
            )
            
            StatusOptionCard(
                title: option3Title,
                description: option3Description,
                icon: "checkmark.shield.fill",
                action: {
                    onStatusSelected(.grantedResidence)
                }
            )
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: Localized Content
    private var statusSelectionTitle: String {
        localizedString("Please choose your current status:", translations: [
            "ar": "الرجاء اختيار حالتك الحالية:",
            "fr": "Veuillez choisir votre statut actuel:",
            "fa": "لطفاً وضعیت فعلی خود را انتخاب کنید:",
            "ku": "تکایە دۆخی ئێستای خۆت هەلبژێرە:",
            "ps": "مهرباني وکړئ خپل اوسنی حالت وټاکئ:",
            "uk": "Будь ласка, оберіть свій поточний статус:",
            "ur": "براہ کرم اپنی موجودہ حیثیت منتخب کریں:"
        ])
    }
    
    private var option1Title: String {
        localizedString("1. Are you planning to seek asylum?", translations: [
            "ar": "1. هل تخطط للتقدم بطلب لجوء؟",
            "fr": "1. Prévoyez-vous de demander l'asile?",
            "fa": "1. آیا قصد درخواست پناهندگی دارید؟",
            "ku": "١. ئایا دەتەوێت داوای پەنابەری بکەیت؟",
            "ps": "1. ایا تاسو د پناه غوښتنې پلان لرئ؟",
            "uk": "1. Ви плануєте подати заяву на притулок?",
            "ur": "1. کیا آپ پناہ کی درخواست دینے کا ارادہ رکھتے ہیں؟"
        ])
    }
    
    private var option1Description: String {
        localizedString("Information about the UK asylum application process", translations: [
            "ar": "معلومات عن عملية التقدم بطلب اللجوء في المملكة المتحدة",
            "fr": "Informations sur le processus de demande d'asile au Royaume-Uni",
            "fa": "اطلاعات در مورد روند درخواست پناهندگی در بریتانیا",
            "ku": "زانیاری دەربارەی پرۆسەی داوای پەنابەری لە شانشینی یەکگرتوو",
            "ps": "په انګلستان کې د پناه غوښتنې پروسې په اړه معلومات",
            "uk": "Інформація про процес подання заяви на притулок у Великій Британії",
            "ur": "برطانیہ میں پناہ کی درخواست کے عمل سے متعلق معلومات"
        ])
    }
    
    private var option2Title: String {
        localizedString("2. Are you an existing asylum seeker?", translations: [
            "ar": "2. هل أنت لاجئ حالي؟",
            "fr": "2. Êtes-vous déjà demandeur d'asile?",
            "fa": "2. آیا شما یک پناهجوی موجود هستید؟",
            "ku": "٢. ئایا پەنابەری ئێستا هەیت؟",
            "ps": "2. ایا تاسو اوسنی پناه غوښتونکی یاست؟",
            "uk": "2. Ви зараз є шукачем притулку?",
            "ur": "2. کیا آپ اس وقت پناہ کے متلاشی ہیں؟"
        ])
    }
    
    private var option2Description: String {
        localizedString("Support for current asylum seekers in the UK", translations: [
            "ar": "الدعم للاجئين الحاليين في المملكة المتحدة",
            "fr": "Soutien pour les demandeurs d'asile actuels au Royaume-Uni",
            "fa": "پشتیبانی برای پناهجویان موجود در بریتانیا",
            "ku": "یارمەتی بۆ پەنابەرانە ئێستا لە شانشینی یەکگرتوو",
            "ps": "په انګلستان کې اوسنیو پناه غوښتونکو ته ملاتړ",
            "uk": "Підтримка для нинішніх шукачів притулку у Великій Британії",
            "ur": "برطانیہ میں موجودہ پناہ کے متلاشیوں کے لیے معاونت"
        ])
    }
    
    private var option3Title: String {
        localizedString("3. Have you been granted a residence permit?", translations: [
            "ar": "3. هل تم منحك تصريح إقامة؟",
            "fr": "3. Avez-vous obtenu un permis de séjour?",
            "fa": "3. آیا به شما اجازه اقامت داده شده است؟",
            "ku": "٣. ئایا مۆڵەتی نیشتەجێبوونت پێدراوە؟",
            "ps": "3. ایا تاسو ته د اقامت اجازه درکړل شوې؟",
            "uk": "3. Вам надали дозвіл на проживання?",
            "ur": "3. کیا آپ کو رہائش کا اجازت نامہ مل چکا ہے؟"
        ])
    }
    
    private var option3Description: String {
        localizedString("Support for residence permit holders in the UK", translations: [
            "ar": "الدعم لحاملي تصاريح الإقامة في المملكة المتحدة",
            "fr": "Soutien pour les titulaires de permis de séjour au Royaume-Uni",
            "fa": "پشتیبانی برای دارندگان اجازه اقامت در بریتانیا",
            "ku": "یارمەتی بۆ کەسانی هەڵسەنگاندنی نیشتەجێبوونیان هەیە لە شانشینی یەکگرتوو",
            "ps": "په انګلستان کې د اقامتي جواز لرونکو لپاره ملاتړ",
            "uk": "Підтримка для власників дозволу на проживання у Великій Британії",
            "ur": "برطانیہ میں رہائش کے اجازت نامے کے حاملین کے لیے معاونت"
        ])
    }
    
    func localizedString(_ key: String, translations: [String: String]) -> String {
        return translations[selectedLanguage] ?? key
    }
    
    struct StatusOptionCard: View {
        let title: String
        let description: String
        let icon: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundColor(.blue)
                        .frame(width: 50)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
        }
    }
}

// MARK: - Asylum Application Guide
struct GuideView: View {
    let selectedLanguage: String
    var onContinue: () -> Void
    
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)
    
    var body: some View {
        GuideContentView(
            selectedLanguage: selectedLanguage,
            title: guideTitle,
            subtitle: guideSubtitle,
            cards: guideCards,
            continueButtonText: continueButtonText,
            onContinue: onContinue,
            primaryColor: primaryColor,
            accentColor: accentColor
        )

    }
    
    // MARK: Localized Content
    private var guideTitle: String {
        localizedString("UK Asylum Application Guide", translations: [
            "ar": "دليل التقدم بطلب اللجوء في المملكة المتحدة",
            "fr": "Guide de demande d'asile au Royaume-Uni",
            "fa": "راهنمای درخواست پناهندگی در بریتانیا",
            "ku": "ڕێنمای داواکردنی پەنابەری لە شانشینی یەکگرتوو",
            "ps": "په انګلستان کې د پناه غوښتنې لارښود",
            "uk": "Посібник з подання заяви на притулок у Великій Британії",
            "ur": "برطانیہ میں پناہ کی درخواست کے لیے رہنما"
        ])
    }
    
    private var guideSubtitle: String {
        localizedString("Essential information about seeking asylum in the UK", translations: [
            "ar": "معلومات أساسية عن التقدم بطلب اللجوء في المملكة المتحدة",
            "fr": "Informations essentielles sur la demande d'asile au Royaume-Uni",
            "fa": "اطلاعات ضروری در مورد درخواست پناهندگی در بریتانیا",
            "ku": "زانیاری گرنگ سەبارەت بە داوای پەنابەری لە شانشینی یەکگرتوو",
            "ps": "په انګلستان کې د پناه غوښتنې اړینې معلومات",
            "uk": "Основна інформація про подання заяви на притулок у Великій Британії",
            "ur": "برطانیہ میں پناہ کی درخواست سے متعلق ضروری معلومات"
        ])
    }
    
    private var guideCards: [GuideCardData] {
        [
            GuideCardData(
                title: card1Title,
                description: card1Description,
                icon: "doc.text.fill",
                linkText: card1LinkText,
                linkURL: "https://www.gov.uk/claim-asylum"
            ),
            GuideCardData(
                title: card2Title,
                description: card2Description,
                icon: "person.2.fill",
                linkText: card2LinkText,
                linkURL: "https://www.refugeecouncil.org.uk"
            ),
            GuideCardData(
                title: card3Title,
                description: card3Description,
                icon: "house.fill",
                linkText: card3LinkText,
                linkURL: "https://www.gov.uk/asylum-support"
            )
        ]
    }
    
    private var card1Title: String {
        localizedString("How to Apply", translations: [
            "ar": "كيفية التقديم",
            "fr": "Comment postuler",
            "fa": "نحوه درخواست",
            "ku": "چۆن داوا بکەیت",
            "ps": "څنګه غوښتنه وکړئ",
            "uk": "Як подати заяву",
            "ur": "درخواست کیسے دیں"
        ])
    }
    
    private var card1Description: String {
        localizedString("Step-by-step guide to the asylum application process", translations: [
            "ar": "دليل خطوة بخطوة لعملية التقدم بطلب اللجوء",
            "fr": "Guide étape par étape du processus de demande d'asile",
            "fa": "راهنمای گام به گام روند درخواست پناهندگی",
            "ku": "ڕێنمای هەنگاوبەهەنگاو بۆ پرۆسەی داوای پەنابەری",
            "ps": "د پناه غوښتنې پروسې مرحلې په مرحلې لارښود",
            "uk": "Покрокова інструкція подання заяви на притулок",
            "ur": "پناہ کی درخواست کے مرحلہ وار طریقہ کار کی رہنمائی"
        ])
    }
    
    private var card1LinkText: String {
        localizedString("Application Process", translations: [
            "ar": "عملية التقديم",
            "fr": "Processus de demande",
            "fa": "فرآیند درخواست",
            "ku": "پرۆسەی داواکاری",
            "ps": "د غوښتنې بهیر",
            "uk": "Процес подання заяви",
            "ur": "درخواست کا عمل"
        ])
    }
    
    private var card2Title: String {
        localizedString("Legal Support", translations: [
            "ar": "الدعم القانوني",
            "fr": "Soutien juridique",
            "fa": "پشتیبانی حقوقی",
            "ku": "یارمەتی یاسایی",
            "ps": "حقوقي ملاتړ",
            "uk": "Юридична підтримка",
            "ur": "قانونی معاونت"
        ])
    }
    
    private var card2Description: String {
        localizedString("Find free legal advice and representation", translations: [
            "ar": "ابحث عن المشورة القانونية المجانية والتمثيل",
            "fr": "Trouver des conseils juridiques gratuits et une représentation",
            "fa": "یافتن مشاوره حقوقی رایگان و نمایندگی",
            "ku": "دۆزینەوەی ڕاوێژکاری یاسایی بەخۆرایی و نمایندەیی",
            "ps": "وړیا حقوقي مشوره او استازیتوب پیدا کړئ",
            "uk": "Знайдіть безкоштовну юридичну допомогу та представництво",
            "ur": "مفت قانونی مشورہ اور نمائندگی حاصل کریں"
        ])
    }
    
    private var card2LinkText: String {
        localizedString("Find Help", translations: [
            "ar": "ابحث عن مساعدة",
            "fr": "Trouver de l'aide",
            "fa": "کمک پیدا کنید",
            "ku": "یارمەتی بدۆزەوە",
            "ps": "مرسته پیدا کړئ",
            "uk": "Знайти допомогу",
            "ur": "مدد تلاش کریں"
        ])
    }
    
    private var card3Title: String {
        localizedString("Accommodation", translations: [
            "ar": "الإقامة",
            "fr": "Hébergement",
            "fa": "اسکان",
            "ku": "جێگای نیشتەجێبوون",
            "ps": "استوګنځای",
            "uk": "Житло",
            "ur": "رہائش"
        ])
    }
    
    private var card3Description: String {
        localizedString("Housing support during your application", translations: [
            "ar": "الدعم السكني أثناء تقديم الطلب",
            "fr": "Soutien au logement pendant votre demande",
            "fa": "پشتیبانی مسکن در طول درخواست شما",
            "ku": "یارمەتی بۆ جێگای نیشتەجێبوون لەکاتی داواکاری",
            "ps": "د غوښتنلیک پر مهال د استوګنې ملاتړ",
            "uk": "Підтримка з житлом під час подання заяви",
            "ur": "درخواست کے دوران رہائش میں معاونت"
        ])
    }
    
    private var card3LinkText: String {
        localizedString("Housing Support", translations: [
            "ar": "الدعم السكني",
            "fr": "Soutien au logement",
            "fa": "پشتیبانی مسکن",
            "ku": "یارمەتی جێگای نیشتەجێبوون",
            "ps": "د استوګنې ملاتړ",
            "uk": "Житлова підтримка",
            "ur": "رہائش کی معاونت"
        ])
    }
    
    private var continueButtonText: String {
        localizedString("Register to Track Your Case", translations: [
            "ar": "سجل لتتبع قضيتك",
            "fr": "Inscrivez-vous pour suivre votre dossier",
            "fa": "برای پیگیری پرونده خود ثبت نام کنید",
            "ku": "خۆت تۆمار بکە بۆ بەدواداچوونی کەیسی خۆت",
            "ps": "د خپل قضیې د تعقیب لپاره ثبت نام وکړئ",
            "uk": "Зареєструйтесь, щоб відстежувати свою справу",
            "ur": "اپنے کیس کو ٹریک کرنے کے لیے رجسٹر کریں"
        ])
    }
    
    func localizedString(_ key: String, translations: [String: String]) -> String {
        return translations[selectedLanguage] ?? key
    }
}

// MARK: - Existing Asylum Seeker Guide
struct ExistingAsylumContentGuideView: View {
    let selectedLanguage: String
    var onContinue: () -> Void
    
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)
    
    var body: some View {
        GuideContentView(
            selectedLanguage: selectedLanguage,
            title: guideTitle,
            subtitle: guideSubtitle,
            cards: guideCards,
            continueButtonText: continueButtonText,
            onContinue: onContinue,
            primaryColor: primaryColor,
            accentColor: accentColor
        )
    }
    
    // MARK: Localized Content
    private var guideTitle: String {
        localizedString("Support for Asylum Seekers", translations: [
            "ar": "الدعم للاجئين",
            "fr": "Soutien aux demandeurs d'asile",
            "fa": "پشتیبانی برای پناهجویان",
            "ku": "یارمەتی بۆ پەنابەران",
            "ps": "د پناه غوښتونکو لپاره ملاتړ",
            "uk": "Підтримка для шукачів притулку",
            "ur": "پناہ کے متلاشیوں کے لیے معاونت"
        ])
    }
    
    private var guideSubtitle: String {
        localizedString("Resources and next steps for current asylum seekers", translations: [
            "ar": "الموارد والخطوات التالية للاجئين الحاليين",
            "fr": "Ressources et prochaines étapes pour les demandeurs d'asile actuels",
            "fa": "منابع و مراحل بعدی برای پناهجویان فعلی",
            "ku": "سەرچاوەکان و هەنگاوە داهاتووان بۆ پەنابەرانە ئێستا",
            "ps": "د اوسنیو پناه غوښتونکو لپاره سرچینې او راتلونکې ګامونه",
            "uk": "Ресурси та наступні кроки для нинішніх шукачів притулку",
            "ur": "موجودہ پناہ کے متلاشیوں کے لیے وسائل اور اگلے اقدامات"
        ])
    }
    
    private var guideCards: [GuideCardData] {
        [
            GuideCardData(
                title: card1Title,
                description: card1Description,
                icon: "clock.fill",
                linkText: card1LinkText,
                linkURL: "https://www.gov.uk/asylum-process"
            ),
            GuideCardData(
                title: card2Title,
                description: card2Description,
                icon: "heart.fill",
                linkText: card2LinkText,
                linkURL: "https://www.redcross.org.uk"
            ),
            GuideCardData(
                title: card3Title,
                description: card3Description,
                icon: "graduationcap.fill",
                linkText: card3LinkText,
                linkURL: "https://www.refugee-action.org.uk/education"
            )
        ]
    }
    
    private var card1Title: String {
        localizedString("Application Status", translations: [
            "ar": "حالة الطلب",
            "fr": "Statut de la demande",
            "fa": "وضعیت درخواست",
            "ku": "دۆخی داواکاری",
            "ps": "د غوښتنلیک حالت",
            "uk": "Статус заявки",
            "ur": "درخواست کی حیثیت"
        ])
    }
    
    private var card1Description: String {
        localizedString("Check the status of your asylum application", translations: [
            "ar": "تحقق من حالة طلب اللجوء الخاص بك",
            "fr": "Vérifier l'état de votre demande d'asile",
            "fa": "وضعیت درخواست پناهندگی خود را بررسی کنید",
            "ku": "دۆخی داوای پەنابەریت بپشکنە",
            "ps": "د خپلې پناه غوښتنې حالت وګورئ",
            "uk": "Перевірте статус вашої заяви на притулок",
            "ur": "اپنی پناہ کی درخواست کی حیثیت چیک کریں"
        ])
    }
    
    private var card1LinkText: String {
        localizedString("Check Status", translations: [
            "ar": "تحقق من الحالة",
            "fr": "Vérifier le statut",
            "fa": "بررسی وضعیت",
            "ku": "پشکنینی دۆخ",
            "ps": "حالت وګورئ",
            "uk": "Перевірити статус",
            "ur": "حیثیت چیک کریں"
        ])
    }
    
    private var card2Title: String {
        localizedString("Healthcare", translations: [
            "ar": "الرعاية الصحية",
            "fr": "Soins de santé",
            "fa": "مراقبت‌های بهداشتی",
            "ku": "تەندروستی",
            "ps": "روغتیايي خدمات",
            "uk": "Охорона здоров'я",
            "ur": "صحت کی دیکھ بھال"
        ])
    }
    
    private var card2Description: String {
        localizedString("Access to NHS services and support", translations: [
            "ar": "الوصول إلى خدمات NHS والدعم",
            "fr": "Accès aux services NHS et au soutien",
            "fa": "دسترسی به خدمات NHS و پشتیبانی",
            "ku": "گەیشتن بە خزمەتگوزاری و یارمەتییەکانی NHS",
            "ps": "د NHS خدماتو او ملاتړ ته لاسرسی",
            "uk": "Доступ до послуг NHS та підтримки",
            "ur": "NHS کی خدمات اور معاونت تک رسائی"
        ])
    }
    
    private var card2LinkText: String {
        localizedString("Healthcare Info", translations: [
            "ar": "معلومات الرعاية الصحية",
            "fr": "Infos santé",
            "fa": "اطلاعات مراقبت‌های بهداشتی",
            "ku": "زانیاری تەندروستی",
            "ps": "د روغتیا معلومات",
            "uk": "Інформація про медичне обслуговування",
            "ur": "صحت سے متعلق معلومات"
        ])
    }
    
    private var card3Title: String {
        localizedString("Education", translations: [
            "ar": "التعليم",
            "fr": "Éducation",
            "fa": "آموزش",
            "ku": "پەروەردە",
            "ps": "زده کړه",
            "uk": "Освіта",
            "ur": "تعلیم"
        ])
    }
    
    private var card3Description: String {
        localizedString("Access to education for you and your family", translations: [
            "ar": "الوصول إلى التعليم لك ولعائلتك",
            "fr": "Accès à l'éducation pour vous et votre famille",
            "fa": "دسترسی به آموزش برای شما و خانواده شما",
            "ku": "دەستگەیشتن بە خوێندن بۆ تۆ و خێزانەکەت",
            "ps": "تاسو او ستاسو کورنۍ ته زده کړې ته لاسرسی",
            "uk": "Доступ до освіти для вас і вашої родини",
            "ur": "آپ اور آپ کے خاندان کے لیے تعلیم تک رسائی"
        ])
    }
    
    private var card3LinkText: String {
        localizedString("Learning Opportunities", translations: [
            "ar": "فرص التعلم",
            "fr": "Opportunités d'apprentissage",
            "fa": "فرصت‌های یادگیری",
            "ku": "دەروازەکانی فێربوون",
            "ps": "د زده کړې فرصتونه",
            "uk": "Можливості навчання",
            "ur": "سیکھنے کے مواقع"
        ])
    }
    
    private var continueButtonText: String {
        localizedString("Register for Next Steps", translations: [
            "ar": "سجل للخطوات التالية",
            "fr": "Inscrivez-vous pour les prochaines étapes",
            "fa": "برای مراحل بعدی ثبت نام کنید",
            "ku": "خۆت تۆمار بکە بۆ هەنگاوەکانی داهاتوو",
            "ps": "د راتلونکو ګامونو لپاره نوم ثبت کړئ",
            "uk": "Зареєструйтесь для наступних кроків",
            "ur": "اگلے مراحل کے لیے رجسٹر کریں"
        ])
    }
    
    func localizedString(_ key: String, translations: [String: String]) -> String {
        return translations[selectedLanguage] ?? key
    }
}

// MARK: - Residence Permit Guide
struct GrantedResidenceGuideView: View {
    let selectedLanguage: String
    var onContinue: () -> Void
    
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)
    
    var body: some View {
        GuideContentView(
            selectedLanguage: selectedLanguage,
            title: guideTitle,
            subtitle: guideSubtitle,
            cards: guideCards,
            continueButtonText: continueButtonText,
            onContinue: onContinue,
            primaryColor: primaryColor,
            accentColor: accentColor
        )
    }
    
    // MARK: Localized Content
    private var guideTitle: String {
        localizedString("Support After Receiving Leave to Remain", translations: [
            "ar": "الدعم بعد الحصول على تصريح الإقامة",
            "fr": "Soutien après l'obtention du permis de séjour",
            "fa": "پشتیبانی پس از دریافت اجازه اقامت",
            "ku": "یارمەتی دوای وەرگرتنی مۆڵەتی نیشتەجێبوون",
            "ps": "د اقامت له ترلاسه کولو وروسته ملاتړ",
            "uk": "Підтримка після отримання дозволу на проживання",
            "ur": "رہائش کی اجازت حاصل کرنے کے بعد معاونت"
        ])
    }
    
    private var guideSubtitle: String {
        localizedString("Essentials to start your new life in the UK", translations: [
            "ar": "موارد ضرورية لبدء حياتك الجديدة في المملكة المتحدة",
            "fr": "Essentiels pour commencer votre nouvelle vie au Royaume-Uni",
            "fa": "ملزومات برای شروع زندگی جدید شما در بریتانیا",
            "ku": "شتە گرنگەکان بۆ دەستپێکردنی ژیانی نوێ لە شانشینی یەکگرتوو",
            "ps": "په انګلستان کې د خپل نوي ژوند پیل لپاره اړین توکي",
            "uk": "Необхідне для початку нового життя у Великій Британії",
            "ur": "برطانیہ میں نئی زندگی شروع کرنے کے لیے ضروری چیزیں"
        ])
    }
    
    private var guideCards: [GuideCardData] {
        [
            GuideCardData(
                title: card1Title,
                description: card1Description,
                icon: "sterlingsign.circle.fill",
                linkText: card1LinkText,
                linkURL: "https://www.gov.uk/universal-credit"
            ),
            GuideCardData(
                title: card2Title,
                description: card2Description,
                icon: "house.fill",
                linkText: card2LinkText,
                linkURL: "https://www.gov.uk/apply-for-council-housing"
            ),
            GuideCardData(
                title: card3Title,
                description: card3Description,
                icon: "banknote.fill",
                linkText: card3LinkText,
                linkURL: "https://www.gov.uk/integration-loan"
            ),
            GuideCardData(
                title: card4Title,
                description: card4Description,
                icon: "briefcase.fill",
                linkText: card4LinkText,
                linkURL: "https://www.gov.uk/jobsearch"
            ),
            GuideCardData(
                title: card5Title,
                description: card5Description,
                icon: "stethoscope",
                linkText: card5LinkText,
                linkURL: "https://www.nhs.uk/nhs-services/gps/how-to-register-with-a-gp-surgery/"
            ),
            GuideCardData(
                title: card6Title,
                description: card6Description,
                icon: "book.fill",
                linkText: card6LinkText,
                linkURL: "https://www.gov.uk/english-language"
            )
        ]
    }
    
    private var card1Title: String {
        localizedString("Universal Credit", translations: [
            "ar": "الائتمان الشامل",
            "fr": "Crédit Universel",
            "fa": "اعتبار جهانی",
            "ku": "قەرزی گشتی",
            "ps": "یونیورسل کریډیټ",
            "uk": "Універсальний кредит",
            "ur": "یونیورسل کریڈٹ"
        ])
    }
    
    private var card1Description: String {
        localizedString("Apply for monthly financial support", translations: [
            "ar": "تقديم طلب للحصول على الدعم المالي الشهري",
            "fr": "Demander un soutien financier mensuel",
            "fa": "درخواست حمایت مالی ماهانه",
            "ku": "داواکردن بۆ پشتگیری دارایی مانگانە",
            "ps": "د میاشتني مالي ملاتړ لپاره غوښتنه وکړئ",
            "uk": "Подайте заявку на щомісячну фінансову допомогу",
            "ur": "ماہانہ مالی معاونت کے لیے درخواست دیں"
        ])
    }
    
    private var card1LinkText: String {
        localizedString("Apply Now", translations: [
            "ar": "تقديم طلب الآن",
            "fr": "Postuler maintenant",
            "fa": "اکنون درخواست دهید",
            "ku": "ئێستا داوا بکە",
            "ps": "اوس غوښتنه وکړئ",
            "uk": "Подати заявку зараз",
            "ur": "ابھی درخواست دیں"
        ])
    }
    
    private var card2Title: String {
        localizedString("Council Housing", translations: [
            "ar": "السكن البلدي",
            "fr": "Logement social",
            "fa": "مسکن شورایی",
            "ku": "خانووبەرەکانی شارەوانی",
            "ps": "د ښاروالۍ کورونه",
            "uk": "Соціальне житло",
            "ur": "کونسل رہائش"
        ])
    }
    
    private var card2Description: String {
        localizedString("Support to help you find housing", translations: [
            "ar": "الدعم لمساعدتك في العثور على سكن",
            "fr": "Soutien pour vous aider à trouver un logement",
            "fa": "پشتیبانی برای کمک به شما در یافتن مسکن",
            "ku": "یارمەتی بۆ دۆزینەوەی شوێنی نیشتەجێبوون",
            "ps": "د استوګنې موندلو کې مرسته",
            "uk": "Підтримка у пошуку житла",
            "ur": "رہائش تلاش کرنے میں مدد"
        ])
    }
    
    private var card2LinkText: String {
        localizedString("Find Housing", translations: [
            "ar": "البحث عن سكن",
            "fr": "Trouver un logement",
            "fa": "یافتن مسکن",
            "ku": "شوێن بدۆزەوە",
            "ps": "استوګنځای پیدا کړئ",
            "uk": "Знайти житло",
            "ur": "رہائش تلاش کریں"
        ])
    }
    
    private var card3Title: String {
        localizedString("Integration Loan", translations: [
            "ar": "قرض الاندماج",
            "fr": "Prêt d'intégration",
            "fa": "وام ادغام",
            "ku": "قەرزی تێکەڵبوون",
            "ps": "د یوځای کېدو پور",
            "uk": "Кредит на інтеграцію",
            "ur": "انضمام قرض"
        ])
    }
    
    private var card3Description: String {
        localizedString("Loan for housing deposits or job training", translations: [
            "ar": "قرض لوودائع السكن أو التدريب الوظيفي",
            "fr": "Prêt pour dépôts de logement ou formation professionnelle",
            "fa": "وام برای سپرده مسکن یا آموزش شغلی",
            "ku": "قەرز بۆ پەسەندی خانوو یان فێرکاری کار",
            "ps": "د استوګنې زیرمې یا مسلکي روزنې لپاره پور",
            "uk": "Кредит на житло або професійне навчання",
            "ur": "رہائش کی ڈپازٹ یا تربیت کے لیے قرض"
        ])
    }
    
    private var card3LinkText: String {
        localizedString("Loan Details", translations: [
            "ar": "تفاصيل القرض",
            "fr": "Détails du prêt",
            "fa": "جزئیات وام",
            "ku": "وردەکارییەکانی قەرز",
            "ps": "د پور جزئیات",
            "uk": "Деталі кредиту",
            "ur": "قرض کی تفصیلات"
        ])
    }
    
    private var card4Title: String {
        localizedString("Jobseeker Support", translations: [
            "ar": "دعم الباحثين عن عمل",
            "fr": "Soutien aux demandeurs d'emploi",
            "fa": "پشتیبانی جویندگان کار",
            "ku": "یارمەتی بۆ گەڕان بەدوای کار",
            "ps": "د کار لټونکو ملاتړ",
            "uk": "Підтримка шукачів роботи",
            "ur": "ملازمت تلاش کرنے والوں کے لیے معاونت"
        ])
    }
    
    private var card4Description: String {
        localizedString("Training programs and job listings", translations: [
            "ar": "برامج التدريب وقوائم الوظائف",
            "fr": "Programmes de formation et offres d'emploi",
            "fa": "برنامه های آموزشی و فهرست های شغلی",
            "ku": "پڕۆگرامەکانی فێرکاری و لیستی کارەکان",
            "ps": "د روزنې پروګرامونه او دندو لیست",
            "uk": "Програми навчання та вакансії",
            "ur": "تربیتی پروگرام اور ملازمت کی فہرستیں"
        ])
    }
    
    private var card4LinkText: String {
        localizedString("Job Search", translations: [
            "ar": "البحث عن عمل",
            "fr": "Recherche d'emploi",
            "fa": "جستجوی شغل",
            "ku": "گەڕان بەدوای کار",
            "ps": "د کار لټون",
            "uk": "Пошук роботи",
            "ur": "ملازمت تلاش کریں"
        ])
    }
    
    private var card5Title: String {
        localizedString("NHS Healthcare", translations: [
            "ar": "الرعاية الصحية من NHS",
            "fr": "Soins de santé NHS",
            "fa": "مراقبت‌های بهداشتی NHS",
            "ku": "چاودێری تەندروستیی NHS",
            "ps": "د NHS روغتیايي خدمتونه",
            "uk": "Медичне обслуговування NHS",
            "ur": "NHS صحت کی دیکھ بھال"
        ])
    }
    
    private var card5Description: String {
        localizedString("Register with a GP for free healthcare", translations: [
            "ar": "سجل مع طبيب عام للرعاية الصحية المجانية",
            "fr": "Inscrivez-vous auprès d'un médecin pour des soins gratuits",
            "fa": "با یک پزشک عمومی ثبت نام کنید تا مراقبت های بهداشتی رایگان دریافت کنید",
            "ku": "خۆت تۆمار بکە لە پزیشکی گشتی بۆ چاودێری تەندروستی بەخۆرایی",
            "ps": "د وړیا روغتیايي خدمتونو لپاره له ډاکټر سره نوم لیکنه وکړئ",
            "uk": "Зареєструйтесь у терапевта для безкоштовного лікування",
            "ur": "مفت صحت کی سہولت کے لیے جی پی کے ساتھ رجسٹر کریں"
        ])
    }
    
    private var card5LinkText: String {
        localizedString("Register with GP", translations: [
            "ar": "سجل مع طبيب",
            "fr": "S'inscrire chez un médecin",
            "fa": "ثبت نام با پزشک عمومی",
            "ku": "خۆت تۆمار بکە لە پزیشک",
            "ps": "له ډاکټر سره نوم ثبت کړئ",
            "uk": "Зареєструватись у лікаря",
            "ur": "جی پی کے ساتھ رجسٹر کریں"
        ])
    }
    
    private var card6Title: String {
        localizedString("English Language Courses", translations: [
            "ar": "دورات اللغة الإنجليزية",
            "fr": "Cours d'anglais",
            "fa": "دوره‌های زبان انگلیسی",
            "ku": "کورسەکانی زمانی ئینگلیزی",
            "ps": "د انګلیسي ژبې کورسونه",
            "uk": "Курси англійської мови",
            "ur": "انگریزی زبان کے کورسز"
        ])
    }
    
    private var card6Description: String {
        localizedString("Free English lessons to help with integration", translations: [
            "ar": "دروس مجانية في اللغة الإنجليزية للمساعدة في الاندماج",
            "fr": "Cours d'anglais gratuits pour faciliter l'intégration",
            "fa": "دروس رایگان انگلیسی برای کمک به ادغام",
            "ku": "وانەی زمانی ئینگلیزی بەخۆرایی بۆ یارمەتی لە تێکەڵبوون",
            "ps": "د یوځای کېدو لپاره وړيا انګليسي درسونه",
            "uk": "Безкоштовні уроки англійської для інтеграції",
            "ur": "انضمام میں مدد کے لیے مفت انگریزی اسباق"
        ])
    }
    
    private var card6LinkText: String {
        localizedString("Find Courses", translations: [
            "ar": "البحث عن دورات",
            "fr": "Trouver des cours",
            "fa": "یافتن دوره‌ها",
            "ku": "کورس بدۆزەوە",
            "ps": "کورسونه پیدا کړئ",
            "uk": "Знайти курси",
            "ur": "کورسز تلاش کریں"
        ])
    }
    
    private var continueButtonText: String {
        localizedString("Continue to Registration", translations: [
            "ar": "المتابعة إلى التسجيل",
            "fr": "Continuer vers l'inscription",
            "fa": "ادامه به ثبت نام",
            "ku": "بەرەو تۆمارکردن بەردەوام بە",
            "ps": "تاسو د ثبت نام ته دوام ورکړئ",
            "uk": "Перейти до реєстрації",
            "ur": "رجسٹریشن کی طرف جاری رکھیں"
        ])
    }
    
    func localizedString(_ key: String, translations: [String: String]) -> String {
        return translations[selectedLanguage] ?? key
    }
}

// MARK: - Shared Components
struct GuideContentCardData: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let linkText: String?
    let linkURL: String?
}

struct UserGuideContentView: View {
    let selectedLanguage: String
    let title: String
    let subtitle: String
    let cards: [GuideCardData]
    let continueButtonText: String
    var onContinue: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                
                VStack(spacing: 20) {
                    ForEach(cards) { card in
                        GuideCard(
                            title: card.title,
                            description: card.description,
                            icon: card.icon,
                            linkText: card.linkText,
                            linkURL: card.linkURL
                        )
                    }
                }
                
                continueButton
            }
            .padding()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding(.top, 8)
            
            Text(subtitle)
                .font(.title3)
                .foregroundColor(.secondary)
            
            Divider()
                .padding(.vertical, 8)
        }
    }
    
    private var continueButton: some View {
        Button(action: onContinue) {
            Text(continueButtonText)
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.top, 16)
        }
    }
}

struct GuideCard: View {
    let title: String
    let description: String
    let icon: String
    var linkText: String?
    var linkURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.accentColor)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let linkText = linkText, let linkURL = linkURL {
                        Link(destination: URL(string: linkURL)!) {
                            HStack(spacing: 4) {
                                Text(linkText)
                                Image(systemName: "arrow.up.forward")
                            }
                            .font(.callout)
                            .foregroundColor(.accentColor)
                            .padding(.top, 4)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Preview
struct LeaveToRemainGuideView_Previews: PreviewProvider {
    static var previews: some View {
        LeaveToRemainGuideView(
            selectedLanguage: "en",
            primaryColor: Color(red: 0.07, green: 0.36, blue: 0.65),
            onContinue: {}
        )
        .environment(\.locale, .init(identifier: "en"))

        LeaveToRemainGuideView(
            selectedLanguage: "ar",
            primaryColor: Color(red: 0.07, green: 0.36, blue: 0.65),
            onContinue: {}
        )
        .environment(\.locale, .init(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
    }
}
