//
//  ExistingAsylumVerificationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct ExistingAsylumVerificationView: View {
    var onVerificationComplete: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    @State private var referenceNumber = ""
    @State private var isVerified = false
    @State private var showError = false
    @State private var isLoading = false
    
    // MARK: - UI Constants
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    
    
    private let cardBackground = Color.white
    

    // MARK: - Localized Texts and Labels
    private var verificationTitle: String {
        switch selectedLanguage {
        case "ar": return "تحقق من مرجع اللجوء الخاص بك"
        case "fr": return "Vérifiez votre numéro de demande d'asile"
        case "fa": return "شماره پرونده پناهندگی خود را تأیید کنید"
        case "ur": return "اپنے اسائلم ریفرنس کی تصدیق کریں"
        case "ps": return "ستاسو د پناه غوښتنې مراجعې تایید کړئ"
        case "uk": return "Підтвердьте ваш номер справи про притулок"
        case "ku": return "Referansa penaberiyê xwe piştrast bikin"
        default: return "Verify Your Asylum Reference"
        }
    }

    private var verificationDescription: String {
        switch selectedLanguage {
        case "ar": return "يرجى إدخال رقم طلب اللجوء الفريد (UAN) للتحقق من حالتك."
        case "fr": return "Veuillez entrer votre numéro unique de demande d'asile (UAN) pour vérifier votre statut."
        case "fa": return "لطفاً شماره منحصر به فرد درخواست پناهندگی (UAN) خود را وارد کنید تا وضعیت شما بررسی شود."
        case "ur": return "براہ کرم اپنے منفرد اسائلم درخواست نمبر (UAN) درج کریں تاکہ آپ کی حیثیت کی تصدیق ہو سکے۔"
        case "ps": return "مهرباني وکړئ خپل یوازینی د پناه غوښتنې شمېره (UAN) دننه کړئ تر څو ستاسو حالت تایید شي."
        case "uk": return "Будь ласка, введіть свій унікальний номер справи про притулок (UAN) для підтвердження статусу."
        case "ku": return "Ji kerema xwe Hejmara Serlêdana Penaberiyê ya Taybet (UAN) binivîse da ku rewşê we were kontrol kirin."
        default: return "Please enter your Unique Application Number (UAN) to verify your status."
        }
    }

    private var uanLabel: String {
        switch selectedLanguage {
        case "ar": return "رقم UAN"
        case "fr": return "Numéro UAN"
        case "fa": return "شماره UAN"
        case "ur": return "UAN نمبر"
        case "ps": return "د UAN شمېره"
        case "uk": return "Номер UAN"
        case "ku": return "Hejmara UAN"
        default: return "UAN Number"
        }
    }

    private var uanPlaceholder: String {
        switch selectedLanguage {
        case "ar": return "أدخل رقم UAN الخاص بك"
        case "fr": return "Entrez votre numéro UAN"
        case "fa": return "شماره UAN خود را وارد کنید"
        case "ur": return "اپنا UAN نمبر درج کریں"
        case "ps": return "خپل د UAN شمېره دننه کړئ"
        case "uk": return "Введіть свій номер UAN"
        case "ku": return "Hejmara UAN xwe binivîse"
        default: return "Enter your UAN"
        }
    }

    private var uanError: String {
        showError ? (
            selectedLanguage == "ar" ? "رقم UAN غير صالح أو غير معروف."
            : selectedLanguage == "fr" ? "Numéro UAN invalide ou inconnu."
            : selectedLanguage == "fa" ? "شماره UAN نامعتبر یا ناشناس است."
            : selectedLanguage == "ur" ? "UAN نمبر غلط یا نامعلوم ہے۔"
            : selectedLanguage == "ps" ? "UAN شمېره ناسم یا نه پېژندل شوې ده."
            : selectedLanguage == "uk" ? "Недійсний або невідомий номер UAN."
            : selectedLanguage == "ku" ? "Hejmara UAN nederbasdar an nenas e."
            : "Invalid or unrecognized UAN."
        ) : ""
    }

    private var verifyButtonText: String {
        switch selectedLanguage {
        case "ar": return "تحقق"
        case "fr": return "Vérifier"
        case "fa": return "تأیید"
        case "ur": return "تصدیق کریں"
        case "ps": return "تایید کړئ"
        case "uk": return "Підтвердити"
        case "ku": return "Piştrast bikin"
        default: return "Verify"
        }
    }

    private var viewEVisaButtonText: String {
        switch selectedLanguage {
        case "ar": return "عرض التأشيرة الإلكترونية"
        case "fr": return "Voir l'eVisa"
        case "fa": return "مشاهده eVisa"
        case "ur": return "eVisa دیکھیں"
        case "ps": return "eVisa وګورئ"
        case "uk": return "Переглянути eVisa"
        case "ku": return "eVisa bibînin"
        default: return "View eVisa"
        }
    }

    private var skipButtonText: String {
        switch selectedLanguage {
        case "ar": return "تخطي الآن"
        case "fr": return "Passer pour l’instant"
        case "fa": return "فعلاً رد شو"
        case "ur": return "ابھی چھوڑ دیں"
        case "ps": return "اوس پرېږدئ"
        case "uk": return "Пропустити поки що"
        case "ku": return "Niha bigerîne"
        default: return "Skip for now"
        }
    }

    private var uanHelpTitle: String {
        switch selectedLanguage {
        case "ar": return "ما هو رقم UAN؟"
        case "fr": return "Qu'est-ce que le UAN ?"
        case "fa": return "UAN چیست؟"
        case "ur": return "UAN کیا ہے؟"
        case "ps": return "UAN څه شی دی؟"
        case "uk": return "Що таке UAN?"
        case "ku": return "UAN çi ye?"
        default: return "What is a UAN?"
        }
    }

    private var uanHelpDescription: String {
        switch selectedLanguage {
        case "ar": return "رقم الطلب الفريد (UAN) يتم تزويدك به من قبل وزارة الداخلية البريطانية في مراسلات اللجوء."
        case "fr": return "Le numéro UAN est fourni par le ministère britannique de l'intérieur dans les lettres liées à l'asile."
        case "fa": return "شماره درخواست منحصر به فرد (UAN) توسط وزارت کشور بریتانیا در مکاتبات پناهندگی ارائه می‌شود."
        case "ur": return "یُو اے این (UAN) ایک منفرد نمبر ہے جو برطانوی وزارت داخلہ کی جانب سے دیا جاتا ہے۔"
        case "ps": return "UAN یوه یوازینی شمېره ده چې د بریتانیا د کورنیو چارو وزارت له لورې درکړل شوې."
        case "uk": return "UAN — це унікальний номер, наданий Міністерством внутрішніх справ Великобританії у зв’язку з притулком."
        case "ku": return "UAN hejmarek taybet e ku ji hêla Wezareta Hundirê ya Brîtanîyê ve di nameyên penaberiyê de tê dayîn."
        default: return "Your Unique Application Number (UAN) is provided by the UK Home Office in asylum correspondence."
        }
    }
    // MARK: - Localized Content
    
    private var verificationReferenceNumber: String {
        switch selectedLanguage {
        case "ar": return "التحقق من رقم المرجع"
        case "fr": return "Vérification du numéro de référence"
        case "fa": return "تأیید شماره مرجع"
        default: return "Reference Number Verification"
        }
    }
    
    var body: some View {
        TopAlignedScrollView {  // Replace ScrollView by TopAlignedScrollView

               VStack(spacing: 30) {
                   // Header with UK flag colors
                   VStack(spacing: 15) {
                       Text(verificationTitle)
                           .font(.title2)
                           .bold()
                           .multilineTextAlignment(.center)
                           .foregroundColor(primaryColor)
                           .padding(.top, 20)
                       
                       Text(verificationDescription)
                           .font(.body)
                           .multilineTextAlignment(.center)
                           .foregroundColor(.secondary)
                           .padding(.horizontal, 20)
                   }
                   
                   // UAN Input Card
                   VStack(alignment: .leading, spacing: 12) {
                       Text(uanLabel.uppercased())
                           .font(.caption)
                           .foregroundColor(.secondary)
                           .padding(.top, 5)
                       
                       TextField(uanPlaceholder, text: $referenceNumber)
                           .padding()
                           .background(cardBackground)
                           .cornerRadius(10)
                           .overlay(
                               RoundedRectangle(cornerRadius: 10)
                                   .stroke(showError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                           )
                           .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                       
                       if showError {
                           Text(uanError)
                               .font(.footnote)
                               .foregroundColor(.red)
                               .transition(.opacity)
                       }
                   }
                   .padding()
                   .background(cardBackground)
                   .cornerRadius(15)
                   .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                   
                   // Verification Button
                   if isLoading {
                       ProgressView()
                           .padding()
                           .scaleEffect(1.5)
                   } else {
                       Button(action: verifyReference) {
                           Text(verifyButtonText)
                               .font(.headline)
                               .foregroundColor(.white)
                               .background(AppColors.primary)
                               .frame(maxWidth: .infinity)
                               .padding()
                               .background(primaryColor)
                               .cornerRadius(12)
                               .padding(.horizontal, 20)
                               .shadow(color: primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
                       }
                       .disabled(referenceNumber.isEmpty)
                       .opacity(referenceNumber.isEmpty ? 0.6 : 1.0)
                   }
                   
                   // Success Section
                   if isVerified {
                       VStack(spacing: 20) {
                           Image(systemName: "checkmark.circle.fill")
                               .resizable()
                               .scaledToFit()
                               .frame(width: 60, height: 60)
                               .foregroundColor(.green)
                           
                           Text("Verification Successful!")
                               .font(.headline)
                               .foregroundColor(.green)
                           
                           Button(action: onVerificationComplete) {
                               Text(viewEVisaButtonText)
                                   .font(.headline)
                                   .foregroundColor(.white)
                                   .background(AppColors.primary)
                                   .frame(maxWidth: .infinity)
                                   .padding()
                                   .background(Color.green)
                                   .cornerRadius(12)
                                   .padding(.horizontal, 20)
                           }
                       }
                       .padding(.vertical)
                       .transition(.scale)
                   }
                   
                   // Help Card
                   VStack(alignment: .leading, spacing: 15) {
                       HStack {
                           Image(systemName: "questionmark.circle.fill")
                               .foregroundColor(AppColors.secondary)
                               .font(.title2)
                           
                           Text(uanHelpTitle)
                               .font(.headline)
                               .foregroundColor(primaryColor)
                       }
                       
                       Text(uanHelpDescription)
                           .font(.subheadline)
                           .foregroundColor(.secondary)
                   }
                   .padding()
                   .background(cardBackground)
                   .cornerRadius(15)
                   .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                   
                   // Skip Button
                   Button(action: onVerificationComplete) {
                       Text(skipButtonText)
                           .font(.subheadline)
                           .foregroundColor(primaryColor)
                           .padding(.top)
                   }
               }
               .padding()
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .background(backgroundColor)
           }
           .navigationTitle(verificationTitle)
           .navigationBarTitleDisplayMode(.inline)
       }
       
       // ... rest of existing code ...
    func verifyReference() {
        isLoading = true
        showError = false
        
        // Simulate verification process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            let cleanedReference = referenceNumber
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .uppercased()
            
            if cleanedReference == "HO12345678" || cleanedReference == "TEST123" {
                isVerified = true
                showError = false
            } else {
                showError = true
                isVerified = false
            }
        }
    }
    

    // ... (similar localized properties for all text elements)
    
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .background(AppColors.primary)
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
    }
    
    struct SuccessButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .background(AppColors.primary)
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
    }
}
