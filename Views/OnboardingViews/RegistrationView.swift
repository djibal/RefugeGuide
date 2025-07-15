//
//  RegistrationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import SwiftUICore

struct RegistrationView: View {
    var onComplete: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray

    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToPolicy = false
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    var body: some View {
           NavigationView {
               Form {
                   Section(header: Text(personalDetailsTitle)) {
                       TextField(firstNamePlaceholder, text: $firstName)
                       TextField(lastNamePlaceholder, text: $lastName)
                   }
                   
                   Section(header: Text(accountDetailsTitle)) {
                       TextField(emailPlaceholder, text: $email)
                           .keyboardType(.emailAddress)
                           .autocapitalization(.none)
                       
                       SecureField(passwordPlaceholder, text: $password)
                       
                       SecureField(confirmPasswordPlaceholder, text: $confirmPassword)
                   }
                   
                   Section {
                       Toggle(isOn: $agreedToPolicy) {
                           HStack(spacing: 4) {
                               Text(agreementText)
                               Link(policyLinkText, destination: URL(string: "https://refugeguide.org/privacy")!)
                                   .foregroundColor(.accentColor)
                           }
                       }
                   }
                   
                   Section {
                       Button {
                           registerUser()
                       } label: {
                           HStack {
                               Spacer()
                               if isLoading {
                                   ProgressView()
                               } else {
                                   Text(registerButtonText)
                               }
                               Spacer()
                           }
                       }
                       .disabled(!formIsValid || isLoading)
                   }
                   
                   if let errorMessage = errorMessage {
                       Section {
                           Text(errorMessage)
                               .foregroundColor(.red)
                       }
                   }
               }
               .navigationTitle(registrationTitle)
           }
       }
       
       private var formIsValid: Bool {
           !firstName.isEmpty &&
           !lastName.isEmpty &&
           !email.isEmpty &&
           email.contains("@") &&
           password.count >= 8 &&
           password == confirmPassword &&
           agreedToPolicy
       }
       
       func registerUser() {
           isLoading = true
           errorMessage = nil
           
           Auth.auth().createUser(withEmail: email, password: password) { result, error in
               isLoading = false
               
               if let error = error {
                   errorMessage = error.localizedDescription
                   return
               }
               
               // Save additional user data to Firestore
               saveUserProfile()
               
               onComplete()
           }
       }
       
       func saveUserProfile() {
           // Firestore save implementation
           print("User profile saved: \(firstName) \(lastName)")
       }
       
       // MARK: - Localized Content
       
       private var registrationTitle: String {
           switch selectedLanguage {
           case "ar": "التسجيل"
           case "fr": "Inscription"
           case "fa": "ثبت نام"
           case "ku": "تۆمارکردن"
           case "ps": "راجسترېشن"
           case "uk": "Реєстрація"
           case "ur": "رجسٹریشن"
           default: "Registration"
           }
       }
       
       private var personalDetailsTitle: String {
           switch selectedLanguage {
           case "ar": "المعلومات الشخصية"
           case "fr": "Détails personnels"
           case "fa": "اطلاعات شخصی"
           default: "Personal Details"
           }
       }
       
       private var firstNamePlaceholder: String {
           switch selectedLanguage {
           case "ar": "الاسم الأول"
           case "fr": "Prénom"
           case "fa": "نام"
           default: "First Name"
           }
       }
       
       // ... similar localized properties for all text elements ...
   }

// MARK: - Localized Strings

private var personalDetailsTitle: String {
    NSLocalizedString("personalDetailsTitle", comment: "Section title for personal info")
}

private var firstNamePlaceholder: String {
    NSLocalizedString("firstNamePlaceholder", comment: "Enter your first name here")
}

private var lastNamePlaceholder: String {
    NSLocalizedString("lastNamePlaceholder", comment: "Enter your last name here")
}

private var accountDetailsTitle: String {
    NSLocalizedString("accountDetailsTitle", comment: "Section title for account info")
}

private var emailPlaceholder: String {
    NSLocalizedString("emailPlaceholder", comment: "Enter your email address")
}

private var passwordPlaceholder: String {
    NSLocalizedString("passwordPlaceholder", comment: "Enter your password")
}

private var confirmPasswordPlaceholder: String {
    NSLocalizedString("confirmPasswordPlaceholder", comment: "Confirm your password")
}

private var agreementText: String {
    NSLocalizedString("agreementText", comment: "By registering, you agree to our'")
}

private var policyLinkText: String {
    NSLocalizedString("policyLinkText", comment: "Privacy Policy")
}

private var registerButtonText: String {
    NSLocalizedString("registerButtonText", comment: "Register")
}
