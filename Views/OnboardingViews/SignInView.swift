//
//  SignInView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 11/06/2025.

import FirebaseAuth
import SwiftUI
import AuthenticationServices
import GoogleSignIn
import CryptoKit
import Firebase

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSignedIn = false
    @State private var isLoading = false
    @State private var path = NavigationPath()
    @State private var currentNonce: String?

    var body: some View {
        NavigationStack(path: $path) {
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

                if isLoading {
                    ProgressView()
                } else {
                    Button("Sign In") {
                        signIn()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(email.isEmpty || password.isEmpty)
                }

                Divider().padding(.vertical, 10)

                // Google Sign-In Button
                Button(action: handleGoogleSignIn) {
                    HStack {
                        Image(systemName: "globe") // Placeholder icon
                        Text("Sign in with Google")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                }
                .padding(.horizontal)

                // Apple Sign-In Button
                SignInWithAppleButton(
                    onRequest: { request in
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = sha256(nonce)
                    },
                    onCompletion: handleAppleSignIn
                )
                .frame(height: 48)
                .padding(.horizontal)

                NavigationLink("Don’t have an account? Register", destination: RegistrationView())

                if let errorMessage = errorMessage {
                    Text("❌ \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                }

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
        }
    }

    // MARK: - Email Sign-In
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

    // MARK: - Google Sign-In
    func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "No root view controller found"
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.errorMessage = "Google authentication failed"
                return
            }

            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    path.append("mainTab")
                }
            }
        }
    }

    // MARK: - Apple Sign-In
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let appleID = auth.credential as? ASAuthorizationAppleIDCredential,
               let tokenData = appleID.identityToken,
               let tokenString = String(data: tokenData, encoding: .utf8) {

                let credential = OAuthProvider.credential(
                    providerID: .apple,
                    idToken: tokenString,
                    rawNonce: currentNonce ?? "",
                    accessToken: ""
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

    // MARK: - Apple Sign-In Helpers
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
