//
//  EVisaView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
// MARK: - Static Text Constants

let statusItem1 = "Application Received"
let statusItem2 = "Interview Scheduled"
let statusItem3 = "Decision Pending"
let statusItem4 = "Visa Issued"

let shareCodeTitle = "Your Unique Share Code"
let shareCodeDescription = "Share this code with caseworkers or officials to give them limited access to your case."

let eVisaInfoButton = "View eVisa Info"
let portalButton = "Go to UKVI Portal"
let privacyNote = "Your data is encrypted and securely stored."

import SwiftUI

struct EVisaView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .center) {
                    Image(systemName: "person.crop.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)
                    
                    Text(eVisaTitle)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    
                    Text(eVisaSubtitle)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                
                // Status Card
                VStack(alignment: .leading, spacing: 16) {
                    Text(statusSectionTitle)
                        .font(.headline)
                    
                    StatusItem(icon: "checkmark.shield.fill", label: statusItem1)
                    StatusItem(icon: "calendar", label: statusItem2)
                    StatusItem(icon: "house.fill", label: statusItem3)
                    StatusItem(icon: "briefcase.fill", label: statusItem4)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // Share Code
                VStack(alignment: .leading, spacing: 16) {
                    Text(shareCodeTitle)
                        .font(.headline)
                    
                    HStack {
                        Text("ABCD-1234")
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: copyShareCode) {
                            Image(systemName: "doc.on.doc")
                                .font(.title2)
                        }
                    }
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)
                    
                    Text(shareCodeDescription)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // Actions
                VStack(spacing: 16) {
                    NavigationLink(destination: EVisaInfoView()) {
                        ActionButton(
                            title: eVisaInfoButton,
                            icon: "info.circle",
                            color: .blue
                        )
                    }
                    
                    Link(destination: URL(string: "https://www.gov.uk/view-prove-immigration-status")!) {
                        ActionButton(
                            title: portalButton,
                            icon: "globe",
                            color: .green
                        )
                    }
                }
                .padding(.vertical, 8)
                
                // Note
                Text(privacyNote)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle(eVisaTitle)
        .alert(isPresented: .constant(false)) {
            // We'll use a toast or sheet for copy confirmation
            Alert(title: Text("Copied"))
        }
    }
    
    private func copyShareCode() {
        UIPasteboard.general.string = "ABCD-1234"
        // Show toast
    }
    
    // MARK: - Localized Content
    
    private var eVisaTitle: String {
        switch selectedLanguage {
        case "ar": return "التأشيرة الإلكترونية"
        case "fr": return "eVisa"
        case "fa": return "ویزای الکترونیکی"
        default: return "eVisa"
        }
    }
    
    private var eVisaSubtitle: String {
        switch selectedLanguage {
        case "ar": return "حالة الهجرة الرقمية الخاصة بك في المملكة المتحدة"
        case "fr": return "Votre statut d'immigration numérique au Royaume-Uni"
        case "fa": return "وضعیت دیجیتال مهاجرت شما در بریتانیا"
        default: return "Your UK digital immigration status"
        }
    }
    
    private var statusSectionTitle: String {
        switch selectedLanguage {
        case "ar": return "حالة الهجرة"
        case "fr": return "Statut d'immigration"
        case "fa": return "وضعیت مهاجرت"
        default: return "Immigration Status"
        }
    }
    
    // ... (similar localized properties for all text elements)
    
    struct StatusItem: View {
        let icon: String
        let label: String
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                    .frame(width: 30)
                Text(label)
            }
        }
    }
    
    struct ActionButton: View {
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                Text(title)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "arrow.up.forward")
            }
            .padding()
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(10)
        }
    }
}

struct EVisaView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EVisaView()
        }
    }
}
