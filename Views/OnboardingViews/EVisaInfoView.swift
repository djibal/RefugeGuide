//
//  EVisaInfoView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//


import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct EVisaInfoView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    
       // MARK: - UI Constants
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    
    private let cardBackground = Color.white

    var body: some View {
        TopAlignedScrollView { // Replace ScrollView by TopAlignedScrollView
            VStack(alignment: .leading, spacing: 25) {
                // Header
                VStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(primaryColor.opacity(0.1))
                            .frame(height: 120)
                        
                        Image(systemName: "doc.richtext.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(primaryColor)
                    }
                    
                    Text(title)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(primaryColor)
                }
                
                // Introduction
                InfoCard(
                    title: "",
                    content: intro1,
                    icon: "info.circle.fill",
                    color: primaryColor
                )
                
                // Benefits
                InfoCard(
                    title: whyTitle,
                    content: "",
                    icon: "checkmark.shield.fill",
                    color: accentColor
                )
                
                VStack(alignment: .leading, spacing: 15) {
                    BenefitItem(icon: "lock.shield", text: benefit1, color: primaryColor)
                    BenefitItem(icon: "globe", text: benefit2, color: accentColor)
                    BenefitItem(icon: "doc.text", text: benefit3, color: primaryColor)
                    BenefitItem(icon: "airplane.departure", text: benefit4, color: accentColor)
                    BenefitItem(icon: "person.2", text: benefit5, color: primaryColor)
                }
                .padding()
                .background(cardBackground)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                
                // How To
                InfoCard(
                    title: howTitle,
                    content: "",
                    icon: "questionmark.circle.fill",
                    color: accentColor
                )
                
                VStack(alignment: .leading, spacing: 15) {
                    HowToStep(number: "1", text: how1, color: primaryColor)
                    HowToStep(number: "2", text: how2, color: accentColor)
                    HowToStep(number: "3", text: how3, color: primaryColor)
                }
                .padding()
                .background(cardBackground)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                
                // Actions
                VStack(spacing: 15) {
                    Link(destination: URL(string: "https://www.gov.uk/view-prove-immigration-status")!) {
                        ActionButton(
                            title: portalButton,
                            icon: "arrow.up.forward.square.fill",
                            color: primaryColor
                        )
                    }
                }
                .padding(.vertical, 10)
                
                // Note
                Text(note)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
            }
            .padding()
            .background(backgroundColor.ignoresSafeArea())
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
   
    // MARK: - Localized Content

    private var title: String {
        switch selectedLanguage {
        case "ar": return "معلومات التأشيرة الإلكترونية"
        case "fr": return "Informations sur eVisa"
        case "fa": return "اطلاعات ویزای الکترونیکی"
        default: return "eVisa Information"
        }
    }

    private var intro1: String {
        switch selectedLanguage {
        case "ar": return "التأشيرة الإلكترونية (eVisa) هي سجل رقمي آمن لحالة الهجرة الخاصة بك في المملكة المتحدة."
        case "fr": return "Un eVisa est un enregistrement numérique sécurisé de votre statut d'immigration au Royaume-Uni."
        case "fa": return "ویزای الکترونیکی (eVisa) یک سابقه دیجیتال امن از وضعیت مهاجرت شما در بریتانیا است."
        default: return "An eVisa is a secure, digital record of your UK immigration status."
        }
    }

    private var intro2: String {
        switch selectedLanguage {
        case "ar": return "يمكنك استخدام التأشيرة الإلكترونية لإثبات حالتك لأصحاب العمل، وموفري الإسكان، والخدمات العامة."
        case "fr": return "Vous pouvez utiliser l'eVisa pour prouver votre statut aux employeurs, aux fournisseurs de logement et aux services publics."
        case "fa": return "می‌توانید از ویزای الکترونیکی برای اثبات وضعیت خود به کارفرمایان، ارائه‌دهندگان مسکن و خدمات عمومی استفاده کنید."
        default: return "You can use your eVisa to prove your status to employers, housing providers, and public services."
        }
    }
    
    
    
    private var intro3: String {
        switch selectedLanguage {
        case "ar": return "يمكنك استخدام التأشيرة الإلكترونية لإثبات حالتك لأصحاب العمل، وموفري الإسكان، والخدمات العامة."
        case "fr": return "Vous pouvez utiliser l'eVisa pour prouver votre statut aux employeurs, aux fournisseurs de logement et aux services publics."
        case "fa": return "می‌توانید از ویزای الکترونیکی برای اثبات وضعیت خود به کارفرمایان، ارائه‌دهندگان مسکن و خدمات عمومی استفاده کنید."
        default: return "You can use your eVisa to prove your status to employers, housing providers, and public services."
        }
    }

    private var whyTitle: String {
        switch selectedLanguage {
        case "ar": return "لماذا تعتبر التأشيرة الإلكترونية مهمة؟"
        case "fr": return "Pourquoi l'eVisa est-il important ?"
        case "fa": return "چرا ویزای الکترونیکی مهم است؟"
        default: return "Why is the eVisa important?"
        }
    }

    private var benefit1: String {
        switch selectedLanguage {
        case "ar": return "إثبات فوري للحالة عبر الإنترنت"
        case "fr": return "Preuve instantanée du statut en ligne"
        case "fa": return "اثبات آنی وضعیت به صورت آنلاین"
        default: return "Instant online proof of status"
        }
    }
    private var benefit2: String {
        switch selectedLanguage {
        case "ar": return "آمن وسهل الوصول إليه"
        case "fr": return "Sécurisé et facilement accessible"
        case "fa": return "ایمن و در دسترس آسان"
        default: return "Secure and easily accessible"
        }
    }
    private var benefit3: String {
        switch selectedLanguage {
        case "ar": return "لا حاجة إلى مستندات مادية"
        case "fr": return "Aucun besoin de documents physiques"
        case "fa": return "بدون نیاز به مدارک فیزیکی"
        default: return "No need for physical documents"
        }
    }
    private var benefit4: String {
        switch selectedLanguage {
        case "ar": return "يسهل السفر من وإلى المملكة المتحدة"
        case "fr": return "Facilite les voyages depuis et vers le Royaume-Uni"
        case "fa": return "سفر آسان‌تر از/به بریتانیا"
        default: return "Eases travel in and out of the UK"
        }
    }
    private var benefit5: String {
        switch selectedLanguage {
        case "ar": return "يساعد في الوصول إلى الحقوق والخدمات"
        case "fr": return "Aide à accéder aux droits et services"
        case "fa": return "دسترسی به حقوق و خدمات را تسهیل می‌کند"
        default: return "Helps access rights and services"
        }
    }

    private var howTitle: String {
        switch selectedLanguage {
        case "ar": return "كيف تحصل على تأشيرة إلكترونية؟"
        case "fr": return "Comment obtenir un eVisa ?"
        case "fa": return "چگونه ویزای الکترونیکی بگیرید؟"
        default: return "How to get your eVisa?"
        }
    }

    private var how1: String {
        switch selectedLanguage {
        case "ar": return "قم بإنشاء حساب UKVI عبر الإنترنت."
        case "fr": return "Créez un compte UKVI en ligne."
        case "fa": return "در UKVI یک حساب آنلاین ایجاد کنید."
        default: return "Create a UKVI online account."
        }
    }
    private var how2: String {
        switch selectedLanguage {
        case "ar": return "اربط حالتك بحسابك باستخدام رقم BRP أو رقم طلبك."
        case "fr": return "Liez votre statut à votre compte avec votre numéro BRP ou de demande."
        case "fa": return "وضعیت خود را با شماره BRP یا شماره درخواستتان پیوند دهید."
        default: return "Link your status using your BRP number or application number."
        }
    }
    private var how3: String {
        switch selectedLanguage {
        case "ar": return "قم بتحديث تفاصيلك ومشاركة إثبات الحالة بسهولة."
        case "fr": return "Mettez à jour vos informations et partagez votre statut facilement."
        case "fa": return "جزئیات خود را به‌روزرسانی کنید و اثبات وضعیتتان را به‌راحتی به اشتراک بگذارید."
        default: return "Update your details and share your status easily."
        }
    }

    private var portalButton: String {
        switch selectedLanguage {
        case "ar": return "افتح بوابة التأشيرة الإلكترونية"
        case "fr": return "Ouvrir le portail eVisa"
        case "fa": return "باز کردن پورتال ویزای الکترونیکی"
        default: return "Open the eVisa Portal"
        }
    }

    private var note: String {
        switch selectedLanguage {
        case "ar": return "ملاحظة: لا يزال بعض الأشخاص يتلقون مستندات مادية بجانب التأشيرة الإلكترونية."
        case "fr": return "Remarque : certaines personnes reçoivent toujours des documents physiques en plus de leur eVisa."
        case "fa": return "توجه: برخی افراد هنوز اسناد فیزیکی در کنار ویزای الکترونیکی خود دریافت می‌کنند."
        default: return "Note: Some individuals still receive physical documents alongside their eVisa."
        }
    }

    // Add other computed properties here (whyTitle, benefit1, benefit2, benefit3, benefit4, benefit5, howTitle, how1, how2, how3, portalButton, note)
    // ... truncated for brevity, already shown in previous message ...

       
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
               }
               .padding(.vertical, 3)
           }
       }
       
       struct HowToStep: View {
           let number: String
           let text: String
           let color: Color
           
           var body: some View {
               HStack(alignment: .top) {
                   ZStack {
                       Circle()
                           .fill(color.opacity(0.1))
                           .frame(width: 30, height: 30)
                       
                       Text(number)
                           .font(.subheadline)
                           .bold()
                           .foregroundColor(color)
                   }
                   
                   Text(text)
                       .font(.subheadline)
                       .padding(.leading, 10)
               }
               .padding(.vertical, 5)
           }
       }
    
    struct InfoCard: View {
        let title: String
        let content: String
        let icon: String
        let color: Color
        let subtitle: String?
        let linkText: String?
        let linkURL: String?
        let background: Color

        init(
            title: String,
            content: String,
            icon: String,
            color: Color,
            subtitle: String? = nil,
            linkText: String? = nil,
            linkURL: String? = nil,
            background: Color = Color(.systemBackground) // default fallback
        ) {
            self.title = title
            self.content = content
            self.icon = icon
            self.color = color
            self.subtitle = subtitle
            self.linkText = linkText
            self.linkURL = linkURL
            self.background = background
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 4) {
                        if !title.isEmpty {
                            Text(title).font(.headline)
                        }
                        if let subtitle = subtitle {
                            Text(subtitle).font(.subheadline).foregroundColor(AppColors.textSecondary)

                        }
                    }
                }
                Text(content).font(.body)
                if let link = linkText, let urlString = linkURL, let url = URL(string: urlString) {
                    Link(link, destination: url)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(background)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
    }

    
    
       
       struct ActionButton: View {
           let title: String
           let icon: String
           let color: Color
           
           var body: some View {
               HStack {
                   Image(systemName: icon)
                       .font(.headline)
                   Text(title)
                       .fontWeight(.medium)
                   Spacer()
                   Image(systemName: "arrow.up.forward")
               }
               .padding()
               .foregroundColor(.white)
               .background(AppColors.primary)
               .background(color)
               .cornerRadius(12)
           }
       }
   }

struct EVisaInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EVisaInfoView()
        }
    }
}

