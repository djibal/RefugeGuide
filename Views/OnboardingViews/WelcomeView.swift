//
//  WelcomeView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//

import SwiftUI

struct WelcomeView: View {
    
    @AppStorage("selectedLanguage") var selectedLanguage: String = ""
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @State private var showUserPathScreen = false

    let languages = ["English", "Arabic", "Farsi", "French", "Ukrainian", "Urdu", "Pashto", "Kurdish"]

    var body: some View {
        NavigationStack {
            if selectedLanguage.isEmpty {
                // Step 1: Language Picker
                VStack(spacing: 20) {
                    Text("Please choose your preferred language")
                        .font(.title2)
                    ForEach(languages, id: \.self) { lang in
                        Button(lang) {
                            selectedLanguage = lang
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
            } else if showUserPathScreen {
                // Step 3: Navigate to user status screen
                UserPathSelectionView()
            } else {
                // Step 2: Welcome message after language selection
                VStack(spacing: 20) {
                    Spacer()
                    Text(welcomeTitle(for: selectedLanguage))
                        .font(.largeTitle)
                        .bold()

                    Text(welcomeMessage(for: selectedLanguage))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)


                    Text("Selected Language: \(selectedLanguage)")
                        .foregroundColor(.gray)

                    Spacer()

                    Button("Continue") {
                        showUserPathScreen = true
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

func welcomeTitle(for lang: String) -> String {
    switch lang {
    case "Arabic": return "مرحبًا بك في RefugeGuide"
    case "French": return "Bienvenue sur RefugeGuide"
    case "Farsi": return "به RefugeGuide خوش آمدید"
    case "Urdu": return "RefugeGuide میں خوش آمدید"
    case "Kurdish": return "Bi xêr hatî RefugeGuide"
    case "Pashto": return "RefugeGuide ته ښه راغلاست"
    default: return "Welcome to RefugeGuide"
    }
}


func welcomeMessage(for lang: String) -> String {
    switch lang {
    case "Arabic": return "دليلك الموثوق في عملية اللجوء داخل المملكة المتحدة."
    case "French": return "Votre guide de confiance pour le processus d'asile au Royaume-Uni."
    case "Farsi": return "راهنمای قابل اعتماد شما در روند پناهندگی در بریتانیا."
    case "Urdu": return "برطانیہ میں پناہ کے عمل کے لیے آپ کا قابل اعتماد ساتھی۔"
    case "Kurdish": return "Rehberê te ya piştrast di pêvajoya penaberî de li UKê."
    case "Pashto": return "ستاسو د پناه غوښتنې پروسې لپاره باوري لارښود په برتانیا کې."
    default: return "Your trusted companion through the UK asylum process."
    }
}
