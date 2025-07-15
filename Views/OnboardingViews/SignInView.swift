//
//  SignInView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 11/06/2025.

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import GoogleSignIn
import CryptoKit
import FirebaseFunctions  // if needed for GPT/Firestore/etc



struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSignedIn = false
    @State private var isLoading = false
    @State private var path = NavigationPath()
    @State private var currentNonce: String?
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(primaryColor)

                    Text("Sign in to RefugeGuide")
                        .font(.title2)
                        .bold()
                        .foregroundColor(primaryColor)
                }
                .padding(.top, 30)

                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

                    if isLoading {
                        ProgressView().padding()
                    } else {
                        Button("Sign In") {
                            signIn()
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: primaryColor))
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 15) {
                    DividerWithText(text: "Or continue with").padding(.vertical, 10)

                    HStack(spacing: 20) {
                        Button(action: handleGoogleSignIn) {
                            HStack {
                                Image("google-logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 50)
                                Text("Google")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        }

                        SignInWithAppleButton(
                            onRequest: { request in
                                let nonce = randomNonceString()
                                currentNonce = nonce
                                request.requestedScopes = [.fullName, .email]
                                request.nonce = sha256(nonce)
                            },
                            onCompletion: handleAppleSignIn
                        )
                        .frame(height: 50)
                        .signInWithAppleButtonStyle(.black)
                    }
                    if authViewModel.isBiometricLoginAvailable {
                        Button(action: {
                            authViewModel.authenticateWithBiometrics { success in
                                if success {
                                    path.append("mainTab")
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "faceid")
                                Text("Use Face ID")
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: accentColor))
                    }
                }
                .padding(.horizontal)

                HStack {
                    Text("Don't have an account?")
                    NavigationLink("Register", destination: RegistrationView(onComplete: {}))
                        .foregroundColor(primaryColor)
                        .fontWeight(.medium)
                }
                .padding(.top, 10)

                if let errorMessage = errorMessage {
                    Text("❌ \(errorMessage)")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()

                NavigationLink(value: "mainTab") {
                    EmptyView()
                }
                .navigationDestination(for: String.self) { value in
                    if value == "mainTab" {
                        MainTabView()
                    }
                }
            }
            .padding()
            .background(backgroundColor.ignoresSafeArea())
        }
    }

    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                path.append("mainTab")
            }
        }
    }

    func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorMessage = "Missing Google Client ID"
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "No root view controller found"
            return
        }

        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootVC) { user, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken else {
                self.errorMessage = "Google authentication failed"
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: authentication.accessToken
            )

            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    path.append("mainTab")
                }
            }
        }
    }

    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let appleID = auth.credential as? ASAuthorizationAppleIDCredential,
               let tokenData = appleID.identityToken,
               let tokenString = String(data: tokenData, encoding: .utf8) {

                let credential = OAuthProvider.credential(
                    withProviderID: "apple.com",
                    idToken: tokenString,
                    rawNonce: currentNonce ?? ""
                )

                Auth.auth().signIn(with: credential) { result, error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    } else {
                        path.append("mainTab")
                    }
                }
            }

        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }

    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }

    func randomNonceString(length: Int = 32) -> String {
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}

struct DividerWithText: View {
    let text: String

    var body: some View {
        HStack {
            VStack { Divider() }
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
            VStack { Divider() }
        }
    }
}

struct SignInButtonStyle: ButtonStyle {
    let backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .background(AppColors.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .shadow(color: backgroundColor.opacity(0.3), radius: 5, x: 0, y: 3)
            .lineLimit(nil)
    }
}
