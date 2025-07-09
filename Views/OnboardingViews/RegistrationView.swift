//
//  RegistrationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    var onComplete: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    
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
        // Firestore save implementation would go here
        print("User profile saved: \(firstName) \(lastName)")
    }
    
    // MARK: - Localized Content
    
    private var registrationTitle: String {
        switch selectedLanguage {
        case "ar": return "التسجيل"
        case "fr": return "Inscription"
        case "fa": return "ثبت نام"
        case "ku": return "تۆمارکردن"
        case "ps": return "راجسترېشن"
        case "uk": return "Реєстрація"
        case "ur": return "رجسٹریشن"
        default: return "Registration"
        }
    }

    
    // ... (similar localized properties for all text elements)
}


// MARK: - Localized Strings

private var personalDetailsTitle: String {
    NSLocalizedString("personalDetailsTitle", comment: "Section title for personal info")
}

private var firstNamePlaceholder: String {
    NSLocalizedString("firstNamePlaceholder", comment: "Placeholder for first name")
}

private var lastNamePlaceholder: String {
    NSLocalizedString("lastNamePlaceholder", comment: "Placeholder for last name")
}

private var accountDetailsTitle: String {
    NSLocalizedString("accountDetailsTitle", comment: "Section title for account info")
}

private var emailPlaceholder: String {
    NSLocalizedString("emailPlaceholder", comment: "Placeholder for email")
}

private var passwordPlaceholder: String {
    NSLocalizedString("passwordPlaceholder", comment: "Placeholder for password")
}

private var confirmPasswordPlaceholder: String {
    NSLocalizedString("confirmPasswordPlaceholder", comment: "Placeholder for confirm password")
}

private var agreementText: String {
    NSLocalizedString("agreementText", comment: "Text for agreeing to terms")
}

private var policyLinkText: String {
    NSLocalizedString("policyLinkText", comment: "Link text for privacy policy")
}

private var registerButtonText: String {
    NSLocalizedString("registerButtonText", comment: "Label for registration button")
}
