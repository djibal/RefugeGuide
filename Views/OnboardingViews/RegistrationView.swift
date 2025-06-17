//
//  RegistrationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//

import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @AppStorage("firstName") private var firstName = ""
    @AppStorage("preferredName") private var preferredName = ""
    @AppStorage("middleName") private var middleName = ""
    @AppStorage("lastName") private var lastName = ""
    @AppStorage("agreedToPolicy") private var agreedToPolicy = false
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personal Details")) {
                    TextField("First Name", text: $firstName)
                    TextField("Preferred Name (optional)", text: $preferredName)
                    TextField("Middle Name (optional)", text: $middleName)
                    TextField("Last Name", text: $lastName)
                }

                Section(header: Text("Account Details")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
                }

                Section {
                    Toggle(isOn: $agreedToPolicy) {
                        HStack(spacing: 4) {
                            Text("I agree to RefugeGuide’s")
                            Link("Data Use Policy", destination: URL(string: "https://refugeguide.org/privacy")!)
                                .foregroundColor(.blue)
                                .underline()
                            Text("per UK GDPR.")
                        }
                    }
                }

                Section {
                    Button {
                        registerUser()
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!formIsValid)
                }

                // Optional: Error message display
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Registration")
        }
    }

    var formIsValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        agreedToPolicy &&
        !email.isEmpty &&
        password.count >= 6
    }

    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = "Registration failed: \(error.localizedDescription)"
                return
            }

            print("✅ User registered: \(result?.user.uid ?? "unknown")")
            // You can navigate to the next screen here if needed
        }
    }
}
