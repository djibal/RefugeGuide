//
//  ExistingAsylumVerificationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.

import SwiftUI

struct ExistingAsylumVerificationView: View {
    var onVerificationComplete: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    @State private var referenceNumber = ""
    @State private var isVerified = false
    @State private var showError = false
    @State private var isLoading = false
    

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
        ScrollView {
            VStack(spacing: 30) {
                Text(verificationTitle)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(verificationDescription)
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(uanLabel)
                        .font(.headline)
                    
                    TextField(uanPlaceholder, text: $referenceNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.asciiCapable)
                        .autocapitalization(.allCharacters)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(showError ? Color.red : Color.gray, lineWidth: 1)
                        )
                    
                    if showError {
                        Text(uanError)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button(verifyButtonText) {
                        verifyReference()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(referenceNumber.isEmpty)
                }
                
                if isVerified {
                    Button(viewEVisaButtonText) {
                        onVerificationComplete()
                    }
                    .buttonStyle(SuccessButtonStyle())
                }
                
                Button(skipButtonText) {
                    onVerificationComplete()
                }
                .foregroundColor(.accentColor)
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(uanHelpTitle)
                        .font(.headline)
                    
                    Text(uanHelpDescription)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle(verificationTitle)
    }
    
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
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
    }
}
