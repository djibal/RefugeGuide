//
//  EVisaView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//

import SwiftUI

struct EVisaView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Profile Image
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .accessibilityLabel("Your photo")

                Text("Your eVisa")
                    .font(.largeTitle)
                    .bold()

                // Immigration Status Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Immigration Status")
                        .font(.headline)

                    Label("Status: Granted", systemImage: "checkmark.shield.fill")
                    Label("Visa Type: Asylum Protection", systemImage: "person.fill.checkmark")
                    Label("Permission to stay: Yes", systemImage: "house.fill")
                    Label("Expiry Date: 12 May 2026", systemImage: "calendar")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Conditions & Rights Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Conditions & Rights")
                        .font(.headline)

                    Label("Right to Work: Yes", systemImage: "briefcase.fill")
                    Label("Right to Rent: Yes", systemImage: "building.2.fill")
                    Label("Eligible for Benefits: Limited", systemImage: "creditcard.fill")
                    Label("Linked Passport: Valid (123456789)", systemImage: "passport")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Share Code + Action
                VStack(alignment: .leading, spacing: 12) {
                    Text("Share Code")
                        .font(.headline)

                    Label("Code: ABCD-1234", systemImage: "doc.on.doc")

                    Button("Copy Share Code") {
                        UIPasteboard.general.string = "ABCD-1234"
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                // Link to UKVI and More Info
                NavigationLink(destination: EVisaInfoView()) {
                    Text("What is an eVisa?")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                }

                Link("Visit UKVI eVisa Portal",
                     destination: URL(string: "https://www.gov.uk/view-prove-immigration-status")!)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("eVisa")
    }
}

#Preview {
    EVisaView()
}
