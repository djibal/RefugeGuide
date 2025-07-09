//
//  LanguagePickerView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//

import SwiftUI

struct LanguagePickerView: View {
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    var onContinue: () -> Void

    let languages: [(name: String, code: String)] = [
        ("English", "en"),
        ("Arabic", "ar"),
        ("Persian", "fa"),
        ("French", "fr"),
        ("Ukrainian", "uk"),
        ("Urdu", "ur"),
        ("Pashto", "ps"),
        ("Kurdish", "ku")
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Select your preferred language")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .padding()

            Picker("Language", selection: $selectedLanguage) {
                ForEach(languages, id: \.code) { lang in
                    Text(lang.name).tag(lang.code)
                }
            }
            .pickerStyle(WheelPickerStyle())

            Button("Continue") {
                onContinue()
            }
            .padding(.top)
        }
        .padding()
    }
}
