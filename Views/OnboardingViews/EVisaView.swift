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

import Foundation
import SwiftUI
<<<<<<< HEAD
import FirebaseFirestore
import Combine
import SwiftUICore
import FirebaseAuth


struct EVisaView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    @StateObject private var viewModel = EVisaViewModel()
    @State private var showingForm = false

    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                openGovPortalButton

                if viewModel.eVisaData == nil {
                    addEVisaButton
                } else {
                    manageEVisaSection
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingForm) {
            EVisaFormView(viewModel: viewModel)
        }
        .navigationTitle("eVisa")
        .background(backgroundColor.ignoresSafeArea())
        .onAppear {
            viewModel.loadEVisaData()
        }
    }

    private var openGovPortalButton: some View {
        Button(action: {
            if let url = URL(string: "https://www.gov.uk/view-prove-immigration-status") {
                UIApplication.shared.open(url)
            }
        }) {
            Label("Open UK Government eVisa Portal", systemImage: "link")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.15))
                .foregroundColor(.blue)
                .cornerRadius(10)
        }
    }

    private var addEVisaButton: some View {
        Button(action: { showingForm = true }) {
            Label("Add eVisa Details", systemImage: "plus.circle")
                .padding()
                .frame(maxWidth: .infinity)
                .background(primaryColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }

    private var manageEVisaSection: some View {
        Group {
            if let data = viewModel.eVisaData {
                eVisaDetails(data)
            }

            Button(action: { showingForm = true }) {
                Label("Edit Details", systemImage: "pencil")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: viewModel.loadEVisaData) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Label("Refresh Status", systemImage: "arrow.clockwise")
                }
=======
import FirebaseFunctions

struct EVisaView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
    private let cardBackground = Color.white
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(primaryColor.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "doc.richtext.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(primaryColor)
                        }
                        
                        VStack(spacing: 5) {
                            Text(eVisaTitle)
                                .font(.title2)
                                .bold()
                                .foregroundColor(primaryColor)
                                .lineLimit(nil)
                            
                            Text(eVisaSubtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Status Card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "chart.bar.doc.horizontal")
                                .foregroundColor(primaryColor)
                            
                            Text(statusSectionTitle)
                                .font(.headline)
                                .foregroundColor(primaryColor)
                                .lineLimit(nil)
                        }
                        
                        StatusItem(icon: "envelope.open.fill", label: statusItem1, color: primaryColor)
                        StatusItem(icon: "calendar.badge.clock", label: statusItem2, color: accentColor)
                        StatusItem(icon: "hourglass", label: statusItem3, color: primaryColor)
                        StatusItem(icon: "checkmark.seal.fill", label: statusItem4, color: .green)
                    }
                    .padding()
                    .background(cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    // Share Code
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(primaryColor)
                            
                            Text(shareCodeTitle)
                                .font(.headline)
                                .foregroundColor(primaryColor)
                                .lineLimit(nil)
                        }
                        
                        HStack {
                            Text("ABCD-1234")
                                .font(.title2)
                                .bold()
                                .foregroundColor(primaryColor)
                                .lineLimit(nil)
                            
                            Spacer()
                            
                            Button(action: copyShareCode) {
                                Image(systemName: "doc.on.doc")
                                    .font(.title2)
                                    .foregroundColor(accentColor)
                            }
                        }
                        .padding()
                        .background(Color(.tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        Text(shareCodeDescription)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                    .padding()
                    .background(cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    // Actions
                    VStack(spacing: 15) {
                        NavigationLink(destination: EVisaInfoView()) {
                            ActionButton(
                                title: eVisaInfoButton,
                                icon: "info.circle.fill",
                                color: primaryColor
                            )
                        }
                        
                        Link(destination: URL(string: "https://www.gov.uk/view-prove-immigration-status")!) {
                            ActionButton(
                                title: portalButton,
                                icon: "globe",
                                color: accentColor
                            )
                        }
                    }
                    .padding(.vertical, 10)
                    
                    // Note
                    Text(privacyNote)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .lineLimit(nil)
                }
                .padding()
                .background(backgroundColor.ignoresSafeArea())
                .id("top")
            }
            .onAppear {
                proxy.scrollTo("top", anchor: .top)
            }
        }
        .navigationTitle(eVisaTitle)
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: .constant(false)) {
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
    
    struct StatusItem: View {
        let icon: String
        let label: String
        let color: Color
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 30)
                Text(label)
                    .font(.subheadline)
                    .lineLimit(nil)
            }
            .padding(.vertical, 3)
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
                    .lineLimit(nil)
                Spacer()
                Image(systemName: "arrow.up.forward")
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(primaryColor)
            .foregroundColor(.white)
<<<<<<< HEAD
            .cornerRadius(10)
        }
    }

    private func eVisaDetails(_ data: EVisaData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                HStack {
                    Text("Name:").bold()
                    Spacer()
                    Text(data.fullName)
                }
                HStack {
                    Text("Visa Type:").bold()
                    Spacer()
                    Text(data.visaType)
                }
                HStack {
                    Text("Issuing Country:").bold()
                    Spacer()
                    Text(data.issuingCountry)
                }
                HStack {
                    Text("Issuing Authority:").bold()
                    Spacer()
                    Text(data.issuingAuthority)
                }
                HStack {
                    Text("Expiry Date:").bold()
                    Spacer()
                    Text(data.expiryDate.dateValue().formatted(date: .long, time: .omitted))
                }
                HStack {
                    Text("Status:").bold()
                    Spacer()
                    Text(data.currentStatus)
                }
                HStack {
                    Text("Share Code:").bold()
                    Spacer()
                    Text(data.shareCode)
                }
            }
=======
            .background(color)
            .cornerRadius(12)
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
