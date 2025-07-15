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
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(primaryColor)
            .foregroundColor(.white)
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
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
