//
//  StatusSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//
import SwiftUI

struct StatusSelectionView: View {
    let selectedLanguage: String
    var onStatusSelected: (RefugeeUserType) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(localizedString(selectedLanguage, translations: [
                "en": "Choose your status",
                "ar": "اختر حالتك",
                "fr": "Choisissez votre statut",
                "fa": "وضعیت خود را انتخاب کنید",
                "ur": "اپنی حیثیت منتخب کریں",
                "ps": "خپل وضعیت وټاکئ",
                "uk": "Оберіть свій статус",
                "ku": "Rewşa xwe hilbijêre"
            ]))
            .font(.headline)

            ForEach(RefugeeUserType.primaryOptions, id: \.self) { type in
                Button(action: {
                    onStatusSelected(type)
                }) {
                    Text(type.displayName(for: selectedLanguage))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}


