//
//  SignInView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 11/06/2025.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSignedIn = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sign in to RefugeGuide")
                    .font(.title2)
                    .bold()

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                Button("Sign In") {
                    signIn()
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink("Don’t have an account? Register", destination: RegistrationView())

                if let errorMessage = errorMessage {
                    Text("❌ \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                }

                NavigationLink(destination: MainTabView(), isActive: $isSignedIn) {
                    EmptyView()
                }
            }
            .padding()
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.errorMessage = nil
                self.isSignedIn = true
            }
        }
    }
}
